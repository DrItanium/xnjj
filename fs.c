/* (C)opyright MMVI Kris Maglione <fbsdaemon at gmail dot com>
 * See LICENSE file for license details.
 */
#include "wm.h"
#include <assert.h>
#include <stdarg.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <time.h>


/* Datatypes: */
/**************/
typedef struct Dirtab Dirtab;
struct Dirtab {
	char		*name;
	unsigned char	qtype;
	unsigned int	type;
	unsigned int	perm;
};

typedef struct FidLink FidLink;
struct FidLink {
	FidLink *next;
	Fid *fid;
};

typedef struct FileId FileId;
struct FileId {
	FileId		*next;
	union {
		void	*ref;
		char	*buf;
		Bar	*bar;
		Bar	**bar_p;
		View	*view;
		Client	*client;
		Ruleset	*rule;
		BlitzColor	*col;
	};
	unsigned int	id;
	unsigned int	index;
	Dirtab		tab;
	unsigned short	nref;
};

/* Constants */
/*************/
enum {	/* Dirs */
	FsRoot, FsDClient, FsDClients, FsDBars,
	FsDTag, FsDTags,
	/* Files */
	FsFBar, FsFCctl, FsFColRules,
	FsFCtags, FsFEvent, FsFKeys, FsFRctl,
	FsFTagRules, FsFTctl, FsFTindex,
	FsFprops
};

/* Error messages */
static char
	*Enoperm = "permission denied",
	*Enofile = "file not found",
	*Ebadvalue = "bad value",
	*Einterrupted = "interrupted",
	*Ebadcmd = "bad command";

/* Macros */
#define QID(t, i) (((long long)((t)&0xFF)<<32)|((i)&0xFFFFFFFF))

/* Global Vars */
/***************/
FileId *free_fileid = NULL;
P9Req *pending_event_reads = NULL;
FidLink *pending_event_fids;
P9Srv p9srv = {
	.open=	fs_open,
	.walk=	fs_walk,
	.read=	fs_read,
	.stat=	fs_stat,
	.write=	fs_write,
	.clunk=	fs_clunk,
	.flush=	fs_flush,
	.attach=fs_attach,
	.create=fs_create,
	.remove=fs_remove,
	.freefid=fs_freefid
};

/* ad-hoc file tree. Empty names ("") indicate dynamic entries to be filled
 * in by lookup_file */
static Dirtab
dirtab_root[]=	 {{".",		P9QTDIR,	FsRoot,		0500|P9DMDIR },
		  {"rbar",	P9QTDIR,	FsDBars,	0700|P9DMDIR },
		  {"lbar",	P9QTDIR,	FsDBars,	0700|P9DMDIR },
		  {"client",	P9QTDIR,	FsDClients,	0500|P9DMDIR },
		  {"tag",	P9QTDIR,	FsDTags,	0500|P9DMDIR },
		  {"ctl",	P9QTAPPEND,	FsFRctl,	0600|P9DMAPPEND },
		  {"colrules",	P9QTFILE,	FsFColRules,	0600 }, 
		  {"event",	P9QTFILE,	FsFEvent,	0600 },
		  {"keys",	P9QTFILE,	FsFKeys,	0600 },
		  {"tagrules",	P9QTFILE,	FsFTagRules,	0600 }, 
		  {NULL}},
dirtab_clients[]={{".",		P9QTDIR,	FsDClients,	0500|P9DMDIR },
		  {"",		P9QTDIR,	FsDClient,	0500|P9DMDIR },
		  {NULL}},
dirtab_client[]= {{".",		P9QTDIR,	FsDClient,	0500|P9DMDIR },
		  {"ctl",	P9QTAPPEND,	FsFCctl,	0600|P9DMAPPEND },
		  {"tags",	P9QTFILE,	FsFCtags,	0600 },
		  {"props",	P9QTFILE,	FsFprops,	0400 },
		  {NULL}},
dirtab_bars[]=	 {{".",		P9QTDIR,	FsDBars,	0700|P9DMDIR },
		  {"",		P9QTFILE,	FsFBar,		0600 },
		  {NULL}},
