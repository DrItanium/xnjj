include config.mk
INCLUDES := -I. \
			-Ifmt \
			-Iutf \
			-Ibio \
			-Iregexp \
			-Iwmii_hack
VERSION := 0.1
COPYRIGHT = ©2019 Joshua Scoggins 

REQUIRED_DEFINES := -D_XOPEN_SOURCE=600 \
	'-DVERSION="$(VERSION)"' \
	'-DCOPYRIGHT="$(COPYRIGHT)"'

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
	${INCLUDES} \
	${REQUIRED_DEFINES}

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
FMTLIB_OBJECTS := \
	fmt/charstod.o\
	fmt/pow10.o\
	fmt/nan64.o\
	fmt/dofmt.o\
	fmt/dorfmt.o\
	fmt/errfmt.o\
	fmt/fltfmt.o\
	fmt/fmt.o\
	fmt/fmtfd.o\
	fmt/fmtfdflush.o\
	fmt/fmtlocale.o\
	fmt/fmtlock.o\
	fmt/fmtprint.o\
	fmt/fmtquote.o\
	fmt/fmtrune.o\
	fmt/fmtstr.o\
	fmt/fmtvprint.o\
	fmt/fprint.o\
	fmt/print.o\
	fmt/runefmtstr.o\
	fmt/runeseprint.o\
	fmt/runesmprint.o\
	fmt/runesnprint.o\
	fmt/runesprint.o\
	fmt/runevseprint.o\
	fmt/runevsmprint.o\
	fmt/runevsnprint.o\
	fmt/seprint.o\
	fmt/smprint.o\
	fmt/snprint.o\
	fmt/sprint.o\
	fmt/strtod.o\
	fmt/vfprint.o\
	fmt/vseprint.o\
	fmt/vsmprint.o\
	fmt/vsnprint.o

