include config.mk
INCLUDES := -I.
DEBUGCFLAGS = \
	-g \
	-O0 \
	-fno-builtin \
	-fno-inline \
	-fno-omit-frame-pointer \
	-fno-optimize-sibling-calls \
	-fno-unroll-loops
CFLAGS += \
	-std=c99 \
	-pedantic \
	-pipe \
	-fno-strict-aliasing \
	-Wall \
	-Wimplicit \
	-Wmissing-prototypes \
	-Wno-comment \
	-Wno-missing-braces \
	-Wno-parentheses \
	-Wno-sign-compare \
	-Wno-switch \
	-Wpointer-arith \
	-Wreturn-type \
	-Wstrict-prototypes \
	-Wtrigraphs \
	${INCLUDES}
MKDEP = cpp -M
SOCFLAGS += -fPIC

SETFOCUS_OBJECTS := setfocus.o
WIKEYNAME_OBJECTS := wikeyname.o
WIWARP_OBJECTS := wiwarp.o
WMII9MENU_OBJECTS := wmii9menu.o

X11_OBJECTS := ${SETFOCUS_OBJECTS} \
			   ${WIKEYNAME_OBJECTS} \
			   ${WIWARP_OBJECTS} \
			   ${WMII9MENU_OBJECTS}

STUFFLIB_OBJECTS = 
    	buffer.o		\
	clientutil.o	\
	client_readconfig.o	\
	event/buttonpress.o	\
	event/buttonrelease.o	\
	event/clientmessage.o	\
	event/configurenotify.o	\
	event/configurerequest.o	\
	event/destroynotify.o	\
	event/enternotify.o	\
	event/event.o 	\
	event/expose.o		\
	event/focusin.o		\
	event/focusout.o		\
	event/ixp.o		\
	event/keypress.o		\
	event/keyrelease.o	\
	event/leavenotify.o	\
	event/mapnotify.o		\
	event/maprequest.o	\
	event/mappingnotify.o	\
	event/motionnotify.o	\
	event/propertynotify.o	\
	event/reparentnotify.o	\
	event/selection.o		\
	event/selectionclear.o	\
	event/selectionrequest.o	\
	event/unmapnotify.o	\
	event/xtime.o		\
	fmt/blprint.o		\
	fmt/bvlprint.o		\
	fmt/fmtbuf.o		\
	fmt/localefmt.o		\
	fmt/localelen.o		\
	fmt/lprint.o		\
	fmt/vlprint.o		\
	geom/get_sticky.o		\
	geom/quadrant.o		\
	geom/rect_contains_p.o	\
	geom/rect_haspoint_p.o	\
	geom/rect_intersect_p.o	\
	geom/rect_intersection.o	\
	init_screens.o	\
	map.o		\
	printevent.o	\
	util/_die.o	\
	util/closeexec.o	\
	util/comm.o	\
	util/doublefork.o	\
	util/emalloc.o	\
	util/emallocz.o	\
	util/erealloc.o	\
	util/estrdup.o	\
	util/estrndup.o	\
	util/fatal.o	\
	util/freelater.o	\
	util/getbase.o	\
	util/getint.o	\
	util/getlong.o	\
	util/getulong.o	\
	util/grep.o	\
	util/join.o	\
	util/max.o	\
	util/mfatal.o	\
	util/min.o	\
	util/nsec.o	\
	util/pathsearch.o	\
	util/refree.o	\
	util/reinit.o	\
	util/spawn3.o	\
	util/spawn3l.o	\
	util/stokenize.o	\
	util/strcasestr.o	\
	util/strend.o	\
	util/strlcat.o	\
	util/strlcatprint.o	\
	util/sxprint.o	\
	util/tokenize.o	\
	util/trim.o	\
	util/uniq.o	\
	util/unmask.o	\
	util/unquote.o	\
	util/utflcpy.o	\
	util/vector.o	\
	util/vsxprint.o	\
	x11/convpts.o	\
	x11/errors.o	\
	x11/ignored_xerrors.o	\
	x11/freestringlist.o	\
	x11/initdisplay.o	\
	x11/selection.o	\
	x11/sendevent.o	\
	x11/sendmessage.o	\
	x11/sync.o	\
	x11/x11.o		\
	x11/xatom.o	\
	x11/xft.o		\
	x11/colors/loadcolor.o	\
	x11/colors/parsecolor.o	\
	x11/colors/xftcolor.o	\
	x11/drawing/border.o	\
	x11/drawing/drawline.o	\
	x11/drawing/drawpoly.o	\
	x11/drawing/drawstring.o	\
	x11/drawing/fill.o	\
	x11/drawing/fillpoly.o	\
	x11/drawing/setgccol.o	\
	x11/focus/getfocus.o	\
	x11/focus/setfocus.o	\
	x11/geometry/XRect.o	\
	x11/geometry/addpt.o	\
	x11/geometry/divpt.o	\
	x11/geometry/eqpt.o	\
	x11/geometry/eqrect.o	\
	x11/geometry/insetrect.o	\
	x11/geometry/mulpt.o	\
	x11/geometry/rectaddpt.o	\
	x11/geometry/rectsetorigin.o	\
	x11/geometry/rectsubpt.o	\
	x11/geometry/subpt.o	\
	x11/images/allocimage.o	\
	x11/images/copyimage.o	\
	x11/images/freeimage.o	\
	x11/images/xftdrawable.o	\
	x11/insanity/gravitate.o	\
	x11/insanity/gethints.o	\
	x11/insanity/sethints.o	\
	x11/insanity/sizehint.o	\
	x11/keyboard/grabkeyboard.o	\
	x11/keyboard/ungrabkeyboard.o	\
	x11/keys/keycode.o	\
	x11/keys/parsekey.o	\
	x11/mouse/grabpointer.o	\
	x11/mouse/pointerscreen.o	\
	x11/mouse/querypointer.o	\
	x11/mouse/translate.o	\
	x11/mouse/ungrabpointer.o	\
	x11/mouse/warppointer.o	\
	x11/properties/changeprop_char.o	\
	x11/properties/changeprop_long.o	\
	x11/properties/changeprop_short.o	\
	x11/properties/changeprop_string.o	\
	x11/properties/changeprop_textlist.o	\
	x11/properties/changeprop_ulong.o	\
	x11/properties/changeproperty.o	\
	x11/properties/delproperty.o	\
	x11/properties/getprop.o	\
	x11/properties/getprop_long.o	\
	x11/properties/getprop_string.o	\
	x11/properties/getprop_textlist.o	\
	x11/properties/getproperty.o	\
	x11/properties/strlistdup.o	\
	x11/properties/windowname.o	\
	x11/shape/setshapemask.o	\
	x11/text/freefont.o	\
	x11/text/labelh.o	\
	x11/text/loadfont.o	\
	x11/text/textextents_l.o	\
	x11/text/textwidth.o	\
	x11/text/textwidth_l.o	\
	x11/windows/configwin.o	\
	x11/windows/createwindow.o	\
	x11/windows/createwindow_rgba.o	\
	x11/windows/createwindow_visual.o	\
	x11/windows/destroywindow.o	\
	x11/windows/findwin.o	\
	x11/windows/getwinrect.o	\
	x11/windows/lowerwin.o	\
	x11/windows/mapwin.o	\
	x11/windows/movewin.o	\
	x11/windows/raisewin.o	\
	x11/windows/reparentwindow.o	\
	x11/windows/reshapewin.o	\
	x11/windows/selectinput.o	\
	x11/windows/setborder.o	\
	x11/windows/sethandler.o	\
	x11/windows/setwinattr.o	\
	x11/windows/unmapwin.o	\
	x11/windows/window.o	\
	xext.o