dirtab_tags[]=	 {{".",		P9QTDIR,	FsDTags,	0500|P9DMDIR },
		  {"",		P9QTDIR,	FsDTag,		0500|P9DMDIR },
		  {NULL}},
dirtab_tag[]=	 {{".",		P9QTDIR,	FsDTag,		0500|P9DMDIR },
		  {"ctl",	P9QTAPPEND,	FsFTctl,	0600|P9DMAPPEND },
		  {"index",	P9QTFILE,	FsFTindex,	0400 },
		  {NULL}};
/* Writing the lists separately and using an array of their references
 * removes the need for casting and allows for C90 conformance,
 * since otherwise we would need to use compound literals */
static Dirtab *dirtab[] = {
	[FsRoot]	dirtab_root,
	[FsDBars]	dirtab_bars,
	[FsDClients]	dirtab_clients,
	[FsDClient]	dirtab_client,
	[FsDTags]	dirtab_tags,
	[FsDTag]	dirtab_tag,
};

/* Utility Functions */
/*********************/

/* get_file/free_file save and reuse old FileId structs
 * since so many of them are needed for so many
 * purposes */
static FileId *
get_file() {
	FileId *temp;
	if(!free_fileid) {
		unsigned int i = 15;
		temp = ixp_emallocz(sizeof(FileId) * i);
		for(; i; i--) {
			temp->next = free_fileid;
			free_fileid = temp++;
		}
	}
	temp = free_fileid;
	free_fileid = temp->next;
	temp->nref = 1;
	temp->next = NULL;
	return temp;
}

static void
free_file(FileId *f) {
	if(--f->nref)
		return;
	free(f->tab.name);
	f->next = free_fileid;
	free_fileid = f;
}

/* This function's name belies it's true purpose. It increases
 * the reference counts of the FileId list */
static void
clone_files(FileId *f) {
	for(; f; f=f->next)
		assert(f->nref++);
}

/* This should be moved to libixp */
static void
write_buf(P9Req *r, void *buf, unsigned int len) {
	if(r->ifcall.offset >= len)
		return;

	len -= r->ifcall.offset;
	if(len > r->ifcall.count)
		len = r->ifcall.count;
	r->ofcall.data = ixp_emalloc(len);
	memcpy(r->ofcall.data, buf + r->ifcall.offset, len);
	r->ofcall.count = len;
}

/* This should be moved to libixp */
void
write_to_buf(P9Req *r, void *buf, unsigned int *len, unsigned int max) {
	unsigned int offset, count;

	offset = (r->fid->omode&P9OAPPEND) ? *len : r->ifcall.offset;
	if(offset > *len || r->ifcall.count == 0) {
		r->ofcall.count = 0;
		return;
	}

	count = r->ifcall.count;
	if(max && (count > max - offset))
		count = max - offset;

	*len = offset + count;
	
	if(max == 0) {
		*(void **)buf = ixp_erealloc(*(void **)buf, *len + 1);
		buf = *(void **)buf;
	}
		
	memcpy(buf + offset, r->ifcall.data, count);
	r->ofcall.count = count;
	((char *)buf)[offset+count] = '\0';
}

/* This should be moved to libixp */
void
data_to_cstring(P9Req *r) {
	unsigned int i;
	i = r->ifcall.count;
	if(!i || r->ifcall.data[i - 1] != '\n')
		r->ifcall.data = ixp_erealloc(r->ifcall.data, ++i);
	assert(r->ifcall.data);
	r->ifcall.data[i - 1] = '\0';
}

/* This should be moved to liblitz */
char *
parse_colors(char **buf, int *buflen, BlitzColor *col) {
	unsigned int i;
	if(*buflen < 23 || 3 != sscanf(*buf, "#%06x #%06x #%06x", &i,&i,&i))
		return Ebadvalue;
	(*buflen) -= 23;
	bcopy(*buf, col->colstr, 23);
	loadcolor(&blz, col);

	(*buf) += 23;
	if(**buf == '\n' || **buf == ' ') {
		(*buf)++;
		(*buflen)--;
	}
	return NULL;
}

