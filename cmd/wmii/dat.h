#ifndef CMD_XNJJ_DAT_H__
#define CMD_XNJJ_DAT_H__
/* Copyright ©2007-2014 Kris Maglione <jg@suckless.org>
 * See LICENSE file for license details.
 */

#define _XOPEN_SOURCE 600
#define IXP_NO_P9_
#include <assert.h>
#include <regexp9.h>
#include <stdbool.h>
#include <stdint.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include <limits.h>
#include <utf.h>
extern "C" {
#include <ixp.h>
}
#include <stuff/x.h>
#include <stuff/util.h>
#include "debug.h"

#define FONT		"fixed"
#define FOCUSCOLORS	"#000000 #81654f #000000"
#define NORMCOLORS	"#000000 #c1c48b #81654f"

/* From CGO */
#define assert_equal(x, y) typedef char _##x##_does_not_equal_##y[((x)-(y))*((x)-(y))*-2+1]

enum Barpos {
	BBottom,
	BTop,
};

enum {
	Coldefault, Colstack, Colmax, Collast
};

enum {
	CurNormal,
	CurNECorner, CurNWCorner, CurSECorner, CurSWCorner,
	CurDHArrow, CurDVArrow, CurMove, CurInput, CurSizing,
	CurTCross, CurIcon,
	CurNone,
	CurLast,
};
extern Cursor	cursor[CurLast];

enum IncMode {
	IIgnore,
	IShow,
	ISqueeze,
};

enum {
	PDesktop,
	PExtents,
	PMonitors = PExtents + 4,
	PState = PMonitors + 4,
	PLast = PState + 3
};

enum ClientPermission {
	PermActivate	= 1<<0,
};

enum {
	PingTime = 10000,
	PingPeriod = 4000,
	PingPartition = 10,
};

enum Protocols {
	ProtoDelete	= 1<<0,
	ProtoTakeFocus	= 1<<1,
	ProtoPing	= 1<<2,
};

enum {
	SourceUnknown,
	SourceClient,
	SourcePager
};

enum EWMHType {
	TypeDesktop	= 1<<0,
	TypeDock	= 1<<1,
	TypeToolbar	= 1<<2,
	TypeMenu	= 1<<3,
	TypeUtility	= 1<<4,
	TypeSplash	= 1<<5,
	TypeDialog	= 1<<6,
	TypeNormal	= 1<<7,
};

enum {
	UrgManager,
	UrgClient,
};

extern char*	modes[];

#define toggle(val, x)	\
	((val) = ((x) == On     ? true   : \
		  (x) == Off    ? false  : \
		  (x) == Toggle ? !(val) : (val)))
#define TOGGLE(x) \
	((x) == On     ? "on"     : \
	 (x) == Off    ? "off"    : \
	 (x) == Toggle ? "toggle" : "<toggle>")
enum {
	Never = -1,
	Off,
	On,
	/* Xlib defines this. :( */
	// Always,
	Toggle,
};

assert_equal(Always, 2);

enum {
	NCOL = 16,
};

/* Data Structures */
typedef struct Area Area;
typedef struct Bar Bar;
typedef struct Client Client;
typedef struct Divide Divide;
typedef struct Frame Frame;
typedef struct Group Group;
typedef struct Key Key;
typedef struct Rule Rule;
typedef struct Ruleset Ruleset;
typedef struct Ruleval Ruleval;
typedef struct Strut Strut;
typedef struct View View;
typedef struct WMScreen WMScreen;

struct Area {
	Area*	next;
	Area*	prev;
	Frame*	frame;
	Frame*	frame_old;
	Frame*	stack;
	Frame*	sel;
	View*	view;
	bool	floating;
	ushort	id;
	int	mode;
	int	screen;
	bool	max;
	bool	permanent;
	Rectangle	r;
	Rectangle	r_old;
};

struct Bar {
	Bar*	next;
	Bar*	smaller;
	char	buf[280];
	char	text[256];
	char	name[256];
	int	bar;
	ushort	id;
	CTuple	colors;
	Rectangle	r;
	WMScreen*	screen;
};

