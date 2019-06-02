include config.mk
INCLUDES := -Ilib \
			-Ilib/fmt \
			-Ilib/utf \
			-Ilib/bio \
			-Ilib/regexp \
			-Ilib/wmii_hack
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

SETFOCUS_OBJECTS := cmd/x11/setfocus.o
WIKEYNAME_OBJECTS := cmd/x11/wikeyname.o
WIWARP_OBJECTS := cmd/x11/wiwarp.o
WMII9MENU_OBJECTS := cmd/x11/wmii9menu.o

X11_OBJECTS := ${SETFOCUS_OBJECTS} \
			   ${WIKEYNAME_OBJECTS} \
			   ${WIWARP_OBJECTS} \
			   ${WMII9MENU_OBJECTS}
FMTLIB_OBJECTS := \
	lib/fmt/charstod.o\
	lib/fmt/pow10.o\
	lib/fmt/nan64.o\
	lib/fmt/dofmt.o\
	lib/fmt/dorfmt.o\
	lib/fmt/errfmt.o\
	lib/fmt/fltfmt.o\
	lib/fmt/fmt.o\
	lib/fmt/fmtfd.o\
	lib/fmt/fmtfdflush.o\
	lib/fmt/fmtlocale.o\
	lib/fmt/fmtlock.o\
	lib/fmt/fmtprint.o\
	lib/fmt/fmtquote.o\
	lib/fmt/fmtrune.o\
	lib/fmt/fmtstr.o\
	lib/fmt/fmtvprint.o\
	lib/fmt/fprint.o\
	lib/fmt/print.o\
	lib/fmt/runefmtstr.o\
	lib/fmt/runeseprint.o\
	lib/fmt/runesmprint.o\
	lib/fmt/runesnprint.o\
	lib/fmt/runesprint.o\
	lib/fmt/runevseprint.o\
	lib/fmt/runevsmprint.o\
	lib/fmt/runevsnprint.o\
	lib/fmt/seprint.o\
	lib/fmt/smprint.o\
	lib/fmt/snprint.o\
	lib/fmt/sprint.o\
	lib/fmt/strtod.o\
	lib/fmt/vfprint.o\
	lib/fmt/vseprint.o\
	lib/fmt/vsmprint.o\
	lib/fmt/vsnprint.o