char *
message_root(char *message)
{
	unsigned int n;

	if(!strchr(message, ' ')) {
		snprintf(buffer, BUFFER_SIZE, "%s ", message);
		message = buffer;
	}
	if(!strncmp(message, "quit ", 5))
		srv.running = 0;
	else if(!strncmp(message, "view ", 5))
		select_view(&message[5]);
	else if(!strncmp(message, "selcolors ", 10)) {
		message += 10;
		n = strlen(message);
		return parse_colors(&message, (int *)&n, &def.selcolor);
	}
	else if(!strncmp(message, "normcolors ", 11)) {
		message += 11;
		n = strlen(message);
		return parse_colors(&message, (int *)&n, &def.normcolor);
	}
	else if(!strncmp(message, "b1colors ", 9)) {
		message += 9;
		n = strlen(message);
		return parse_colors(&message, (int *)&n, &def.bcolor[0]);
	}
	else if(!strncmp(message, "b2colors ", 9)) {
		message += 9;
		n = strlen(message);
		return parse_colors(&message, (int *)&n, &def.bcolor[1]);
	}
	else if(!strncmp(message, "b3colors ", 9)) {
		message += 9;
		n = strlen(message);
		return parse_colors(&message, (int *)&n, &def.bcolor[2]);
	}
	else if(!strncmp(message, "font ", 5)) {
		message += 5;
		free(def.font.fontstr);
		def.font.fontstr = ixp_estrdup(message);
		loadfont(&blz, &def.font);
	}
	else if(!strncmp(message, "border ", 7)) {
		message += 7;
		n = (unsigned int)strtol(message, &message, 10);
		if(*message)
			return Ebadvalue;
		def.border = n;
	}
	else if(!strncmp(message, "grabmod ", 8)) {
		message += 8;
		unsigned long mod;
		mod = mod_key_of_str(message);
		if(!(mod & (Mod1Mask|Mod2Mask|Mod3Mask|Mod4Mask|Mod5Mask)))
			return Ebadvalue;
		strncpy(def.grabmod, message, sizeof(def.grabmod));
		def.mod = mod;
		if(view)
			restack_view(screen->sel);
	}
	else
		return Ebadcmd;
	return NULL;
}

char *
read_root_ctl() {
	unsigned int i = 0;
	if(screen->sel)
		i += snprintf(&buffer[i], (BUFFER_SIZE - i), "view %s\n", screen->sel->name);
	i += snprintf(&buffer[i], (BUFFER_SIZE - i), "selcolors %s\n", def.selcolor.colstr);
	i += snprintf(&buffer[i], (BUFFER_SIZE - i), "normcolors %s\n", def.normcolor.colstr);
	i += snprintf(&buffer[i], (BUFFER_SIZE - i), "font %s\n", def.font.fontstr);
	i += snprintf(&buffer[i], (BUFFER_SIZE - i), "grabmod %s\n", def.grabmod);
	i += snprintf(&buffer[i], (BUFFER_SIZE - i), "border %d\n", def.border);
	return buffer;
}


void
respond_event(P9Req *r) {
	FileId *f = r->fid->aux;
	if(f->buf) {
		r->ofcall.data = (void *)f->buf;
		r->ofcall.count = strlen(f->buf);
		respond(r, NULL);
		f->buf = NULL;
	}else{
		r->aux = pending_event_reads;
		pending_event_reads = r;
	}
}

void
write_event(char *format, ...) {
	unsigned int len, slen;
	va_list ap;
	FidLink *f;
	FileId *fi;
	P9Req *aux;

	va_start(ap, format);
	vsnprintf(buffer, BUFFER_SIZE, format, ap);
	va_end(ap);
	if(!(len = strlen(buffer)))
		return;
	for(f=pending_event_fids; f; f=f->next) {
		fi = f->fid->aux;
		slen = fi->buf ? strlen(fi->buf) : 0;
		fi->buf = ixp_erealloc(fi->buf, slen + len + 1);
		fi->buf[slen] = '\0';
		strcat(fi->buf, buffer);
	}
	while((aux = pending_event_reads)) {
		pending_event_reads = pending_event_reads->aux;
		respond_event(aux);
	}
}

