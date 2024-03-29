/* Copyright ©2007-2010 Kris Maglione <maglione.k at Gmail>
 * See LICENSE file for license details.
 */
#include "dat.h"
#include <limits.h>
#include "fns.h"

Window *ewmhwin;

static void	ewmh_getwinstate(Client*);
static void	ewmh_setstate(Client*, Atom, int);
static void	tick(long, void*);


static Handlers&	client_handlers();
static Handlers&	root_handlers();

static void
clientprop_long(Client *c, int cache, char *prop, char *type, long *data, int l) {
	if(l != c->proplen[cache] || memcmp(&c->propcache[cache], data, l * sizeof *data)) {
		c->proplen[cache] = l;
		memcpy(&c->propcache[cache], data, l * sizeof *data);
		changeprop_long(&c->w, prop, type, data, l);
	}
}
static void
clientprop_del(Client *c, int cache, char *prop) {
	c->proplen[cache] = 0;
	delproperty(&c->w, prop);
}

void
ewmh_init(void) {
	char myname[] = "wmii";
	long win;

	ewmhwin = createwindow(&scr.root,
		Rect(0, 0, 1, 1), 0 /*depth*/,
		InputOnly, nil, 0);

	win = ewmhwin->xid;
	changeprop_long(&scr.root, Net("SUPPORTING_WM_CHECK"), "WINDOW", &win, 1);
	changeprop_long(ewmhwin, Net("SUPPORTING_WM_CHECK"), "WINDOW", &win, 1);
	changeprop_string(ewmhwin, Net("WM_NAME"), myname);
    long temporary[2] = { 0, 0 };
	changeprop_long(&scr.root, Net("DESKTOP_VIEWPORT"), "CARDINAL", temporary, 2);

	pushhandler(&scr.root, &root_handlers(), nil);

	tick(0L, nil);

	long supported[] = {
		/* Misc */
		NET("SUPPORTED"),
		/* Root Properties/Messages */
		NET("ACTIVE_WINDOW"),
		NET("CLOSE_WINDOW"),
		NET("CURRENT_DESKTOP"),
		/* Client Properties */
		NET("FRAME_EXTENTS"),
		NET("WM_DESKTOP"),
		NET("WM_FULLSCREEN_MONITORS"),
		NET("WM_NAME"),
		NET("WM_PID"),
		NET("WM_STRUT"),
		NET("WM_STRUT_PARTIAL"),
		/* Set this so clients don't update Net("USER_TIME") */
		NET("USER_TIME_WINDOW"),
		/* States */
		NET("WM_STATE"),
		STATE("DEMANDS_ATTENTION"),
		STATE("FULLSCREEN"),
		STATE("SHADED"),
		/* Window Types */
		NET("WM_WINDOW_TYPE"),
		TYPE("DIALOG"),
		TYPE("DOCK"),
		TYPE("NORMAL"),
		TYPE("MENU"),
		TYPE("SPLASH"),
		TYPE("TOOLBAR"),
		/* Actions */
		NET("WM_ALLOWED_ACTIONS"),
		ACTION("FULLSCREEN"),
		/* Desktops */
		NET("DESKTOP_NAMES"),
		NET("NUMBER_OF_DESKTOPS"),
		/* Client List */
		NET("CLIENT_LIST"),
		NET("CLIENT_LIST_STACKING"),
	};
	changeprop_long(&scr.root, Net("SUPPORTED"), "ATOM", supported, nelem(supported));
}

inline bool
ewmh_responsive_p(Client *c) {
	return c->w.ewmh.ping == 0 || (ulong)(nsec() / 1000000) - c->w.ewmh.ping < PingTime;
}

void
ewmh_checkresponsive(Client *c) {

	if(!ewmh_responsive_p(c))
		if(!c->dead)
			frame_draw(c->sel);
		else if(c->dead++ == 1)
			event("Unresponsive %#C\n", c);
}

static void
tick(long id, void *v) {
	static int count;
	Client *c;
	ulong time;
	int mod, i;

	time = nsec() / 1000000;
	count++;
	mod = count % PingPartition;
	for(i=0, c=client; c; c=c->next, i++)
		if(c->proto & ProtoPing) {
			if(!ewmh_responsive_p(c))
				ewmh_checkresponsive(c);
			if(i % PingPartition == mod)
				sendmessage(&c->w, "WM_PROTOCOLS", NET("WM_PING"), time, c->w.xid, 0, 0);
			if(i % PingPartition == mod)
				Dprint(DEwmh, "_NET_WM_PING %#C %,uld\n", c, time);
		}

	ixp_settimer(&srv, PingPeriod / PingPartition, tick, nil);
}