STUFFLIB_OBJECTS := \
	lib/stuff/buffer.o		\
	lib/stuff/clientutil.o	\
	lib/stuff/client_readconfig.o	\
	lib/stuff/event/buttonpress.o	\
	lib/stuff/event/buttonrelease.o	\
	lib/stuff/event/clientmessage.o	\
	lib/stuff/event/configurenotify.o	\
	lib/stuff/event/configurerequest.o	\
	lib/stuff/event/destroynotify.o	\
	lib/stuff/event/enternotify.o	\
	lib/stuff/event/event.o 	\
	lib/stuff/event/expose.o		\
	lib/stuff/event/focusin.o		\
	lib/stuff/event/focusout.o		\
	lib/stuff/event/ixp.o		\
	lib/stuff/event/keypress.o		\
	lib/stuff/event/keyrelease.o	\
	lib/stuff/event/leavenotify.o	\
	lib/stuff/event/mapnotify.o		\
	lib/stuff/event/maprequest.o	\
	lib/stuff/event/mappingnotify.o	\
	lib/stuff/event/motionnotify.o	\
	lib/stuff/event/propertynotify.o	\
	lib/stuff/event/reparentnotify.o	\
	lib/stuff/event/selection.o		\
	lib/stuff/event/selectionclear.o	\
	lib/stuff/event/selectionrequest.o	\
	lib/stuff/event/unmapnotify.o	\
	lib/stuff/event/xtime.o		\
	lib/stuff/fmt/blprint.o		\
	lib/stuff/fmt/bvlprint.o		\
	lib/stuff/fmt/fmtbuf.o		\
	lib/stuff/fmt/localefmt.o		\
	lib/stuff/fmt/localelen.o		\
	lib/stuff/fmt/lprint.o		\
	lib/stuff/fmt/vlprint.o		\
	lib/stuff/geom/get_sticky.o		\
	lib/stuff/geom/quadrant.o		\
	lib/stuff/geom/rect_contains_p.o	\
	lib/stuff/geom/rect_haspoint_p.o	\
	lib/stuff/geom/rect_intersect_p.o	\
	lib/stuff/geom/rect_intersection.o	\
	lib/stuff/init_screens.o	\
	lib/stuff/map.o		\
	lib/stuff/printevent.o	\
	lib/stuff/util/_die.o	\
	lib/stuff/util/closeexec.o	\
	lib/stuff/util/comm.o	\
	lib/stuff/util/doublefork.o	\
	lib/stuff/util/emalloc.o	\
	lib/stuff/util/emallocz.o	\
	lib/stuff/util/erealloc.o	\
	lib/stuff/util/estrdup.o	\
	lib/stuff/util/estrndup.o	\
	lib/stuff/util/fatal.o	\
	lib/stuff/util/freelater.o	\
	lib/stuff/util/getbase.o	\
	lib/stuff/util/getint.o	\
	lib/stuff/util/getlong.o	\
	lib/stuff/util/getulong.o	\
	lib/stuff/util/grep.o	\
	lib/stuff/util/join.o	\
	lib/stuff/util/max.o	\
	lib/stuff/util/mfatal.o	\
	lib/stuff/util/min.o	\
	lib/stuff/util/nsec.o	\
	lib/stuff/util/pathsearch.o	\
	lib/stuff/util/refree.o	\
	lib/stuff/util/reinit.o	\
	lib/stuff/util/spawn3.o	\
	lib/stuff/util/spawn3l.o	\
	lib/stuff/util/stokenize.o	\
	lib/stuff/util/strcasestr.o	\
	lib/stuff/util/strend.o	\
	lib/stuff/util/strlcat.o	\
	lib/stuff/util/strlcatprint.o	\
	lib/stuff/util/sxprint.o	\
	lib/stuff/util/tokenize.o	\
	lib/stuff/util/trim.o	\
	lib/stuff/util/uniq.o	\
	lib/stuff/util/unmask.o	\
	lib/stuff/util/unquote.o	\
	lib/stuff/util/utflcpy.o	\
	lib/stuff/util/vector.o	\
	lib/stuff/util/vsxprint.o	\
	lib/stuff/x11/convpts.o	\
	lib/stuff/x11/errors.o	\
	lib/stuff/x11/ignored_xerrors.o	\
	lib/stuff/x11/freestringlist.o	\
	lib/stuff/x11/initdisplay.o	\
	lib/stuff/x11/selection.o	\
	lib/stuff/x11/sendevent.o	\
	lib/stuff/x11/sendmessage.o	\
	lib/stuff/x11/sync.o	\
	lib/stuff/x11/x11.o		\
	lib/stuff/x11/xatom.o	\
	lib/stuff/x11/xft.o		\
	lib/stuff/x11/colors/loadcolor.o	\
	lib/stuff/x11/colors/parsecolor.o	\
	lib/stuff/x11/colors/xftcolor.o	\
	lib/stuff/x11/drawing/border.o	\
	lib/stuff/x11/drawing/drawline.o	\
	lib/stuff/x11/drawing/drawpoly.o	\
	lib/stuff/x11/drawing/drawstring.o	\
	lib/stuff/x11/drawing/fill.o	\
	lib/stuff/x11/drawing/fillpoly.o	\
	lib/stuff/x11/drawing/setgccol.o	\
	lib/stuff/x11/focus/getfocus.o	\
	lib/stuff/x11/focus/setfocus.o	\
	lib/stuff/x11/geometry/XRect.o	\
	lib/stuff/x11/geometry/addpt.o	\
	lib/stuff/x11/geometry/divpt.o	\
	lib/stuff/x11/geometry/eqpt.o	\
	lib/stuff/x11/geometry/eqrect.o	\
	lib/stuff/x11/geometry/insetrect.o	\
	lib/stuff/x11/geometry/mulpt.o	\
	lib/stuff/x11/geometry/rectaddpt.o	\
	lib/stuff/x11/geometry/rectsetorigin.o	\
	lib/stuff/x11/geometry/rectsubpt.o	\
	lib/stuff/x11/geometry/subpt.o	\
	lib/stuff/x11/images/allocimage.o	\
	lib/stuff/x11/images/copyimage.o	\
	lib/stuff/x11/images/freeimage.o	\
	lib/stuff/x11/images/xftdrawable.o	\
	lib/stuff/x11/insanity/gravitate.o	\
	lib/stuff/x11/insanity/gethints.o	\
	lib/stuff/x11/insanity/sethints.o	\
	lib/stuff/x11/insanity/sizehint.o	\
	lib/stuff/x11/keyboard/grabkeyboard.o	\
	lib/stuff/x11/keyboard/ungrabkeyboard.o	\
	lib/stuff/x11/keys/keycode.o	\
	lib/stuff/x11/keys/parsekey.o	\
	lib/stuff/x11/mouse/grabpointer.o	\
	lib/stuff/x11/mouse/pointerscreen.o	\
	lib/stuff/x11/mouse/querypointer.o	\
	lib/stuff/x11/mouse/translate.o	\
	lib/stuff/x11/mouse/ungrabpointer.o	\
	lib/stuff/x11/mouse/warppointer.o	\
	lib/stuff/x11/properties/changeprop_char.o	\
	lib/stuff/x11/properties/changeprop_long.o	\
	lib/stuff/x11/properties/changeprop_short.o	\
	lib/stuff/x11/properties/changeprop_string.o	\
	lib/stuff/x11/properties/changeprop_textlist.o	\
	lib/stuff/x11/properties/changeprop_ulong.o	\
	lib/stuff/x11/properties/changeproperty.o	\
	lib/stuff/x11/properties/delproperty.o	\
	lib/stuff/x11/properties/getprop.o	\
	lib/stuff/x11/properties/getprop_long.o	\
	lib/stuff/x11/properties/getprop_string.o	\
	lib/stuff/x11/properties/getprop_textlist.o	\
	lib/stuff/x11/properties/getproperty.o	\
	lib/stuff/x11/properties/strlistdup.o	\
	lib/stuff/x11/properties/windowname.o	\
	lib/stuff/x11/shape/setshapemask.o	\
	lib/stuff/x11/text/freefont.o	\
	lib/stuff/x11/text/labelh.o	\
	lib/stuff/x11/text/loadfont.o	\
	lib/stuff/x11/text/textextents_l.o	\
	lib/stuff/x11/text/textwidth.o	\
	lib/stuff/x11/text/textwidth_l.o	\
	lib/stuff/x11/windows/configwin.o	\
	lib/stuff/x11/windows/createwindow.o	\
	lib/stuff/x11/windows/createwindow_rgba.o	\
	lib/stuff/x11/windows/createwindow_visual.o	\
	lib/stuff/x11/windows/destroywindow.o	\
	lib/stuff/x11/windows/findwin.o	\
	lib/stuff/x11/windows/getwinrect.o	\
	lib/stuff/x11/windows/lowerwin.o	\
	lib/stuff/x11/windows/mapwin.o	\
	lib/stuff/x11/windows/movewin.o	\
	lib/stuff/x11/windows/raisewin.o	\
	lib/stuff/x11/windows/reparentwindow.o	\
	lib/stuff/x11/windows/reshapewin.o	\
	lib/stuff/x11/windows/selectinput.o	\
	lib/stuff/x11/windows/setborder.o	\
	lib/stuff/x11/windows/sethandler.o	\
	lib/stuff/x11/windows/setwinattr.o	\
	lib/stuff/x11/windows/unmapwin.o	\
	lib/stuff/x11/windows/window.o	\
	lib/stuff/xext.o