struct Client {
	Client*	next;
	Frame*	frame;
	Frame*	sel;
	Window	w;
	Window*	framewin;
	XWindow	trans;
	Regex	tagre;
	Regex	tagvre;
	Group*	group;
	Strut*	strut;
	Cursor	cursor;
	Rectangle configr;
	Rectangle r;
	char**	retags;
	char	_class[256];
	char	name[256];
	char	props[512];
	char	tags[256];
	char	proplen[PLast];
	long	propcache[PLast];
	long	permission;
	long	proto;
	int	border;
	int	dead;
	int	floating;
	int	fullscreen;
	int	pid;
	bool	borderless;
	bool	fixedsize;
	bool	nofocus;
	bool	noinput;
	bool	rgba;
	bool	titleless;
	bool	urgent;
};

struct Divide {
	Divide*	next;
	Window*	w;
	Area*	left;
	Area*	right;
	bool	mapped;
	int	x;
};

struct Frame {
	Frame*	cnext;
	Frame*	anext;
	Frame*	aprev;
	Frame*	anext_old;
	Frame*	snext;
	Frame*	sprev;
	Client*	client;
	View*	view;
	Area*	area;
	int	oldscreen;
	int	oldarea;
	int	screen;
	int	column;
	ushort	id;
	bool	collapsed;
	int	dy;
	Rectangle	r;
	Rectangle	colr;
	Rectangle	colr_old;
	Rectangle	floatr;
	Rectangle	crect;
	Rectangle	grabbox;
	Rectangle	titlebar;
};

struct Group {
	Group*	next;
	XWindow	leader;
	Client*	client;
	int	ref;
};

struct Key {
	Key*	next;
	Key*	lnext;
	Key*	tnext;
	ushort	id;
	char	name[128];
	ulong	mod;
	KeyCode	key;
};

struct Rule {
	Rule*		next;
	Reprog*		regex;
	char*		value;
	Ruleval*	values;
};

struct Ruleset {
	Rule*	rule;
	char*	string;
	uint	size;
};

struct Ruleval {
	Ruleval*	next;
	char*		key;
	char*		value;
};

struct Strut {
	Rectangle	left;
	Rectangle	right;
	Rectangle	top;
	Rectangle	bottom;
};

#define firstarea areas[screen->idx]
#define screenr r[screen->idx]
struct View {
	View*	next;
	char	name[256];
	ushort	id;
	Area*	floating;
	Area**	areas;
	Area*	sel;
	Area*	oldsel;
	Area*	revert;
	int	selcol;
	int	selscreen;
	bool	dead;
	bool	urgent;
	Rectangle *r;
	Rectangle *pad;
};

/* global variables */
typedef struct Defs Defs;
struct Defs {
	CTuple	focuscolor;
	CTuple	normcolor;
	Font*	font;
	char*	keys;
	uint	keyssz;
	Ruleset	colrules;
	Ruleset	rules;
	long	mod;
	uint	border;
	uint	snap;
	int	colmode;
	int	incmode;
};

extern Defs def;

enum {
	BLeft, BRight
};

struct WMScreen {
	Bar*	bar[2];
	Window*	barwin;
	bool	barwin_rgba;
	bool	showing;
	int	barpos;
	int	idx;

	Rectangle r;
	Rectangle brect;
};
extern WMScreen **screens, *screen;
extern uint	nscreens;

struct DispStruct{
	Client*	focus;
	Client*	hasgrab;
	Image*	ibuf;
	Image*	ibuf32;
	bool	sel;
} ;
extern DispStruct disp;

extern Client	c_magic;
extern Client	c_root;
extern Client*	client;
extern Divide*	divs;
extern Key*	key;
extern View*	selview;
extern View*	view;

Handlers& getFramehandler();

/* IXP */
extern IxpServer srv;
extern Ixp9Srv	p9srv;

/* X11 */
extern uint	numlock_mask;
extern uint	valid_mask;

/* Misc */
extern char*	execstr;
extern char	hostname[HOST_NAME_MAX + 1];
extern long	ignoreenter;
extern bool	resizing;
extern int	starting;
extern char*	user;
extern long	nscreens_new;

extern Client*	kludge;

extern char*	debugtab[];
#endif