STUFFLIB_OBJECTS := stuff/buffer.o		\
	stuff/clientutil.o	\
	stuff/client_readconfig.o	\
	stuff/event/buttonpress.o	\
	stuff/event/buttonrelease.o	\
	stuff/event/clientmessage.o	\
	stuff/event/configurenotify.o	\
	stuff/event/configurerequest.o	\
	stuff/event/destroynotify.o	\
	stuff/event/enternotify.o	\
	stuff/event/event.o 	\
	stuff/event/expose.o		\
	stuff/event/focusin.o		\
	stuff/event/focusout.o		\
	stuff/event/ixp.o		\
	stuff/event/keypress.o		\
	stuff/event/keyrelease.o	\
	stuff/event/leavenotify.o	\
	stuff/event/mapnotify.o		\
	stuff/event/maprequest.o	\
	stuff/event/mappingnotify.o	\
	stuff/event/motionnotify.o	\
	stuff/event/propertynotify.o	\
	stuff/event/reparentnotify.o	\
	stuff/event/selection.o		\
	stuff/event/selectionclear.o	\
	stuff/event/selectionrequest.o	\
	stuff/event/unmapnotify.o	\
	stuff/event/xtime.o		\
	stuff/fmt/blprint.o		\
	stuff/fmt/bvlprint.o		\
	stuff/fmt/fmtbuf.o		\
	stuff/fmt/localefmt.o		\
	stuff/fmt/localelen.o		\
	stuff/fmt/lprint.o		\
	stuff/fmt/vlprint.o		\
	stuff/geom/get_sticky.o		\
	stuff/geom/quadrant.o		\
	stuff/geom/rect_contains_p.o	\
	stuff/geom/rect_haspoint_p.o	\
	stuff/geom/rect_intersect_p.o	\
	stuff/geom/rect_intersection.o	\
	stuff/init_screens.o	\
	stuff/map.o		\
	stuff/printevent.o	\
	stuff/util/_die.o	\
	stuff/util/closeexec.o	\
	stuff/util/comm.o	\
	stuff/util/doublefork.o	\
	stuff/util/emalloc.o	\
	stuff/util/emallocz.o	\
	stuff/util/erealloc.o	\
	stuff/util/estrdup.o	\
	stuff/util/estrndup.o	\
	stuff/util/fatal.o	\
	stuff/util/freelater.o	\
	stuff/util/getbase.o	\
	stuff/util/getint.o	\
	stuff/util/getlong.o	\
	stuff/util/getulong.o	\
	stuff/util/grep.o	\
	stuff/util/join.o	\
	stuff/util/max.o	\
	stuff/util/mfatal.o	\
	stuff/util/min.o	\
	stuff/util/nsec.o	\
	stuff/util/pathsearch.o	\
	stuff/util/refree.o	\
	stuff/util/reinit.o	\
	stuff/util/spawn3.o	\
	stuff/util/spawn3l.o	\
	stuff/util/stokenize.o	\
	stuff/util/strcasestr.o	\
	stuff/util/strend.o	\
	stuff/util/strlcat.o	\
	stuff/util/strlcatprint.o	\
	stuff/util/sxprint.o	\
	stuff/util/tokenize.o	\
	stuff/util/trim.o	\
	stuff/util/uniq.o	\
	stuff/util/unmask.o	\
	stuff/util/unquote.o	\
	stuff/util/utflcpy.o	\
	stuff/util/vector.o	\
	stuff/util/vsxprint.o	\
	stuff/x11/convpts.o	\
	stuff/x11/errors.o	\
	stuff/x11/ignored_xerrors.o	\
	stuff/x11/freestringlist.o	\
	stuff/x11/initdisplay.o	\
	stuff/x11/selection.o	\
	stuff/x11/sendevent.o	\
	stuff/x11/sendmessage.o	\
	stuff/x11/sync.o	\
	stuff/x11/x11.o		\
	stuff/x11/xatom.o	\
	stuff/x11/xft.o		\
	stuff/x11/colors/loadcolor.o	\
	stuff/x11/colors/parsecolor.o	\
	stuff/x11/colors/xftcolor.o	\
	stuff/x11/drawing/border.o	\
	stuff/x11/drawing/drawline.o	\
	stuff/x11/drawing/drawpoly.o	\
	stuff/x11/drawing/drawstring.o	\
	stuff/x11/drawing/fill.o	\
	stuff/x11/drawing/fillpoly.o	\
	stuff/x11/drawing/setgccol.o	\
	stuff/x11/focus/getfocus.o	\
	stuff/x11/focus/setfocus.o	\
	stuff/x11/geometry/XRect.o	\
	stuff/x11/geometry/addpt.o	\
	stuff/x11/geometry/divpt.o	\
	stuff/x11/geometry/eqpt.o	\
	stuff/x11/geometry/eqrect.o	\
	stuff/x11/geometry/insetrect.o	\
	stuff/x11/geometry/mulpt.o	\
	stuff/x11/geometry/rectaddpt.o	\
	stuff/x11/geometry/rectsetorigin.o	\
	stuff/x11/geometry/rectsubpt.o	\
	stuff/x11/geometry/subpt.o	\
	stuff/x11/images/allocimage.o	\
	stuff/x11/images/copyimage.o	\
	stuff/x11/images/freeimage.o	\
	stuff/x11/images/xftdrawable.o	\
	stuff/x11/insanity/gravitate.o	\
	stuff/x11/insanity/gethints.o	\
	stuff/x11/insanity/sethints.o	\
	stuff/x11/insanity/sizehint.o	\
	stuff/x11/keyboard/grabkeyboard.o	\
	stuff/x11/keyboard/ungrabkeyboard.o	\
	stuff/x11/keys/keycode.o	\
	stuff/x11/keys/parsekey.o	\
	stuff/x11/mouse/grabpointer.o	\
	stuff/x11/mouse/pointerscreen.o	\
	stuff/x11/mouse/querypointer.o	\
	stuff/x11/mouse/translate.o	\
	stuff/x11/mouse/ungrabpointer.o	\
	stuff/x11/mouse/warppointer.o	\
	stuff/x11/properties/changeprop_char.o	\
	stuff/x11/properties/changeprop_long.o	\
	stuff/x11/properties/changeprop_short.o	\
	stuff/x11/properties/changeprop_string.o	\
	stuff/x11/properties/changeprop_textlist.o	\
	stuff/x11/properties/changeprop_ulong.o	\
	stuff/x11/properties/changeproperty.o	\
	stuff/x11/properties/delproperty.o	\
	stuff/x11/properties/getprop.o	\
	stuff/x11/properties/getprop_long.o	\
	stuff/x11/properties/getprop_string.o	\
	stuff/x11/properties/getprop_textlist.o	\
	stuff/x11/properties/getproperty.o	\
	stuff/x11/properties/strlistdup.o	\
	stuff/x11/properties/windowname.o	\
	stuff/x11/shape/setshapemask.o	\
	stuff/x11/text/freefont.o	\
	stuff/x11/text/labelh.o	\
	stuff/x11/text/loadfont.o	\
	stuff/x11/text/textextents_l.o	\
	stuff/x11/text/textwidth.o	\
	stuff/x11/text/textwidth_l.o	\
	stuff/x11/windows/configwin.o	\
	stuff/x11/windows/createwindow.o	\
	stuff/x11/windows/createwindow_rgba.o	\
	stuff/x11/windows/createwindow_visual.o	\
	stuff/x11/windows/destroywindow.o	\
	stuff/x11/windows/findwin.o	\
	stuff/x11/windows/getwinrect.o	\
	stuff/x11/windows/lowerwin.o	\
	stuff/x11/windows/mapwin.o	\
	stuff/x11/windows/movewin.o	\
	stuff/x11/windows/raisewin.o	\
	stuff/x11/windows/reparentwindow.o	\
	stuff/x11/windows/reshapewin.o	\
	stuff/x11/windows/selectinput.o	\
	stuff/x11/windows/setborder.o	\
	stuff/x11/windows/sethandler.o	\
	stuff/x11/windows/setwinattr.o	\
	stuff/x11/windows/unmapwin.o	\
	stuff/x11/windows/window.o	\
	stuff/xext.o