SETFOCUS_APP := setfocus.out
WIKEYNAME_APP := wikeyname.out
WIWARP_APP := wiwarp.out
WMII9MENU_APP := wmii9menu.out


STUFFLIB_ARCHIVE := libstuff.a

APPS := ${SETFOCUS_APP} \
	    ${WIKEYNAME_APP} \
	    ${WIWARP_APP} \
	    ${WMII9MENU_APP}

LIBS := ${STUFFLIB_ARCHIVE}

OBJECTS := ${X11_OBJECTS} \
		   ${STUFFLIB_OBJECTS}

.c.o :
	@echo CC $<
	@${CC} ${CFLAGS} -c $< -o $@

.cc.o :
	@echo CXX $<
	@${CXX} ${CXXFLAGS} -c $< -o $@

all: ${APPS}

${STUFFLIB_ARCHIVE}: ${STUFFLIB_OBJECTS}
	@echo AR ${STUFFLIB_ARCHIVE}
	@${AR} rcs ${STUFFLIB_ARCHIVE} ${STUFFLIB_OBJECTS}

${SETFOCUS_APP}: ${SETFOCUS_OBJECTS} ${STUFFLIB_ARCHIVE}
	@echo LD ${SETFOCUS_APP}
	@${CXX} -o ${SETFOCUS_APP} ${SETFOCUS_OBJECTS} ${STUFFLIB_ARCHIVE}

${WIKEYNAME_APP}: ${WIKEYNAME_OBJECTS}
	@echo LD ${WIKEYNAME_APP}
	@${CXX} -o ${WIKEYNAME_APP} ${WIKEYNAME_OBJECTS}

${WIWARP_APP}: ${WIWARP_OBJECTS}
	@echo LD ${WIWARP_APP}
	@${CXX} -o ${WIWARP_APP} ${WIWARP_OBJECTS}

${WMII9MENU_APP}: ${WMII9MENU_OBJECTS}
	@echo LD ${WMII9MENU_APP}
	@${CXX} -o ${WMII9MENU_APP} ${WMII9MENU_OBJECTS}

clean: 
	@echo Cleaning...
	@rm -f ${APPS} ${OBJECTS} ${LIBS}

.PHONY: clean