UTFLIB_OBJECTS := \
	lib/utf/rune.o\
	lib/utf/runestrcat.o\
	lib/utf/runestrchr.o\
	lib/utf/runestrcmp.o\
	lib/utf/runestrcpy.o\
	lib/utf/runestrdup.o\
	lib/utf/runestrlen.o\
	lib/utf/runestrecpy.o\
	lib/utf/runestrncat.o\
	lib/utf/runestrncmp.o\
	lib/utf/runestrncpy.o\
	lib/utf/runestrrchr.o\
	lib/utf/runestrstr.o\
	lib/utf/runetype.o\
	lib/utf/utfecpy.o\
	lib/utf/utflen.o\
	lib/utf/utfnlen.o\
	lib/utf/utfrrune.o\
	lib/utf/utfrune.o\
	lib/utf/utfutf.o

BIOLIB_OBJECTS := \
	lib/bio/bbuffered.o\
	lib/bio/bfildes.o\
	lib/bio/bflush.o\
	lib/bio/bgetc.o\
	lib/bio/bgetd.o\
	lib/bio/bgetrune.o\
	lib/bio/binit.o\
	lib/bio/boffset.o\
	lib/bio/bprint.o\
	lib/bio/bvprint.o\
	lib/bio/bputc.o\
	lib/bio/bputrune.o\
	lib/bio/brdline.o\
	lib/bio/brdstr.o\
	lib/bio/bread.o\
	lib/bio/bseek.o\
	lib/bio/bwrite.o