static void
dostat(Stat *s, unsigned int len, FileId *f) {
	s->type = 0;
	s->dev = 0;
	s->qid.path = QID(f->tab.type, f->id);
	s->qid.version = 0;
	s->qid.type = f->tab.qtype;
	s->mode = f->tab.perm;
	s->atime = time(NULL);
	s->mtime = time(NULL);
	s->length = len;
	s->name = f->tab.name;
	s->uid = user;
	s->gid = user;
	s->muid = user;
}

/* lookup_file */
/***************/
/* All lookups and directory organization should be performed through
 * lookup_file, mostly through the dirtabs[] tree. */
static FileId *
lookup_file(FileId *parent, char *name)
{
	FileId *ret, *file, **last;
	Dirtab *dir;
	Client *c;
	View *v;
	Bar *b;
	unsigned int i, id;

	if(!(parent->tab.perm & P9DMDIR))
		return NULL;
	dir = dirtab[parent->tab.type];
	last = &ret;
	ret = NULL;
	for(; dir->name; dir++) {
		/* Dynamic dirs */
		if(!*dir->name) { /* strlen(dir->name) == 0 */
			switch(parent->tab.type) {
			case FsDClients:
				if(!name || !strncmp(name, "sel", 4)) {
					if((c = sel_client())) {
						file = get_file();
						*last = file;
						last = &file->next;
						file->ref = c;
						file->id = c->id;
						file->index = idx_of_client(c);
						file->tab = *dir;
						file->tab.name = ixp_estrdup("sel");
					}if(name) goto LastItem;
				}
				if(name) {
					id = (unsigned int)strtol(name, &name, 10);
					if(*name) goto NextItem;
				}
				i=0;
				for(c=client; c; c=c->next, i++) {
					if(!name || i == id) {
						file = get_file();
						*last = file;
						last = &file->next;
						file->ref = c;
						file->id = c->id;
						file->tab = *dir;
						file->tab.name = ixp_emallocz(16);
						snprintf(file->tab.name, 16, "%d", i);
						if(name) goto LastItem;
					}
				}
				break;
			case FsDTags:
				if(!name || !strncmp(name, "sel", 4)) {
					if(screen->sel) {
						file = get_file();
						*last = file;
						last = &file->next;
						file->ref = screen->sel;
						file->id = screen->sel->id;
						file->tab = *dir;
						file->tab.name = ixp_estrdup("sel");
					}if(name) goto LastItem;
				}
				for(v=view; v; v=v->next) {
					if(!name || !strcmp(name, v->name)) {
						file = get_file();
						*last = file;
						last = &file->next;
						file->ref = v;
						file->id = v->id;
						file->tab = *dir;
						file->tab.name = ixp_estrdup(v->name);
						if(name) goto LastItem;
					}
				}
				break;
			case FsDBars:
				for(b=*parent->bar_p; b; b=b->next) {
					if(!name || !strcmp(name, b->name)) {
						file = get_file();
						*last = file;
						last = &file->next;
						file->ref = b;
						file->id = b->id;
						file->tab = *dir;
						file->tab.name = ixp_estrdup(b->name);
						if(name) goto LastItem;
					}
				}
				break;
			}
		}else /* Static dirs */
		if(!name || !strcmp(name, dir->name)) {
			file = get_file();
			*last = file;
			last = &file->next;
			file->id = 0;
			file->ref = parent->ref;
			file->index = parent->index;
			file->tab = *dir;
			file->tab.name = ixp_estrdup(file->tab.name);
			/* Special considerations: */
			switch(file->tab.type) {
			case FsDBars:
				if(!strncmp(file->tab.name, "lbar", 5))
					file->ref = &screen[0].lbar;
				else
					file->ref = &screen[0].rbar;
				break;
			case FsFColRules:
				file->ref = &def.colrules;
				break;
			case FsFTagRules:
				file->ref = &def.tagrules;
				break;
			}
			if(name) goto LastItem;
		}
	NextItem:
		continue;
	}
LastItem:
	*last = NULL;
	return ret;
}