UTFLIB_OBJECTS := \
	utf/rune.o\
	utf/runestrcat.o\
	utf/runestrchr.o\
	utf/runestrcmp.o\
	utf/runestrcpy.o\
	utf/runestrdup.o\
	utf/runestrlen.o\
	utf/runestrecpy.o\
	utf/runestrncat.o\
	utf/runestrncmp.o\
	utf/runestrncpy.o\
	utf/runestrrchr.o\
	utf/runestrstr.o\
	utf/runetype.o\
	utf/utfecpy.o\
	utf/utflen.o\
	utf/utfnlen.o\
	utf/utfrrune.o\
	utf/utfrune.o\
	utf/utfutf.o


SETFOCUS_APP := setfocus.out
WIKEYNAME_APP := wikeyname.out
WIWARP_APP := wiwarp.out
WMII9MENU_APP := wmii9menu.out


STUFFLIB_ARCHIVE := libstuff.a
FMTLIB_ARCHIVE := libfmt.a
UTFLIB_ARCHIVE := libutf.a

APPS := ${SETFOCUS_APP} \
	    ${WIKEYNAME_APP} \
	    ${WIWARP_APP} \
	    ${WMII9MENU_APP}

LIBS := ${STUFFLIB_ARCHIVE} \
		${FMTLIB_ARCHIVE} \
		${UTFLIB_ARCHIVE}

OBJECTS := ${X11_OBJECTS} \
		   ${STUFFLIB_OBJECTS} \
		   ${FMTLIB_OBJECTS} \
		   ${UTFLIB_OBJECTS}

BASE_X11DEPS := x11 xinerama xrender xrandr
BASE_X11_SOLIBS := $$(pkg-config --libs $(BASE_X11DEPS))
#XDEPS := -lxext -lxrandr -lxrender -lxinerama


.c.o :
	@echo CC $<
	@${CC} ${CFLAGS} -c $< -o $@

.cc.o :
	@echo CXX $<
	@${CXX} ${CXXFLAGS} -c $< -o $@

all: ${APPS}

${STUFFLIB_ARCHIVE}: ${STUFFLIB_OBJECTS}
	@echo AR ${STUFFLIB_ARCHIVE}
	@${AR} ${STUFFLIB_ARCHIVE} ${STUFFLIB_OBJECTS}

${FMTLIB_ARCHIVE}: ${FMTLIB_OBJECTS}
	@echo AR ${FMTLIB_ARCHIVE}
	@${AR} ${FMTLIB_ARCHIVE} ${FMTLIB_OBJECTS}

${UTFLIB_ARCHIVE}: ${UTFLIB_OBJECTS}
	@echo AR ${UTFLIB_ARCHIVE}
	@${AR} ${UTFLIB_ARCHIVE} ${UTFLIB_OBJECTS}

${SETFOCUS_APP}: ${SETFOCUS_OBJECTS} ${STUFFLIB_ARCHIVE} ${FMTLIB_ARCHIVE} ${UTFLIB_ARCHIVE}
	@echo LD ${SETFOCUS_APP}
	${LD} -o ${SETFOCUS_APP} \
		${SETFOCUS_OBJECTS} \
		${STUFFLIB_ARCHIVE} \
		${FMTLIB_ARCHIVE} \
		${UTFLIB_ARCHIVE} \
		${BASE_X11_SOLIBS}

${WIKEYNAME_APP}: ${WIKEYNAME_OBJECTS} ${STUFFLIB_ARCHIVE} ${FMTLIB_ARCHIVE} ${UTFLIB_ARCHIVE}
	@echo LD ${WIKEYNAME_APP}
	@${LD} -o ${WIKEYNAME_APP} \
		${WIKEYNAME_OBJECTS} \
		${STUFFLIB_ARCHIVE} \
		${FMTLIB_ARCHIVE} \
		${UTFLIB_ARCHIVE} \
		${BASE_X11_SOLIBS}


${WIWARP_APP}: ${WIWARP_OBJECTS} ${STUFFLIB_ARCHIVE} ${FMTLIB_ARCHIVE} ${UTFLIB_ARCHIVE}
	@echo LD ${WIWARP_APP}
	@${LD} -o ${WIWARP_APP} ${WIWARP_OBJECTS} \
		${STUFFLIB_ARCHIVE} \
		${FMTLIB_ARCHIVE} \
		${UTFLIB_ARCHIVE} \
		${BASE_X11_SOLIBS}

${WMII9MENU_APP}: ${WMII9MENU_OBJECTS} ${STUFFLIB_ARCHIVE} ${FMTLIB_ARCHIVE} ${UTFLIB_ARCHIVE}
	@echo LD ${WMII9MENU_APP}
	@${LD} -o ${WMII9MENU_APP} ${WMII9MENU_OBJECTS} \
		${STUFFLIB_ARCHIVE} \
		${FMTLIB_ARCHIVE} \
		${UTFLIB_ARCHIVE} \
		$$(pkg-config --libs xft) \
		-ldl \
		-lixp \
		${BASE_X11_SOLIBS}

clean: 
	@echo Cleaning...
	@rm -f ${APPS} ${OBJECTS} ${LIBS}

.PHONY: clean