void
ewmh_updateclientlist(void) {
	Vector_long vec;
	Client *c;

	vector_linit(&vec);
	for(c=client; c; c=c->next)
		vector_lpush(&vec, c->w.xid);
	changeprop_long(&scr.root, Net("CLIENT_LIST"), "WINDOW", vec.ary, vec.n);
	free(vec.ary);
}

void
ewmh_updatestacking(void) {
	Vector_long vec;
	Frame *f;
	Area *a;
	View *v;
	int s;

	vector_linit(&vec);

	for(v=view; v; v=v->next) {
		foreach_column(v, s, a)
			for(f=a->frame; f; f=f->anext)
				if(f->client->sel == f)
					vector_lpush(&vec, f->client->w.xid);
	}
	for(v=view; v; v=v->next) {
		for(f=v->floating->stack; f; f=f->snext)
			if(!f->snext) break;
		for(; f; f=f->sprev)
			if(f->client->sel == f)
				vector_lpush(&vec, f->client->w.xid);
	}

	changeprop_long(&scr.root, Net("CLIENT_LIST_STACKING"), "WINDOW", vec.ary, vec.n);
	vector_lfree(&vec);
}

void
ewmh_initclient(Client *c) {
	long allowed[] = {
		ACTION("FULLSCREEN"),
	};

	changeprop_long(&c->w, Net("WM_ALLOWED_ACTIONS"), "ATOM",
		allowed, nelem(allowed));
	ewmh_getwintype(c);
	ewmh_getwinstate(c);
	ewmh_getstrut(c);
	ewmh_framesize(c);
	ewmh_updateclientlist();
	pushhandler(&c->w, &client_handlers(), c);
}

void
ewmh_destroyclient(Client *c) {

	ewmh_updateclientlist();

	free(c->strut);
}

#ifdef notdef
static ulong
usertime(Window *w) {
	long *l;
	long ret;

	ret = 0;
	if(getprop_long(w, Net("WM_USER_TIME_WINDOW"), "CARDINAL", 0, &l, 1)) {
		w = window(*l);
		free(l);
	}
	if(getprop_long(w, Net("WM_USER_TIME"), "CARDINAL", 0, &l, 1)) {
		ret = *l;
		free(l);
	}
	return ret;
}
#endif

static bool
event_client_clientmessage(Window *w, void *aux, XClientMessageEvent *e) {
	ulong *l;
	ulong msg;
	int action;

	auto c = (Client*)aux;
	l = (ulong*)e->data.l;
	msg = e->message_type;
	Dprint(DEwmh, "ClientMessage: %A\n", msg);

	if(msg == NET("WM_STATE")) {
		enum {
			StateUnset,
			StateSet,
			StateToggle,
		};
		if(e->format != 32)
			return false;

		switch(l[0]) {
		case StateUnset:  action = Off;    break;
		case StateSet:    action = On;     break;
		case StateToggle: action = Toggle; break;
		default: return false;
		}

		Dprint(DEwmh, "\tAction: %s\n", TOGGLE(action));
		ewmh_setstate(c, l[1], action);
		ewmh_setstate(c, l[2], action);
		return false;
	}else
	if(msg == NET("ACTIVE_WINDOW")) {
		if(e->format != 32)
			return false;
		Dprint(DEwmh, "\tsource:    %uld\n", l[0]);
		Dprint(DEwmh, "\ttimestamp: %,uld\n", l[1]);
		Dprint(DEwmh, "\tactive:    %#ulx\n", l[2]);
		Dprint(DEwmh, "\twindow:    %#ulx\n", e->window);
		Dprint(DEwmh, "\tclient:    %C\n", c);

		if(l[0] == SourceClient && !(c->permission & PermActivate))
			return false;
		if(l[0] == SourceClient || l[0] == SourcePager)
			focus(c, true);
		return false;
	}else
	if(msg == NET("CLOSE_WINDOW")) {
		if(e->format != 32)
			return false;
		Dprint(DEwmh, "\tsource: %ld\n", l[0]);
		Dprint(DEwmh, "\twindow: %#ulx\n", e->window);
		client_kill(c, true);
		return false;
	}

	return false;
}

static bool
event_client_property(Window *w, void *aux, XPropertyEvent *e) {
	return ewmh_prop((Client*)aux, e->atom);
}

Handlers& 
client_handlers() {
    static Handlers h = {
        .message = event_client_clientmessage,
        .property = event_client_property,
    };
    return h;
} 

bool
ewmh_prop(Client *c, Atom a) {
	if(a == NET("WM_WINDOW_TYPE"))
		ewmh_getwintype(c);
	else
	if(a == NET("WM_STRUT_PARTIAL"))
		ewmh_getstrut(c);
	else
		return true;
	return false;
}

typedef struct Prop Prop;
struct Prop {
	char*	name;
	long	mask;
	Atom	atom;
};