/* Service Functions */
/*********************/
void
fs_attach(P9Req *r) {
	FileId *f = get_file();
	f->tab = dirtab[FsRoot][0];
	f->tab.name = ixp_estrdup("/");
	f->ref = NULL; /* shut up valgrind */
	r->fid->aux = f;
	r->fid->qid.type = f->tab.qtype;
	r->fid->qid.path = QID(f->tab.type, 0);
	r->ofcall.qid = r->fid->qid;
	respond(r, NULL);
}

void
fs_walk(P9Req *r) {
	FileId *f, *nf;
	int i;

	f = r->fid->aux;
	clone_files(f);
	for(i=0; i < r->ifcall.nwname; i++) {
		if(!strncmp(r->ifcall.wname[i], "..", 3)) {
			if(f->next) {
				nf=f;
				f=f->next;
				free_file(nf);
			}
		}else{
			nf = lookup_file(f, r->ifcall.wname[i]);
			if(!nf)
				break;
			assert(!nf->next);
			if(strncmp(r->ifcall.wname[i], ".", 2)) {
				nf->next = f;
				f = nf;
			}
		}
		r->ofcall.wqid[i].type = f->tab.qtype;
		r->ofcall.wqid[i].path = QID(f->tab.type, f->id);
	}
	/* There should be a way to do this on freefid() */
	if(i < r->ifcall.nwname) {
		while((nf = f)) {
			f=f->next;
			free_file(nf);
		}
		return respond(r, Enofile);
	}
	/* Remove refs for r->fid if no new fid */
	/* If Fids were ref counted, this could be
	 * done in their decref function */
	if(r->ifcall.fid == r->ifcall.newfid) {
		nf=r->fid->aux;
		r->fid->aux = f;
		while((nf = f)) {
			f=f->next;
			free_file(nf);
		}
	}
	r->newfid->aux = f;
	r->ofcall.nwqid = i;
	respond(r, NULL);
}

unsigned int
fs_size(FileId *f) {
	switch(f->tab.type) {
	default:
		return 0;
	case FsFColRules:
	case FsFTagRules:
		return f->rule->size;
	case FsFKeys:
		return def.keyssz;
	case FsFCtags:
		return strlen(f->client->tags);
	case FsFprops:
		return strlen(f->client->props);
	}
}

void
fs_stat(P9Req *r) {
	Stat s;
	int size;
	unsigned char *buf;

	dostat(&s, fs_size(r->fid->aux), r->fid->aux);
	r->ofcall.nstat = size = ixp_sizeof_stat(&s);
	buf = ixp_emallocz(size);
	r->ofcall.stat = buf;
	ixp_pack_stat(&buf, &size, &s);
	respond(r, NULL);
}