SETFOCUS_APP := cmd/x11/setfocus.out
WIKEYNAME_APP := cmd/x11/wikeyname.out
WIWARP_APP := cmd/x11/wiwarp.out
WMII9MENU_APP := cmd/x11/wmii9menu.out


STUFFLIB_ARCHIVE := lib/stuff/libstuff.a
FMTLIB_ARCHIVE := lib/fmt/libfmt.a
UTFLIB_ARCHIVE := lib/utf/libutf.a
BIOLIB_ARCHIVE := lib/bio/libbio.a

WMIIR_OBJECTS := cmd/wmiir.o

WMIIR_APP := cmd/wmiir.out


APPS := ${SETFOCUS_APP} \
	    ${WIKEYNAME_APP} \
	    ${WIWARP_APP} \
	    ${WMII9MENU_APP} \
		${WMIIR_APP}

LIBS := ${STUFFLIB_ARCHIVE} \
		${FMTLIB_ARCHIVE} \
		${UTFLIB_ARCHIVE} \
		${BIOLIB_ARCHIVE}

OBJECTS := ${X11_OBJECTS} \
		   ${STUFFLIB_OBJECTS} \
		   ${FMTLIB_OBJECTS} \
		   ${UTFLIB_OBJECTS} \
		   ${WMIIR_OBJECTS}  \
		   ${BIOLIB_OBJECTS} 

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

${BIOLIB_ARCHIVE}: ${BIOLIB_OBJECTS}
	@echo AR ${BIOLIB_ARCHIVE}
	@${AR} ${BIOLIB_ARCHIVE} ${BIOLIB_OBJECTS}

${SETFOCUS_APP}: ${SETFOCUS_OBJECTS} ${STUFFLIB_ARCHIVE} ${FMTLIB_ARCHIVE} ${UTFLIB_ARCHIVE}
	@echo LD ${SETFOCUS_APP}
	@${LD} -o ${SETFOCUS_APP} \
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

${WMIIR_APP}: ${WMIIR_OBJECTS} \
	${STUFFLIB_ARCHIVE} \
	${FMTLIB_ARCHIVE} \
	${UTFLIB_ARCHIVE} \
	${BIOLIB_ARCHIVE}
	@echo LD ${WMIIR_APP}
	@${LD} -o ${WMIIR_APP} \
		${WMIIR_OBJECTS} \
		${STUFFLIB_ARCHIVE} \
		${FMTLIB_ARCHIVE} \
		${UTFLIB_ARCHIVE} \
		${BIOLIB_ARCHIVE} \
		-lixp

clean: 
	@echo Cleaning...
	@rm -f ${APPS} ${OBJECTS} ${LIBS}

.PHONY: clean