static long
getmask(Prop *props, ulong *vals, int n) {
	Prop *p;
	long ret;

	if(props[0].atom == 0)
		for(p=props; p->name; p++)
			p->atom = xatom(p->name);

	ret = 0;
	while(n--) {
		Dprint(DEwmh, "\tvals[%d] = \"%A\"\n", n, vals[n]);
		for(p=props; p->name; p++)
			if(p->atom == vals[n]) {
				ret |= p->mask;
				break;
			}
	}
	return ret;
}

static long
getprop_mask(Window *w, char *prop, Prop *props) {
	ulong *vals;
	long n, mask;

	n = getprop_ulong(w, prop, "ATOM",
		0L, &vals, 16);
	mask = getmask(props, vals, n);
	free(vals);
	return mask;
}

void
ewmh_getwintype(Client *c) {
	static Prop props[] = {
		{Type("DESKTOP"), TypeDesktop},
		{Type("DOCK"),    TypeDock},
		{Type("TOOLBAR"), TypeToolbar},
		{Type("MENU"),    TypeMenu},
		{Type("UTILITY"), TypeUtility},
		{Type("SPLASH"),  TypeSplash},
		{Type("DIALOG"),  TypeDialog},
		{Type("NORMAL"),  TypeNormal},
		{0, }
	};
	long mask;

	mask = getprop_mask(&c->w, Net("WM_WINDOW_TYPE"), props);

	c->w.ewmh.type = mask;
	if(mask & (TypeDock|TypeMenu|TypeToolbar)) {
		c->borderless = true;
		c->titleless = true;
	}
	if(mask & (TypeSplash|TypeDock))
		c->nofocus = true;
}

static void
ewmh_getwinstate(Client *c) {
	ulong *vals;
	long n;

	n = getprop_ulong(&c->w, Net("WM_STATE"), "ATOM",
		0L, &vals, 16);
	while(--n >= 0)
		ewmh_setstate(c, vals[n], On);
	free(vals);
}

long
ewmh_protocols(Window *w) {
	static Prop props[] = {
		{"WM_DELETE_WINDOW", ProtoDelete},
		{"WM_TAKE_FOCUS", ProtoTakeFocus},
		{Net("WM_PING"), ProtoPing},
		{0, }
	};

	return getprop_mask(w, "WM_PROTOCOLS", props);
}

void
ewmh_getstrut(Client *c) {
	enum {
		Left, Right, Top, Bottom,
		LeftMin, LeftMax,
		RightMin, RightMax,
		TopMin, TopMax,
		BottomMin, BottomMax,
		Last
	};
	long *strut;
	ulong n;

	if(c->strut != nil)
		free(c->strut);
	c->strut = nil;

	n = getprop_long(&c->w, Net("WM_STRUT_PARTIAL"), "CARDINAL",
		0L, &strut, Last);
	if(n != Last) {
		free(strut);
		n = getprop_long(&c->w, Net("WM_STRUT"), "CARDINAL",
			0L, &strut, 4L);
		if(n != 4) {
			free(strut);
			return;
		}
		Dprint(DEwmh, "ewmh_getstrut(%#C[%C]) Using WM_STRUT\n", c, c);
		strut = (decltype(strut))erealloc(strut, Last * sizeof *strut);
		strut[LeftMin] = strut[RightMin] = 0;
		strut[LeftMax] = strut[RightMax] = INT_MAX;
		strut[TopMin] = strut[BottomMin] = 0;
		strut[TopMax] = strut[BottomMax] = INT_MAX;
	}
	c->strut = (decltype(c->strut))emalloc(sizeof *c->strut);
	c->strut->left =   Rect(0,                strut[LeftMin],  strut[Left],      strut[LeftMax]);
	c->strut->right =  Rect(-strut[Right],    strut[RightMin], 0,                strut[RightMax]);
	c->strut->top =    Rect(strut[TopMin],    0,               strut[TopMax],    strut[Top]);
	c->strut->bottom = Rect(strut[BottomMin], -strut[Bottom],  strut[BottomMax], 0);
	Dprint(DEwmh, "ewmh_getstrut(%#C[%C])\n", c, c);
	Dprint(DEwmh, "\ttop: %R\n", c->strut->top);
	Dprint(DEwmh, "\tleft: %R\n", c->strut->left);
	Dprint(DEwmh, "\tright: %R\n", c->strut->right);
	Dprint(DEwmh, "\tbottom: %R\n", c->strut->bottom);
	free(strut);
	view_update(selview);
}

static void
ewmh_setstate(Client *c, Atom state, int action) {

	Dprint(DEwmh, "\tSTATE = %A\n", state);
	if(state == 0)
		return;

	if(state == STATE("FULLSCREEN"))
		fullscreen(c, action, -1);
	else
	if(state == STATE("DEMANDS_ATTENTION"))
		client_seturgent(c, action, UrgClient);
}