void
fs_read(P9Req *r) {
	char *buf;
	FileId *f, *tf;
	int n, offset;
	int size;

	offset = 0;
	f = r->fid->aux;
	if(f->tab.perm & P9DMDIR && f->tab.perm & 0400) {
		Stat s;
		offset = 0;
		size = r->ifcall.count;
		buf = ixp_emallocz(size);
		r->ofcall.data = buf;
		tf = f = lookup_file(f, NULL);
		/* Note: f->tab.name == "." so we skip it */
		for(f=f->next; f; f=f->next) {
			dostat(&s, fs_size(f), f);
			n = ixp_sizeof_stat(&s);
			if(offset >= r->ifcall.offset) {
				if(size < n)
					break;
				ixp_pack_stat((unsigned char **)&buf, &size, &s);
			}
			offset += n;
		}
		while((f = tf)) {
			tf=tf->next;
			free_file(f);
		}
		r->ofcall.count = r->ifcall.count - size;
		return respond(r, NULL);
	}
	else{
		switch(f->tab.type) {
		case FsFprops:
			write_buf(r, (void *)f->client->props, strlen(f->client->props));
			return respond(r, NULL);
		case FsFColRules:
		case FsFTagRules:
			write_buf(r, (void *)f->rule->string, f->rule->size);
			return respond(r, NULL);
		case FsFKeys:
			write_buf(r, (void *)def.keys, def.keyssz);
			return respond(r, NULL);
		case FsFCtags:
			write_buf(r, (void *)f->client->tags, strlen(f->client->tags));
			return respond(r, NULL);
		case FsFTctl:
			write_buf(r, (void *)f->view->name, strlen(f->view->name));
			return respond(r, NULL);
		case FsFBar:
			write_buf(r, (void *)f->bar->buf, strlen(f->bar->buf));
			return respond(r, NULL);
		case FsFRctl:
			buf = read_root_ctl();
			write_buf(r, buf, strlen(buf));
			return respond(r, NULL);
		case FsFCctl:
			if(r->ifcall.offset)
				return respond(r, NULL);
			r->ofcall.data = ixp_emallocz(16);
			n = snprintf(r->ofcall.data, 16, "%d", f->index);
			assert(n >= 0);
			r->ofcall.count = n;
			return respond(r, NULL);
		case FsFTindex:
			buf = (char *)view_index(f->view);
			n = strlen(buf);
			write_buf(r, (void *)buf, n);
			return respond(r, NULL);
		case FsFEvent:
			respond_event(r);
			return;
		}
	}
	/* This is an assert because it should this should not be called if
	 * the file is not open for reading. */
	assert(!"Read called on an unreadable file");
}

/* This function needs to be seriously cleaned up */
void
fs_write(P9Req *r) {
	FileId *f;
	char *errstr = NULL;
	unsigned int i;

	if(r->ifcall.count == 0)
		return respond(r, NULL);
	f = r->fid->aux;
	switch(f->tab.type) {
	case FsFColRules:
	case FsFTagRules:
		write_to_buf(r, &f->rule->string, &f->rule->size, 0);
		return respond(r, NULL);
	case FsFKeys:
		write_to_buf(r, &def.keys, &def.keyssz, 0);
		return respond(r, NULL);
	case FsFCtags:
		data_to_cstring(r);
		i=strlen(f->client->tags);
		write_to_buf(r, &f->client->tags, &i, 255);
		r->ofcall.count = i- r->ifcall.offset;
		return respond(r, NULL);
	case FsFBar:
		/* XXX: This should validate after each write */
		i = strlen(f->bar->buf);
		write_to_buf(r, &f->bar->buf, &i, 279);
		r->ofcall.count = i - r->ifcall.offset;
		return respond(r, NULL);
	case FsFCctl:
		data_to_cstring(r);
		if((errstr = message_client(f->client, r->ifcall.data)))
			return respond(r, errstr);
		r->ofcall.count = r->ifcall.count;
		return respond(r, NULL);
	case FsFTctl:
		data_to_cstring(r);
		if((errstr = message_view(f->view, r->ifcall.data)))
			return respond(r, errstr);
		r->ofcall.count = r->ifcall.count;
		return respond(r, NULL);
	case FsFRctl:
		data_to_cstring(r);
		{	unsigned int n;
			char *toks[32];
			n = ixp_tokenize(toks, 32, r->ifcall.data, '\n');
			for(i = 0; i < n; i++) {
				if(errstr)
					message_root(toks[i]);
				else
					errstr = message_root(toks[i]);
			}
		}
		if(errstr)
			return respond(r, errstr);
		r->ofcall.count = r->ifcall.count;
		return respond(r, NULL);
	case FsFEvent:
		if(r->ifcall.data[r->ifcall.count-1] == '\n')
			write_event("%.*s", r->ifcall.count, r->ifcall.data);
		else
			write_event("%.*s\n", r->ifcall.count, r->ifcall.data);
		r->ofcall.count = r->ifcall.count;
		return respond(r, NULL);
	}
	/* This is an assert because it should this should not be called if
	 * the file is not open for writing. */
	assert(!"Write called on an unwritable file");
}