static bool
event_root_clientmessage(Window *w, void *aux, XClientMessageEvent *e) {
	Client *c;
	View *v;
	ulong *l;
	ulong msg;
	int i;

	l = (ulong*)e->data.l;
	msg = e->message_type;
	Debug(DEwmh)
		if(msg != xatom("WM_PROTOCOLS") && l[0] != NET("WM_PING"))
			Dprint(DEwmh, "ClientMessage: %A\n", msg);

	if(msg == NET("CURRENT_DESKTOP")) {
		if(e->format != 32)
			return false;
		for(v=view, i=l[0]; v; v=v->next, i--)
			if(i == 0)
				break;
		Dprint(DEwmh, "\t%s\n", v->name);
		if(i == 0)
			view_select(v->name);
		return 1;
	}
	if(msg == xatom("WM_PROTOCOLS")) {
		if(e->format != 32)
			return false;
		if(l[0] == NET("WM_PING")) {
			if(e->window != scr.root.xid)
				return false;
			if(!(c = win2client(l[2])))
				return false;
			i = ewmh_responsive_p(c);
			c->w.ewmh.ping = nsec() / 1000000;
			c->w.ewmh.lag = (c->w.ewmh.ping & 0xffffffff) - (l[1] & 0xffffffff);
			if(i == false)
				frame_draw(c->sel);
			return false;
		}
		return false;
	}

	return false;
}

Handlers&
root_handlers() {
    static Handlers h = {
        .message = event_root_clientmessage,
    };
    return h;
}


void
ewmh_framesize(Client *c) {
	Rectangle rc, rf;
	Frame *f;

	if((f = c->sel)) {
		rc = f->crect;
		rf = f->r;
	}
	else {
		rf = frame_client2rect(c, ZR, c->floating);
		rc = rectsubpt(ZR, rf.min);
	}

	long extents[] = {
		rc.min.x, Dx(rf) - rc.max.x,
		rc.min.y, Dy(rf) - rc.max.y,
	};
	clientprop_long(c, PExtents, Net("FRAME_EXTENTS"), "CARDINAL",
			extents, nelem(extents));
}

void
ewmh_updatestate(Client *c) {
	long state[16];
	Frame *f;
	int i;

	f = c->sel;
	if(f == nil || f->view != selview)
		return;

	i = 0;
	if(f->collapsed)
		state[i++] = STATE("SHADED");
	if(c->fullscreen >= 0)
		state[i++] = STATE("FULLSCREEN");
	if(c->urgent)
		state[i++] = STATE("DEMANDS_ATTENTION");

	if(i > 0)
		clientprop_long(c, PState, Net("WM_STATE"), "ATOM", state, i);
	else
		clientprop_del(c, PState, Net("WM_STATE"));

	if(c->fullscreen >= 0) {
        long temporary[] = { c->fullscreen, c->fullscreen, c->fullscreen, c->fullscreen };
		clientprop_long(c, PMonitors, Net("WM_FULLSCREEN_MONITORS"), "CARDINAL", temporary, 4);
    } else {
		clientprop_del(c, PMonitors, Net("WM_FULLSCREEN_MONITORS"));
    }
}

/* Views */
void
ewmh_updateviews(void) {
	View *v;
	Vector_ptr tags;
	long i;

	if(starting)
		return;

	vector_pinit(&tags);
	for(v=view, i=0; v; v=v->next, i++)
		vector_ppush(&tags, v->name);
	vector_ppush(&tags, nil);
	changeprop_textlist(&scr.root, Net("DESKTOP_NAMES"), "UTF8_STRING", (char**)tags.ary);
	changeprop_long(&scr.root, Net("NUMBER_OF_DESKTOPS"), "CARDINAL", &i, 1);
	vector_pfree(&tags);
	ewmh_updateview();
	ewmh_updateclients();
}

static int
viewidx(View *v) {
	View *vp;
	int i;

	for(vp=view, i=0; vp; vp=vp->next, i++)
		if(vp == v)
			break;
	assert(vp);
	return i;
}

void
ewmh_updateview(void) {
	long i;

	if(starting)
		return;

	i = viewidx(selview);
	changeprop_long(&scr.root, Net("CURRENT_DESKTOP"), "CARDINAL", &i, 1);
}

void
ewmh_updateclient(Client *c) {
	long i;

	i = -1;
	if(c->sel)
		i = viewidx(c->sel->view);
	clientprop_long(c, PDesktop, Net("WM_DESKTOP"), "CARDINAL", &i, 1);
}

void
ewmh_updateclients(void) {
	Client *c;

	if(starting)
		return;

	for(c=client; c; c=c->next)
		ewmh_updateclient(c);
}