void
fs_open(P9Req *r) {
	FidLink *fl;
	FileId *f = r->fid->aux;

	switch(f->tab.type) {
	case FsFEvent:
		fl = ixp_emallocz(sizeof(FidLink));
		fl->fid = r->fid;
		fl->next = pending_event_fids;
		pending_event_fids = fl;
		break;
	}
	if((r->ifcall.mode&3) == P9OEXEC)
		return respond(r, Enoperm);
	if((r->ifcall.mode&3) != P9OREAD && !(f->tab.perm & 0200))
		return respond(r, Enoperm);
	if((r->ifcall.mode&3) != P9OWRITE && !(f->tab.perm & 0400))
		return respond(r, Enoperm);
	if((r->ifcall.mode&~(3|P9OAPPEND|P9OTRUNC)))
		return respond(r, Enoperm);
	respond(r, NULL);
}

void
fs_create(P9Req *r) {
	FileId *f = r->fid->aux;

	switch(f->tab.type) {
	default:
		/* XXX: This should be taken care of by the library */
		return respond(r, Enoperm);
	case FsDBars:
		if(!strlen(r->ifcall.name))
			return respond(r, Ebadvalue);
		create_bar(f->bar_p, r->ifcall.name);
		f = lookup_file(f, r->ifcall.name);
		if(!f)
			return respond(r, Enofile);
		r->ofcall.qid.type = f->tab.qtype;
		r->ofcall.qid.path = QID(f->tab.type, f->id);
		f->next = r->fid->aux;
		r->fid->aux = f;
		respond(r, NULL);
		break;
	}
}

void
fs_remove(P9Req *r) {
	FileId *f = r->fid->aux;

	switch(f->tab.type) {
	default:
		/* XXX: This should be taken care of by the library */
		return respond(r, Enoperm);
	case FsFBar:
		destroy_bar(f->next->bar_p, f->bar);
		draw_bar(screen);
		respond(r, NULL);
		break;
	}
}

void
fs_clunk(P9Req *r) {
	Client *c;
	FidLink **fl, *ft;
	char *buf;
	int i;
	FileId *f = r->fid->aux;

	switch(f->tab.type) {
	case FsFColRules:
		update_rules(&f->rule->rule, f->rule->string);
		break;
	case FsFTagRules:
		update_rules(&f->rule->rule, f->rule->string);
		for(c=client; c; c=c->next)
			apply_rules(c);
		update_views();
		break;
	case FsFKeys:
		update_keys();
		break;
	case FsFCtags:
		apply_tags(f->client, f->client->tags);
		update_views();
		draw_frame(f->client->sel);
		break;
	case FsFBar:
		buf = f->bar->buf;
		i = strlen(f->bar->buf);
		parse_colors(&buf, &i, &f->bar->brush.color);
		while(i > 0 && buf[i - 1] == '\n')
			buf[--i] = '\0';
		strncpy(f->bar->text, buf, sizeof(f->bar->text));
		draw_bar(screen);
		break;
	case FsFEvent:
		for(fl=&pending_event_fids; *fl; fl=&(*fl)->next)
			if((*fl)->fid == r->fid) {
				ft = *fl;
				*fl = (*fl)->next;
				f = ft->fid->aux;
				free(f->buf);
				free(ft);
				break;
			}
		break;
	}
	respond(r, NULL);
}

void
fs_flush(P9Req *r) {
	P9Req **t;

	for(t=&pending_event_reads; *t; t=(P9Req **)&(*t)->aux)
		if(*t == r->oldreq) {
			*t = (*t)->aux;
			respond(r->oldreq, Einterrupted);
			break;
		}
	respond(r, NULL);
}

void
fs_freefid(Fid *f) {
	FileId *id, *tid;

	for(id=f->aux; id; id = tid) {
		tid = id->next;
		free_file(id);
	}
}