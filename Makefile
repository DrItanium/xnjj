include config.mk
INCLUDES := -Ilib \
			-Ilib/fmt \
			-Ilib/utf \
			-Ilib/bio \
			-Ilib/regexp \
			-Ilib/wmii_hack
VERSION := 0.1
COPYRIGHT = ©2019 Joshua Scoggins 
LOCALCONF = ~/.$(CONFDIR)
GLOBALCONF = $(ETC)/$(CONFDIR)

REQUIRED_DEFINES := -D_XOPEN_SOURCE=600 \
	'-DVERSION="$(VERSION)"' \
	'-DCOPYRIGHT="$(COPYRIGHT)"' \
	'-DCONFDIR="$(CONFDIR)"' \
	'-DCONFPREFIX="$(ETC)"' \
	'-DLOCALCONF="$(LOCALCONF)"' \
	'-DGLOBALCONF="$(GLOBALCONF)"' \
	-DIXP_NEEDAPI=129

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

DEBUGCXXFLAGS = \
	-g \
	-O0 \
	-fno-builtin \
	-fno-inline \
	-fno-omit-frame-pointer \
	-fno-optimize-sibling-calls \
	-fno-unroll-loops
CXXFLAGS += \
	-std=c++17 \
	-pedantic \
	-pipe \
	-fno-strict-aliasing \
	-Wall \
	-Wno-comment \
	-Wno-missing-braces \
	-Wno-parentheses \
	-Wno-sign-compare \
	-Wno-switch \
	-Wpointer-arith \
	-Wreturn-type \
	-Wtrigraphs \
	${INCLUDES} \
	${REQUIRED_DEFINES}

#MKDEP = cpp -M
#SOCFLAGS += -fPIC

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

REGEXPLIB_OBJECTS := \
	lib/regexp/regcomp.o\
	lib/regexp/regerror.o\
	lib/regexp/regexec.o\
	lib/regexp/regsub.o\
	lib/regexp/regaux.o\
	lib/regexp/rregexec.o\
	lib/regexp/rregsub.o


STUFFLIB_ARCHIVE := lib/stuff/libstuff.a
FMTLIB_ARCHIVE := lib/fmt/libfmt.a
UTFLIB_ARCHIVE := lib/utf/libutf.a
BIOLIB_ARCHIVE := lib/bio/libbio.a
REGEXPLIB_ARCHIVE := lib/regexp/libregexp.a


SETFOCUS_APP := cmd/x11/setfocus.out
WIKEYNAME_APP := cmd/x11/wikeyname.out
WIWARP_APP := cmd/x11/wiwarp.out
WMII9MENU_APP := cmd/x11/wmii9menu.out



WMIIR_OBJECTS := cmd/wmiir.o

WMIIR_APP := cmd/wmiir.out

WITRAY_OBJECTS = \
	cmd/tray/client.o	\
	cmd/tray/ewmh.o	\
	cmd/tray/main.o	\
	cmd/tray/selection.o	\
	cmd/tray/tray.o	\
	cmd/tray/xembed.o
WITRAY_APP = cmd/tray/witray.out

WIMENU_OBJECTS =\
	cmd/menu/main.o	\
	cmd/menu/caret.o	\
	cmd/menu/history.o	\
	cmd/menu/menu.o	\
	cmd/menu/keys.o	\
	cmd/menu/bindings.o

WIMENU_APP := cmd/menu/wimenu.out

WISTRUT_OBJECTS =	cmd/strut/main.o	\
	cmd/strut/ewmh.o	\
	cmd/strut/win.o

WISTRUT_APP = cmd/strut/wistrut.out

WMII_OBJECTS := \
	cmd/wmii/area.o\
	cmd/wmii/bar.o\
	cmd/wmii/backtrace.o\
	cmd/wmii/client.o\
	cmd/wmii/column.o\
	cmd/wmii/div.o\
	cmd/wmii/error.o\
	cmd/wmii/event.o\
	cmd/wmii/ewmh.o\
	cmd/wmii/float.o\
	cmd/wmii/frame.o\
	cmd/wmii/fs.o\
	cmd/wmii/key.o\
	cmd/wmii/layout.o\
	cmd/wmii/main.o\
	cmd/wmii/message.o\
	cmd/wmii/mouse.o\
	cmd/wmii/print.o\
	cmd/wmii/root.o\
	cmd/wmii/rule.o\
	cmd/wmii/screen.o\
	cmd/wmii/stack.o\
	cmd/wmii/utf.o\
	cmd/wmii/view.o\
	cmd/wmii/xdnd.o

WMII_APP := cmd/wmii/wmii.out

APPS := ${SETFOCUS_APP} \
	    ${WIKEYNAME_APP} \
	    ${WIWARP_APP} \
	    ${WMII9MENU_APP} \
		${WMIIR_APP} \
		${WITRAY_APP} \
		${WIMENU_APP} \
		${WISTRUT_APP} \
		${WMII_APP}

LIBS := ${STUFFLIB_ARCHIVE} \
		${FMTLIB_ARCHIVE} \
		${UTFLIB_ARCHIVE} \
		${BIOLIB_ARCHIVE} \
		${REGEXPLIB_ARCHIVE}


OBJECTS := ${X11_OBJECTS} \
		   ${STUFFLIB_OBJECTS} \
		   ${FMTLIB_OBJECTS} \
		   ${UTFLIB_OBJECTS} \
		   ${WMIIR_OBJECTS}  \
		   ${BIOLIB_OBJECTS} \
		   ${WITRAY_OBJECTS} \
		   ${WIMENU_OBJECTS} \
		   ${WISTRUT_OBJECTS} \
		   ${REGEXPLIB_OBJECTS} \
		   ${WMII_OBJECTS}

BASE_X11DEPS := x11 xinerama xrender xrandr
BASE_X11_SOLIBS := $$(pkg-config --libs $(BASE_X11DEPS))
#XDEPS := -lxext -lxrandr -lxrender -lxinerama


.c.o :
	@echo CC $<
	@${CXX} -x c++ ${CXXFLAGS} -c $< -o $@

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

${REGEXPLIB_ARCHIVE}: ${REGEXPLIB_OBJECTS}
	@echo AR ${REGEXPLIB_ARCHIVE}
	@${AR} ${REGEXPLIB_ARCHIVE} ${REGEXPLIB_OBJECTS}

${SETFOCUS_APP}: ${SETFOCUS_OBJECTS} ${STUFFLIB_ARCHIVE} ${FMTLIB_ARCHIVE} ${UTFLIB_ARCHIVE}
	@echo LD ${SETFOCUS_APP}
	@${CXX} -o ${SETFOCUS_APP} \
		${SETFOCUS_OBJECTS} \
		${STUFFLIB_ARCHIVE} \
		${FMTLIB_ARCHIVE} \
		${UTFLIB_ARCHIVE} \
		${BASE_X11_SOLIBS}

${WIKEYNAME_APP}: ${WIKEYNAME_OBJECTS} ${STUFFLIB_ARCHIVE} ${FMTLIB_ARCHIVE} ${UTFLIB_ARCHIVE}
	@echo LD ${WIKEYNAME_APP}
	@${CXX} -o ${WIKEYNAME_APP} \
		${WIKEYNAME_OBJECTS} \
		${STUFFLIB_ARCHIVE} \
		${FMTLIB_ARCHIVE} \
		${UTFLIB_ARCHIVE} \
		${BASE_X11_SOLIBS}


${WIWARP_APP}: ${WIWARP_OBJECTS} ${STUFFLIB_ARCHIVE} ${FMTLIB_ARCHIVE} ${UTFLIB_ARCHIVE}
	@echo LD ${WIWARP_APP}
	@${CXX} $(LDFLAGS) \
		-o ${WIWARP_APP} ${WIWARP_OBJECTS} \
		${STUFFLIB_ARCHIVE} \
		${FMTLIB_ARCHIVE} \
		${UTFLIB_ARCHIVE} \
		${BASE_X11_SOLIBS}

${WMII9MENU_APP}: ${WMII9MENU_OBJECTS} ${STUFFLIB_ARCHIVE} ${FMTLIB_ARCHIVE} ${UTFLIB_ARCHIVE}
	@echo LD ${WMII9MENU_APP}
	@${CXX} $(LDFLAGS) \
		-o ${WMII9MENU_APP} ${WMII9MENU_OBJECTS} \
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
	@${CXX} $(LDFLAGS) \
		-o ${WMIIR_APP} \
		${WMIIR_OBJECTS} \
		${STUFFLIB_ARCHIVE} \
		${FMTLIB_ARCHIVE} \
		${UTFLIB_ARCHIVE} \
		${BIOLIB_ARCHIVE} \
		-lixp

${WITRAY_APP}: ${WITRAY_OBJECTS} \
	${STUFFLIB_ARCHIVE} \
	${FMTLIB_ARCHIVE} \
	${UTFLIB_ARCHIVE} \
	${BIOLIB_ARCHIVE}
	@echo LD ${WITRAY_APP}
	@${CXX} $(LDFLAGS) \
		-o ${WITRAY_APP} \
		${WITRAY_OBJECTS} \
		${STUFFLIB_ARCHIVE} \
		${FMTLIB_ARCHIVE} \
		${UTFLIB_ARCHIVE} \
		${BIOLIB_ARCHIVE} \
		-lixp \
		-ldl \
		${BASE_X11_SOLIBS}

${WIMENU_APP}: ${WIMENU_OBJECTS} \
	${STUFFLIB_ARCHIVE} \
	${FMTLIB_ARCHIVE} \
	${UTFLIB_ARCHIVE} \
	${BIOLIB_ARCHIVE}
	@echo LD ${WIMENU_APP}
	@${CXX} $(LDFLAGS) \
		-o ${WIMENU_APP} \
		${WIMENU_OBJECTS} \
		${STUFFLIB_ARCHIVE} \
		${FMTLIB_ARCHIVE} \
		${UTFLIB_ARCHIVE} \
		${BIOLIB_ARCHIVE} \
		-lixp \
		-ldl \
		${BASE_X11_SOLIBS}

${WISTRUT_APP}: ${WISTRUT_OBJECTS} \
	${STUFFLIB_ARCHIVE} \
	${FMTLIB_ARCHIVE} \
	${UTFLIB_ARCHIVE} \
	${BIOLIB_ARCHIVE} \
	${REGEXPLIB_ARCHIVE}
	@echo LD ${WISTRUT_APP}
	@${CXX} $(LDFLAGS) \
		-o ${WISTRUT_APP} \
		${WISTRUT_OBJECTS} \
		${STUFFLIB_ARCHIVE} \
		${FMTLIB_ARCHIVE} \
		${BIOLIB_ARCHIVE} \
		${REGEXPLIB_ARCHIVE} \
		${UTFLIB_ARCHIVE} \
		-lixp \
		${BASE_X11_SOLIBS}

${WMII_APP}: ${WMII_OBJECTS} \
	${STUFFLIB_ARCHIVE} \
	${FMTLIB_ARCHIVE} \
	${UTFLIB_ARCHIVE} \
	${BIOLIB_ARCHIVE} \
	${REGEXPLIB_ARCHIVE}
	@echo LD ${WMII_APP}
	@${CXX} $(LDFLAGS) \
		-o ${WMII_APP} \
		${WMII_OBJECTS} \
		${STUFFLIB_ARCHIVE} \
		${FMTLIB_ARCHIVE} \
		${BIOLIB_ARCHIVE} \
		${REGEXPLIB_ARCHIVE} \
		${UTFLIB_ARCHIVE} \
		-lixp \
		-lXext \
		-lm \
		${BASE_X11_SOLIBS}

clean: 
	@echo Cleaning...
	@rm -f ${APPS} ${OBJECTS} ${LIBS}

.PHONY: clean



cmd/menu/bindings.cc: cmd/menu/keys.txt Makefile
	( echo "char binding_spec[] ="; \
	  sed 's/.*/	"&\\n"/' cmd/menu/keys.txt; \
	  echo "	;" ) >$@

# generated via g++ -MM -std=c++17 *.cc

bbuffered.o: lib/bio/bbuffered.cc lib/plan9.h
bcat.o: lib/bio/bcat.cc lib/bio/bio.h
bfildes.o: lib/bio/bfildes.cc lib/plan9.h
bflush.o: lib/bio/bflush.cc lib/plan9.h
bgetc.o: lib/bio/bgetc.cc lib/plan9.h
bgetd.o: lib/bio/bgetd.cc lib/plan9.h
bgetrune.o: lib/bio/bgetrune.cc lib/plan9.h
binit.o: lib/bio/binit.cc lib/plan9.h
boffset.o: lib/bio/boffset.cc lib/plan9.h
bprint.o: lib/bio/bprint.cc lib/plan9.h
bputc.o: lib/bio/bputc.cc lib/plan9.h
bputrune.o: lib/bio/bputrune.cc lib/plan9.h
brdline.o: lib/bio/brdline.cc lib/plan9.h
brdstr.o: lib/bio/brdstr.cc lib/plan9.h
bread.o: lib/bio/bread.cc lib/plan9.h
bseek.o: lib/bio/bseek.cc lib/plan9.h
bvprint.o: lib/bio/bvprint.cc lib/plan9.h
bwrite.o: lib/bio/bwrite.cc lib/plan9.h


charstod.o: lib/fmt/charstod.cc lib/plan9.h lib/fmt/fmt.h lib/fmt/fmtdef.h
dofmt.o: lib/fmt/dofmt.cc lib/plan9.h lib/fmt/fmt.h lib/fmt/fmtdef.h
dorfmt.o: lib/fmt/dorfmt.cc lib/plan9.h lib/fmt/fmt.h lib/fmt/fmtdef.h
errfmt.o: lib/fmt/errfmt.cc lib/plan9.h lib/fmt/fmt.h lib/fmt/fmtdef.h
fltfmt.o: lib/fmt/fltfmt.cc lib/plan9.h lib/fmt/fmt.h lib/fmt/fmtdef.h
fmt.o: lib/fmt/fmt.cc lib/plan9.h lib/fmt/fmt.h lib/fmt/fmtdef.h
fmtfd.o: lib/fmt/fmtfd.cc lib/plan9.h lib/fmt/fmt.h lib/fmt/fmtdef.h
fmtfdflush.o: lib/fmt/fmtfdflush.cc lib/plan9.h lib/fmt/fmt.h \
 lib/fmt/fmtdef.h
fmtlocale.o: lib/fmt/fmtlocale.cc lib/plan9.h lib/fmt/fmt.h \
 lib/fmt/fmtdef.h
fmtlock.o: lib/fmt/fmtlock.cc lib/plan9.h lib/fmt/fmt.h lib/fmt/fmtdef.h
fmtprint.o: lib/fmt/fmtprint.cc lib/plan9.h lib/fmt/fmt.h lib/fmt/fmtdef.h
fmtquote.o: lib/fmt/fmtquote.cc lib/plan9.h lib/fmt/fmt.h lib/fmt/fmtdef.h
fmtrune.o: lib/fmt/fmtrune.cc lib/plan9.h lib/fmt/fmt.h lib/fmt/fmtdef.h
fmtstr.o: lib/fmt/fmtstr.cc lib/plan9.h lib/fmt/fmt.h lib/fmt/fmtdef.h
fmtvprint.o: lib/fmt/fmtvprint.cc lib/plan9.h lib/fmt/fmt.h \
 lib/fmt/fmtdef.h
fprint.o: lib/fmt/fprint.cc lib/plan9.h lib/fmt/fmt.h lib/fmt/fmtdef.h
nan64.o: lib/fmt/nan64.cc lib/plan9.h lib/fmt/fmt.h lib/fmt/fmtdef.h
pow10.o: lib/fmt/pow10.cc lib/plan9.h lib/fmt/fmt.h lib/fmt/fmtdef.h
print.o: lib/fmt/print.cc lib/plan9.h lib/fmt/fmt.h lib/fmt/fmtdef.h
runefmtstr.o: lib/fmt/runefmtstr.cc lib/plan9.h lib/fmt/fmt.h \
 lib/fmt/fmtdef.h
runeseprint.o: lib/fmt/runeseprint.cc lib/plan9.h lib/fmt/fmt.h \
 lib/fmt/fmtdef.h
runesmprint.o: lib/fmt/runesmprint.cc lib/plan9.h lib/fmt/fmt.h \
 lib/fmt/fmtdef.h
runesnprint.o: lib/fmt/runesnprint.cc lib/plan9.h lib/fmt/fmt.h \
 lib/fmt/fmtdef.h
runesprint.o: lib/fmt/runesprint.cc lib/plan9.h lib/fmt/fmt.h \
 lib/fmt/fmtdef.h
runevseprint.o: lib/fmt/runevseprint.cc lib/plan9.h lib/fmt/fmt.h \
 lib/fmt/fmtdef.h
runevsmprint.o: lib/fmt/runevsmprint.cc lib/plan9.h lib/fmt/fmt.h \
 lib/fmt/fmtdef.h
runevsnprint.o: lib/fmt/runevsnprint.cc lib/plan9.h lib/fmt/fmt.h \
 lib/fmt/fmtdef.h
seprint.o: lib/fmt/seprint.cc lib/plan9.h lib/fmt/fmt.h lib/fmt/fmtdef.h
smprint.o: lib/fmt/smprint.cc lib/plan9.h lib/fmt/fmt.h lib/fmt/fmtdef.h
snprint.o: lib/fmt/snprint.cc lib/plan9.h lib/fmt/fmt.h lib/fmt/fmtdef.h
sprint.o: lib/fmt/sprint.cc lib/plan9.h lib/fmt/fmtdef.h
strtod.o: lib/fmt/strtod.cc lib/plan9.h lib/fmt/fmt.h lib/fmt/fmtdef.h
test2.o: lib/fmt/test2.cc
test3.o: lib/fmt/test3.cc
test.o: lib/fmt/test.cc lib/plan9.h lib/fmt/fmt.h lib/fmt/fmtdef.h
vfprint.o: lib/fmt/vfprint.cc lib/plan9.h lib/fmt/fmt.h lib/fmt/fmtdef.h
vseprint.o: lib/fmt/vseprint.cc lib/plan9.h lib/fmt/fmt.h lib/fmt/fmtdef.h
vsmprint.o: lib/fmt/vsmprint.cc lib/plan9.h lib/fmt/fmt.h lib/fmt/fmtdef.h
vsnprint.o: lib/fmt/vsnprint.cc lib/plan9.h lib/fmt/fmt.h lib/fmt/fmtdef.h


regaux.o: lib/regexp/regaux.cc lib/plan9.h lib/regexp/regexp9.h \
 lib/regexp/regcomp.h
regcomp.o: lib/regexp/regcomp.cc lib/plan9.h lib/regexp/regexp9.h \
 lib/regexp/regcomp.h
regerror.o: lib/regexp/regerror.cc lib/plan9.h
regexec.o: lib/regexp/regexec.cc lib/plan9.h lib/regexp/regexp9.h \
 lib/regexp/regcomp.h
regsub.o: lib/regexp/regsub.cc lib/plan9.h lib/regexp/regexp9.h
rregexec.o: lib/regexp/rregexec.cc lib/plan9.h lib/regexp/regexp9.h \
 lib/regexp/regcomp.h
rregsub.o: lib/regexp/rregsub.cc lib/plan9.h lib/regexp/regexp9.h
test2.o: lib/regexp/test2.cc lib/plan9.h
test.o: lib/regexp/test.cc lib/plan9.h


buffer.o: lib/stuff/buffer.cc
client_readconfig.o: lib/stuff/client_readconfig.cc lib/stuff/clientutil.h \
 lib/stuff/util.h lib/stuff/geom.h lib/stuff/base.h lib/stuff/x.h \
 lib/stuff/x11.h
clientutil.o: lib/stuff/clientutil.cc lib/stuff/clientutil.h \
 lib/stuff/util.h lib/stuff/geom.h lib/stuff/base.h
init_screens.o: lib/stuff/init_screens.cc
map.o: lib/stuff/map.cc lib/stuff/util.h lib/stuff/geom.h lib/stuff/base.h
printevent.o: lib/stuff/printevent.cc lib/stuff/x.h lib/stuff/base.h \
 lib/stuff/x11.h lib/stuff/geom.h lib/stuff/util.h lib/stuff/printevent.h
xext.o: lib/stuff/xext.cc lib/stuff/x.h lib/stuff/base.h lib/stuff/x11.h \
 lib/stuff/geom.h lib/stuff/util.h


buttonpress.o: lib/stuff/event/buttonpress.cc lib/stuff/event/event.h \
 lib/stuff/x.h lib/stuff/base.h lib/stuff/x11.h lib/stuff/geom.h
buttonrelease.o: lib/stuff/event/buttonrelease.cc lib/stuff/event/event.h \
 lib/stuff/x.h lib/stuff/base.h lib/stuff/x11.h lib/stuff/geom.h
clientmessage.o: lib/stuff/event/clientmessage.cc lib/stuff/event/event.h \
 lib/stuff/x.h lib/stuff/base.h lib/stuff/x11.h lib/stuff/geom.h
configurenotify.o: lib/stuff/event/configurenotify.cc \
 lib/stuff/event/event.h lib/stuff/x.h lib/stuff/base.h lib/stuff/x11.h \
 lib/stuff/geom.h
configurerequest.o: lib/stuff/event/configurerequest.cc \
 lib/stuff/event/event.h lib/stuff/x.h lib/stuff/base.h lib/stuff/x11.h \
 lib/stuff/geom.h
destroynotify.o: lib/stuff/event/destroynotify.cc lib/stuff/event/event.h \
 lib/stuff/x.h lib/stuff/base.h lib/stuff/x11.h lib/stuff/geom.h
enternotify.o: lib/stuff/event/enternotify.cc lib/stuff/event/event.h \
 lib/stuff/x.h lib/stuff/base.h lib/stuff/x11.h lib/stuff/geom.h
event.o: lib/stuff/event/event.cc lib/stuff/event/event.h lib/stuff/x.h \
 lib/stuff/base.h lib/stuff/x11.h lib/stuff/geom.h
expose.o: lib/stuff/event/expose.cc lib/stuff/event/event.h lib/stuff/x.h \
 lib/stuff/base.h lib/stuff/x11.h lib/stuff/geom.h
focusin.o: lib/stuff/event/focusin.cc lib/stuff/event/event.h \
 lib/stuff/x.h lib/stuff/base.h lib/stuff/x11.h lib/stuff/geom.h
focusout.o: lib/stuff/event/focusout.cc lib/stuff/event/event.h \
 lib/stuff/x.h lib/stuff/base.h lib/stuff/x11.h lib/stuff/geom.h
ixp.o: lib/stuff/event/ixp.cc lib/stuff/event/event.h lib/stuff/x.h \
 lib/stuff/base.h lib/stuff/x11.h lib/stuff/geom.h
keypress.o: lib/stuff/event/keypress.cc lib/stuff/event/event.h \
 lib/stuff/x.h lib/stuff/base.h lib/stuff/x11.h lib/stuff/geom.h
keyrelease.o: lib/stuff/event/keyrelease.cc lib/stuff/event/event.h \
 lib/stuff/x.h lib/stuff/base.h lib/stuff/x11.h lib/stuff/geom.h
leavenotify.o: lib/stuff/event/leavenotify.cc lib/stuff/event/event.h \
 lib/stuff/x.h lib/stuff/base.h lib/stuff/x11.h lib/stuff/geom.h
mapnotify.o: lib/stuff/event/mapnotify.cc lib/stuff/event/event.h \
 lib/stuff/x.h lib/stuff/base.h lib/stuff/x11.h lib/stuff/geom.h
mappingnotify.o: lib/stuff/event/mappingnotify.cc lib/stuff/event/event.h \
 lib/stuff/x.h lib/stuff/base.h lib/stuff/x11.h lib/stuff/geom.h
maprequest.o: lib/stuff/event/maprequest.cc lib/stuff/event/event.h \
 lib/stuff/x.h lib/stuff/base.h lib/stuff/x11.h lib/stuff/geom.h
motionnotify.o: lib/stuff/event/motionnotify.cc lib/stuff/event/event.h \
 lib/stuff/x.h lib/stuff/base.h lib/stuff/x11.h lib/stuff/geom.h
propertynotify.o: lib/stuff/event/propertynotify.cc \
 lib/stuff/event/event.h lib/stuff/x.h lib/stuff/base.h lib/stuff/x11.h \
 lib/stuff/geom.h
reparentnotify.o: lib/stuff/event/reparentnotify.cc \
 lib/stuff/event/event.h lib/stuff/x.h lib/stuff/base.h lib/stuff/x11.h \
 lib/stuff/geom.h
selection.o: lib/stuff/event/selection.cc lib/stuff/event/event.h \
 lib/stuff/x.h lib/stuff/base.h lib/stuff/x11.h lib/stuff/geom.h
selectionclear.o: lib/stuff/event/selectionclear.cc \
 lib/stuff/event/event.h lib/stuff/x.h lib/stuff/base.h lib/stuff/x11.h \
 lib/stuff/geom.h
selectionrequest.o: lib/stuff/event/selectionrequest.cc \
 lib/stuff/event/event.h lib/stuff/x.h lib/stuff/base.h lib/stuff/x11.h \
 lib/stuff/geom.h
unmapnotify.o: lib/stuff/event/unmapnotify.cc lib/stuff/event/event.h \
 lib/stuff/x.h lib/stuff/base.h lib/stuff/x11.h lib/stuff/geom.h
xtime.o: lib/stuff/event/xtime.cc lib/stuff/x.h lib/stuff/base.h \
 lib/stuff/x11.h lib/stuff/geom.h
blprint.o: lib/stuff/fmt/blprint.cc lib/stuff/fmt/fmtdef.h \
 lib/stuff/util.h lib/stuff/geom.h lib/stuff/base.h
bvlprint.o: lib/stuff/fmt/bvlprint.cc lib/stuff/fmt/fmtdef.h \
 lib/stuff/util.h lib/stuff/geom.h lib/stuff/base.h
fmtbuf.o: lib/stuff/fmt/fmtbuf.cc lib/stuff/fmt/fmtdef.h lib/stuff/util.h \
 lib/stuff/geom.h lib/stuff/base.h
localefmt.o: lib/stuff/fmt/localefmt.cc lib/stuff/fmt/fmtdef.h \
 lib/stuff/util.h lib/stuff/geom.h lib/stuff/base.h
localelen.o: lib/stuff/fmt/localelen.cc lib/stuff/fmt/fmtdef.h \
 lib/stuff/util.h lib/stuff/geom.h lib/stuff/base.h
lprint.o: lib/stuff/fmt/lprint.cc lib/stuff/fmt/fmtdef.h lib/stuff/util.h \
 lib/stuff/geom.h lib/stuff/base.h
vlprint.o: lib/stuff/fmt/vlprint.cc lib/stuff/fmt/fmtdef.h \
 lib/stuff/util.h lib/stuff/geom.h lib/stuff/base.h
get_sticky.o: lib/stuff/geom/get_sticky.cc lib/stuff/geom.h \
 lib/stuff/base.h
quadrant.o: lib/stuff/geom/quadrant.cc lib/stuff/geom.h lib/stuff/base.h
rect_contains_p.o: lib/stuff/geom/rect_contains_p.cc lib/stuff/geom.h \
 lib/stuff/base.h
rect_haspoint_p.o: lib/stuff/geom/rect_haspoint_p.cc lib/stuff/geom.h \
 lib/stuff/base.h
rect_intersection.o: lib/stuff/geom/rect_intersection.cc lib/stuff/geom.h \
 lib/stuff/base.h lib/stuff/util.h
rect_intersect_p.o: lib/stuff/geom/rect_intersect_p.cc lib/stuff/geom.h \
 lib/stuff/base.h
closeexec.o: lib/stuff/util/closeexec.cc lib/stuff/util/util.h \
 lib/stuff/util.h lib/stuff/geom.h lib/stuff/base.h
comm.o: lib/stuff/util/comm.cc lib/stuff/util/util.h lib/stuff/util.h \
 lib/stuff/geom.h lib/stuff/base.h lib/stuff/x11.h
_die.o: lib/stuff/util/_die.cc lib/stuff/util/util.h lib/stuff/util.h \
 lib/stuff/geom.h lib/stuff/base.h
doublefork.o: lib/stuff/util/doublefork.cc lib/stuff/util/util.h \
 lib/stuff/util.h lib/stuff/geom.h lib/stuff/base.h
emalloc.o: lib/stuff/util/emalloc.cc lib/stuff/util/util.h \
 lib/stuff/util.h lib/stuff/geom.h lib/stuff/base.h
emallocz.o: lib/stuff/util/emallocz.cc lib/stuff/util/util.h \
 lib/stuff/util.h lib/stuff/geom.h lib/stuff/base.h
erealloc.o: lib/stuff/util/erealloc.cc lib/stuff/util/util.h \
 lib/stuff/util.h lib/stuff/geom.h lib/stuff/base.h
estrdup.o: lib/stuff/util/estrdup.cc lib/stuff/util/util.h \
 lib/stuff/util.h lib/stuff/geom.h lib/stuff/base.h
estrndup.o: lib/stuff/util/estrndup.cc lib/stuff/util/util.h \
 lib/stuff/util.h lib/stuff/geom.h lib/stuff/base.h
fatal.o: lib/stuff/util/fatal.cc lib/stuff/util/util.h lib/stuff/util.h \
 lib/stuff/geom.h lib/stuff/base.h
freelater.o: lib/stuff/util/freelater.cc lib/stuff/util/util.h \
 lib/stuff/util.h lib/stuff/geom.h lib/stuff/base.h
getbase.o: lib/stuff/util/getbase.cc lib/stuff/util.h lib/stuff/geom.h \
 lib/stuff/base.h
getint.o: lib/stuff/util/getint.cc lib/stuff/util.h lib/stuff/geom.h \
 lib/stuff/base.h
getlong.o: lib/stuff/util/getlong.cc lib/stuff/util.h lib/stuff/geom.h \
 lib/stuff/base.h
getulong.o: lib/stuff/util/getulong.cc lib/stuff/util.h lib/stuff/geom.h \
 lib/stuff/base.h
grep.o: lib/stuff/util/grep.cc lib/stuff/util/util.h lib/stuff/util.h \
 lib/stuff/geom.h lib/stuff/base.h
join.o: lib/stuff/util/join.cc lib/stuff/util/util.h lib/stuff/util.h \
 lib/stuff/geom.h lib/stuff/base.h
max.o: lib/stuff/util/max.cc lib/stuff/util/util.h lib/stuff/util.h \
 lib/stuff/geom.h lib/stuff/base.h
mfatal.o: lib/stuff/util/mfatal.cc lib/stuff/util/util.h lib/stuff/util.h \
 lib/stuff/geom.h lib/stuff/base.h
min.o: lib/stuff/util/min.cc lib/stuff/util/util.h lib/stuff/util.h \
 lib/stuff/geom.h lib/stuff/base.h
nsec.o: lib/stuff/util/nsec.cc lib/stuff/util/util.h lib/stuff/util.h \
 lib/stuff/geom.h lib/stuff/base.h
pathsearch.o: lib/stuff/util/pathsearch.cc lib/stuff/util/util.h \
 lib/stuff/util.h lib/stuff/geom.h lib/stuff/base.h
refree.o: lib/stuff/util/refree.cc lib/stuff/util/util.h lib/stuff/util.h \
 lib/stuff/geom.h lib/stuff/base.h
reinit.o: lib/stuff/util/reinit.cc lib/stuff/util/util.h lib/stuff/util.h \
 lib/stuff/geom.h lib/stuff/base.h
spawn3.o: lib/stuff/util/spawn3.cc lib/stuff/util/util.h lib/stuff/util.h \
 lib/stuff/geom.h lib/stuff/base.h
spawn3l.o: lib/stuff/util/spawn3l.cc lib/stuff/util/util.h \
 lib/stuff/util.h lib/stuff/geom.h lib/stuff/base.h
stokenize.o: lib/stuff/util/stokenize.cc lib/stuff/util/util.h \
 lib/stuff/util.h lib/stuff/geom.h lib/stuff/base.h
strcasestr.o: lib/stuff/util/strcasestr.cc lib/stuff/util/util.h \
 lib/stuff/util.h lib/stuff/geom.h lib/stuff/base.h
strend.o: lib/stuff/util/strend.cc lib/stuff/util.h lib/stuff/geom.h \
 lib/stuff/base.h
strlcat.o: lib/stuff/util/strlcat.cc lib/stuff/util/util.h \
 lib/stuff/util.h lib/stuff/geom.h lib/stuff/base.h
strlcatprint.o: lib/stuff/util/strlcatprint.cc lib/stuff/util/util.h \
 lib/stuff/util.h lib/stuff/geom.h lib/stuff/base.h
sxprint.o: lib/stuff/util/sxprint.cc lib/stuff/util/util.h \
 lib/stuff/util.h lib/stuff/geom.h lib/stuff/base.h
tokenize.o: lib/stuff/util/tokenize.cc lib/stuff/util/util.h \
 lib/stuff/util.h lib/stuff/geom.h lib/stuff/base.h
trim.o: lib/stuff/util/trim.cc lib/stuff/util/util.h lib/stuff/util.h \
 lib/stuff/geom.h lib/stuff/base.h
uniq.o: lib/stuff/util/uniq.cc lib/stuff/util/util.h lib/stuff/util.h \
 lib/stuff/geom.h lib/stuff/base.h
unmask.o: lib/stuff/util/unmask.cc lib/stuff/util/util.h lib/stuff/util.h \
 lib/stuff/geom.h lib/stuff/base.h
unquote.o: lib/stuff/util/unquote.cc lib/stuff/util/util.h \
 lib/stuff/util.h lib/stuff/geom.h lib/stuff/base.h
utflcpy.o: lib/stuff/util/utflcpy.cc lib/stuff/util/util.h \
 lib/stuff/util.h lib/stuff/geom.h lib/stuff/base.h
vector.o: lib/stuff/util/vector.cc lib/stuff/util/util.h lib/stuff/util.h \
 lib/stuff/geom.h lib/stuff/base.h
vsxprint.o: lib/stuff/util/vsxprint.cc lib/stuff/util/util.h \
 lib/stuff/util.h lib/stuff/geom.h lib/stuff/base.h
convpts.o: lib/stuff/x11/convpts.cc lib/stuff/x11/x11.h lib/stuff/x.h \
 lib/stuff/base.h lib/stuff/x11.h lib/stuff/geom.h lib/stuff/util.h
errors.o: lib/stuff/x11/errors.cc lib/stuff/x11/x11.h lib/stuff/x.h \
 lib/stuff/base.h lib/stuff/x11.h lib/stuff/geom.h lib/stuff/util.h
freestringlist.o: lib/stuff/x11/freestringlist.cc lib/stuff/x11/x11.h \
 lib/stuff/x.h lib/stuff/base.h lib/stuff/x11.h lib/stuff/geom.h \
 lib/stuff/util.h
ignored_xerrors.o: lib/stuff/x11/ignored_xerrors.cc lib/stuff/x11/x11.h \
 lib/stuff/x.h lib/stuff/base.h lib/stuff/x11.h lib/stuff/geom.h \
 lib/stuff/util.h
initdisplay.o: lib/stuff/x11/initdisplay.cc lib/stuff/x11/x11.h \
 lib/stuff/x.h lib/stuff/base.h lib/stuff/x11.h lib/stuff/geom.h \
 lib/stuff/util.h
selection.o: lib/stuff/x11/selection.cc lib/stuff/x11/x11.h lib/stuff/x.h \
 lib/stuff/base.h lib/stuff/x11.h lib/stuff/geom.h lib/stuff/util.h
sendevent.o: lib/stuff/x11/sendevent.cc lib/stuff/x11/x11.h lib/stuff/x.h \
 lib/stuff/base.h lib/stuff/x11.h lib/stuff/geom.h lib/stuff/util.h
sendmessage.o: lib/stuff/x11/sendmessage.cc lib/stuff/x11/x11.h \
 lib/stuff/x.h lib/stuff/base.h lib/stuff/x11.h lib/stuff/geom.h \
 lib/stuff/util.h
sync.o: lib/stuff/x11/sync.cc lib/stuff/x11/x11.h lib/stuff/x.h \
 lib/stuff/base.h lib/stuff/x11.h lib/stuff/geom.h lib/stuff/util.h
x11.o: lib/stuff/x11/x11.cc lib/stuff/x11/x11.h lib/stuff/x.h \
 lib/stuff/base.h lib/stuff/x11.h lib/stuff/geom.h lib/stuff/util.h
xatom.o: lib/stuff/x11/xatom.cc lib/stuff/x11/x11.h lib/stuff/x.h \
 lib/stuff/base.h lib/stuff/x11.h lib/stuff/geom.h lib/stuff/util.h
xft.o: lib/stuff/x11/xft.cc lib/stuff/x.h lib/stuff/base.h lib/stuff/x11.h \
 lib/stuff/geom.h lib/stuff/util.h


loadcolor.o: lib/stuff/x11/colors/loadcolor.cc \
 lib/stuff/x11/colors/../x11.h lib/stuff/x.h lib/stuff/base.h \
 lib/stuff/x11.h lib/stuff/geom.h lib/stuff/util.h
parsecolor.o: lib/stuff/x11/colors/parsecolor.cc \
 lib/stuff/x11/colors/../x11.h lib/stuff/x.h lib/stuff/base.h \
 lib/stuff/x11.h lib/stuff/geom.h lib/stuff/util.h
xftcolor.o: lib/stuff/x11/colors/xftcolor.cc lib/stuff/x11/colors/../x11.h \
 lib/stuff/x.h lib/stuff/base.h lib/stuff/x11.h lib/stuff/geom.h \
 lib/stuff/util.h
border.o: lib/stuff/x11/drawing/border.cc lib/stuff/x11/drawing/../x11.h \
 lib/stuff/x.h lib/stuff/base.h lib/stuff/x11.h lib/stuff/geom.h \
 lib/stuff/util.h
drawline.o: lib/stuff/x11/drawing/drawline.cc \
 lib/stuff/x11/drawing/../x11.h lib/stuff/x.h lib/stuff/base.h \
 lib/stuff/x11.h lib/stuff/geom.h lib/stuff/util.h
drawpoly.o: lib/stuff/x11/drawing/drawpoly.cc \
 lib/stuff/x11/drawing/../x11.h lib/stuff/x.h lib/stuff/base.h \
 lib/stuff/x11.h lib/stuff/geom.h lib/stuff/util.h
drawstring.o: lib/stuff/x11/drawing/drawstring.cc \
 lib/stuff/x11/drawing/../x11.h lib/stuff/x.h lib/stuff/base.h \
 lib/stuff/x11.h lib/stuff/geom.h lib/stuff/util.h
fill.o: lib/stuff/x11/drawing/fill.cc lib/stuff/x11/drawing/../x11.h \
 lib/stuff/x.h lib/stuff/base.h lib/stuff/x11.h lib/stuff/geom.h \
 lib/stuff/util.h
fillpoly.o: lib/stuff/x11/drawing/fillpoly.cc \
 lib/stuff/x11/drawing/../x11.h lib/stuff/x.h lib/stuff/base.h \
 lib/stuff/x11.h lib/stuff/geom.h lib/stuff/util.h
setgccol.o: lib/stuff/x11/drawing/setgccol.cc \
 lib/stuff/x11/drawing/../x11.h lib/stuff/x.h lib/stuff/base.h \
 lib/stuff/x11.h lib/stuff/geom.h lib/stuff/util.h
getfocus.o: lib/stuff/x11/focus/getfocus.cc lib/stuff/x11/focus/../x11.h \
 lib/stuff/x.h lib/stuff/base.h lib/stuff/x11.h lib/stuff/geom.h \
 lib/stuff/util.h
setfocus.o: lib/stuff/x11/focus/setfocus.cc lib/stuff/x11/focus/../x11.h \
 lib/stuff/x.h lib/stuff/base.h lib/stuff/x11.h lib/stuff/geom.h \
 lib/stuff/util.h
addpt.o: lib/stuff/x11/geometry/addpt.cc lib/stuff/x11/geometry/../x11.h \
 lib/stuff/x.h lib/stuff/base.h lib/stuff/x11.h lib/stuff/geom.h \
 lib/stuff/util.h
divpt.o: lib/stuff/x11/geometry/divpt.cc lib/stuff/x11/geometry/../x11.h \
 lib/stuff/x.h lib/stuff/base.h lib/stuff/x11.h lib/stuff/geom.h \
 lib/stuff/util.h
eqpt.o: lib/stuff/x11/geometry/eqpt.cc lib/stuff/x11/geometry/../x11.h \
 lib/stuff/x.h lib/stuff/base.h lib/stuff/x11.h lib/stuff/geom.h \
 lib/stuff/util.h
eqrect.o: lib/stuff/x11/geometry/eqrect.cc lib/stuff/x11/geometry/../x11.h \
 lib/stuff/x.h lib/stuff/base.h lib/stuff/x11.h lib/stuff/geom.h \
 lib/stuff/util.h
insetrect.o: lib/stuff/x11/geometry/insetrect.cc \
 lib/stuff/x11/geometry/../x11.h lib/stuff/x.h lib/stuff/base.h \
 lib/stuff/x11.h lib/stuff/geom.h lib/stuff/util.h
mulpt.o: lib/stuff/x11/geometry/mulpt.cc lib/stuff/x11/geometry/../x11.h \
 lib/stuff/x.h lib/stuff/base.h lib/stuff/x11.h lib/stuff/geom.h \
 lib/stuff/util.h
rectaddpt.o: lib/stuff/x11/geometry/rectaddpt.cc \
 lib/stuff/x11/geometry/../x11.h lib/stuff/x.h lib/stuff/base.h \
 lib/stuff/x11.h lib/stuff/geom.h lib/stuff/util.h
rectsetorigin.o: lib/stuff/x11/geometry/rectsetorigin.cc \
 lib/stuff/x11/geometry/../x11.h lib/stuff/x.h lib/stuff/base.h \
 lib/stuff/x11.h lib/stuff/geom.h lib/stuff/util.h
rectsubpt.o: lib/stuff/x11/geometry/rectsubpt.cc \
 lib/stuff/x11/geometry/../x11.h lib/stuff/x.h lib/stuff/base.h \
 lib/stuff/x11.h lib/stuff/geom.h lib/stuff/util.h
subpt.o: lib/stuff/x11/geometry/subpt.cc lib/stuff/x11/geometry/../x11.h \
 lib/stuff/x.h lib/stuff/base.h lib/stuff/x11.h lib/stuff/geom.h \
 lib/stuff/util.h
XRect.o: lib/stuff/x11/geometry/XRect.cc lib/stuff/x11/geometry/../x11.h \
 lib/stuff/x.h lib/stuff/base.h lib/stuff/x11.h lib/stuff/geom.h \
 lib/stuff/util.h
allocimage.o: lib/stuff/x11/images/allocimage.cc \
 lib/stuff/x11/images/../x11.h lib/stuff/x.h lib/stuff/base.h \
 lib/stuff/x11.h lib/stuff/geom.h lib/stuff/util.h
copyimage.o: lib/stuff/x11/images/copyimage.cc \
 lib/stuff/x11/images/../x11.h lib/stuff/x.h lib/stuff/base.h \
 lib/stuff/x11.h lib/stuff/geom.h lib/stuff/util.h
freeimage.o: lib/stuff/x11/images/freeimage.cc \
 lib/stuff/x11/images/../x11.h lib/stuff/x.h lib/stuff/base.h \
 lib/stuff/x11.h lib/stuff/geom.h lib/stuff/util.h
xftdrawable.o: lib/stuff/x11/images/xftdrawable.cc \
 lib/stuff/x11/images/../x11.h lib/stuff/x.h lib/stuff/base.h \
 lib/stuff/x11.h lib/stuff/geom.h lib/stuff/util.h
gethints.o: lib/stuff/x11/insanity/gethints.cc \
 lib/stuff/x11/insanity/../x11.h lib/stuff/x.h lib/stuff/base.h \
 lib/stuff/x11.h lib/stuff/geom.h lib/stuff/util.h
gravitate.o: lib/stuff/x11/insanity/gravitate.cc \
 lib/stuff/x11/insanity/../x11.h lib/stuff/x.h lib/stuff/base.h \
 lib/stuff/x11.h lib/stuff/geom.h lib/stuff/util.h
sethints.o: lib/stuff/x11/insanity/sethints.cc \
 lib/stuff/x11/insanity/../x11.h lib/stuff/x.h lib/stuff/base.h \
 lib/stuff/x11.h lib/stuff/geom.h lib/stuff/util.h
sizehint.o: lib/stuff/x11/insanity/sizehint.cc \
 lib/stuff/x11/insanity/../x11.h lib/stuff/x.h lib/stuff/base.h \
 lib/stuff/x11.h lib/stuff/geom.h lib/stuff/util.h
grabkeyboard.o: lib/stuff/x11/keyboard/grabkeyboard.cc \
 lib/stuff/x11/keyboard/../x11.h lib/stuff/x.h lib/stuff/base.h \
 lib/stuff/x11.h lib/stuff/geom.h lib/stuff/util.h
ungrabkeyboard.o: lib/stuff/x11/keyboard/ungrabkeyboard.cc \
 lib/stuff/x11/keyboard/../x11.h lib/stuff/x.h lib/stuff/base.h \
 lib/stuff/x11.h lib/stuff/geom.h lib/stuff/util.h
keycode.o: lib/stuff/x11/keys/keycode.cc lib/stuff/x11/keys/../x11.h \
 lib/stuff/x.h lib/stuff/base.h lib/stuff/x11.h lib/stuff/geom.h \
 lib/stuff/util.h
parsekey.o: lib/stuff/x11/keys/parsekey.cc lib/stuff/x11/keys/../x11.h \
 lib/stuff/x.h lib/stuff/base.h lib/stuff/x11.h lib/stuff/geom.h \
 lib/stuff/util.h
grabpointer.o: lib/stuff/x11/mouse/grabpointer.cc \
 lib/stuff/x11/mouse/../x11.h lib/stuff/x.h lib/stuff/base.h \
 lib/stuff/x11.h lib/stuff/geom.h lib/stuff/util.h
pointerscreen.o: lib/stuff/x11/mouse/pointerscreen.cc \
 lib/stuff/x11/mouse/../x11.h lib/stuff/x.h lib/stuff/base.h \
 lib/stuff/x11.h lib/stuff/geom.h lib/stuff/util.h
querypointer.o: lib/stuff/x11/mouse/querypointer.cc \
 lib/stuff/x11/mouse/../x11.h lib/stuff/x.h lib/stuff/base.h \
 lib/stuff/x11.h lib/stuff/geom.h lib/stuff/util.h
translate.o: lib/stuff/x11/mouse/translate.cc lib/stuff/x11/mouse/../x11.h \
 lib/stuff/x.h lib/stuff/base.h lib/stuff/x11.h lib/stuff/geom.h \
 lib/stuff/util.h
ungrabpointer.o: lib/stuff/x11/mouse/ungrabpointer.cc \
 lib/stuff/x11/mouse/../x11.h lib/stuff/x.h lib/stuff/base.h \
 lib/stuff/x11.h lib/stuff/geom.h lib/stuff/util.h
warppointer.o: lib/stuff/x11/mouse/warppointer.cc \
 lib/stuff/x11/mouse/../x11.h lib/stuff/x.h lib/stuff/base.h \
 lib/stuff/x11.h lib/stuff/geom.h lib/stuff/util.h
changeprop_char.o: lib/stuff/x11/properties/changeprop_char.cc \
 lib/stuff/x11/properties/../x11.h lib/stuff/x.h lib/stuff/base.h \
 lib/stuff/x11.h lib/stuff/geom.h lib/stuff/util.h
changeproperty.o: lib/stuff/x11/properties/changeproperty.cc \
 lib/stuff/x11/properties/../x11.h lib/stuff/x.h lib/stuff/base.h \
 lib/stuff/x11.h lib/stuff/geom.h lib/stuff/util.h
changeprop_long.o: lib/stuff/x11/properties/changeprop_long.cc \
 lib/stuff/x11/properties/../x11.h lib/stuff/x.h lib/stuff/base.h \
 lib/stuff/x11.h lib/stuff/geom.h lib/stuff/util.h
changeprop_short.o: lib/stuff/x11/properties/changeprop_short.cc \
 lib/stuff/x11/properties/../x11.h lib/stuff/x.h lib/stuff/base.h \
 lib/stuff/x11.h lib/stuff/geom.h lib/stuff/util.h
changeprop_string.o: lib/stuff/x11/properties/changeprop_string.cc \
 lib/stuff/x11/properties/../x11.h lib/stuff/x.h lib/stuff/base.h \
 lib/stuff/x11.h lib/stuff/geom.h lib/stuff/util.h
changeprop_textlist.o: lib/stuff/x11/properties/changeprop_textlist.cc \
 lib/stuff/x11/properties/../x11.h lib/stuff/x.h lib/stuff/base.h \
 lib/stuff/x11.h lib/stuff/geom.h lib/stuff/util.h
changeprop_ulong.o: lib/stuff/x11/properties/changeprop_ulong.cc \
 lib/stuff/x11/properties/../x11.h lib/stuff/x.h lib/stuff/base.h \
 lib/stuff/x11.h lib/stuff/geom.h lib/stuff/util.h
delproperty.o: lib/stuff/x11/properties/delproperty.cc \
 lib/stuff/x11/properties/../x11.h lib/stuff/x.h lib/stuff/base.h \
 lib/stuff/x11.h lib/stuff/geom.h lib/stuff/util.h
getprop.o: lib/stuff/x11/properties/getprop.cc \
 lib/stuff/x11/properties/../x11.h lib/stuff/x.h lib/stuff/base.h \
 lib/stuff/x11.h lib/stuff/geom.h lib/stuff/util.h
getproperty.o: lib/stuff/x11/properties/getproperty.cc \
 lib/stuff/x11/properties/../x11.h lib/stuff/x.h lib/stuff/base.h \
 lib/stuff/x11.h lib/stuff/geom.h lib/stuff/util.h
getprop_long.o: lib/stuff/x11/properties/getprop_long.cc \
 lib/stuff/x11/properties/../x11.h lib/stuff/x.h lib/stuff/base.h \
 lib/stuff/x11.h lib/stuff/geom.h lib/stuff/util.h
getprop_string.o: lib/stuff/x11/properties/getprop_string.cc \
 lib/stuff/x11/properties/../x11.h lib/stuff/x.h lib/stuff/base.h \
 lib/stuff/x11.h lib/stuff/geom.h lib/stuff/util.h
getprop_textlist.o: lib/stuff/x11/properties/getprop_textlist.cc \
 lib/stuff/x11/properties/../x11.h lib/stuff/x.h lib/stuff/base.h \
 lib/stuff/x11.h lib/stuff/geom.h lib/stuff/util.h
strlistdup.o: lib/stuff/x11/properties/strlistdup.cc \
 lib/stuff/x11/properties/../x11.h lib/stuff/x.h lib/stuff/base.h \
 lib/stuff/x11.h lib/stuff/geom.h lib/stuff/util.h
windowname.o: lib/stuff/x11/properties/windowname.cc \
 lib/stuff/x11/properties/../x11.h lib/stuff/x.h lib/stuff/base.h \
 lib/stuff/x11.h lib/stuff/geom.h lib/stuff/util.h
setshapemask.o: lib/stuff/x11/shape/setshapemask.cc \
 lib/stuff/x11/shape/../x11.h lib/stuff/x.h lib/stuff/base.h \
 lib/stuff/x11.h lib/stuff/geom.h lib/stuff/util.h
freefont.o: lib/stuff/x11/text/freefont.cc lib/stuff/x11/text/../x11.h \
 lib/stuff/x.h lib/stuff/base.h lib/stuff/x11.h lib/stuff/geom.h \
 lib/stuff/util.h
labelh.o: lib/stuff/x11/text/labelh.cc lib/stuff/x11/text/../x11.h \
 lib/stuff/x.h lib/stuff/base.h lib/stuff/x11.h lib/stuff/geom.h \
 lib/stuff/util.h
loadfont.o: lib/stuff/x11/text/loadfont.cc lib/stuff/x11/text/../x11.h \
 lib/stuff/x.h lib/stuff/base.h lib/stuff/x11.h lib/stuff/geom.h \
 lib/stuff/util.h
textextents_l.o: lib/stuff/x11/text/textextents_l.cc \
 lib/stuff/x11/text/../x11.h lib/stuff/x.h lib/stuff/base.h \
 lib/stuff/x11.h lib/stuff/geom.h lib/stuff/util.h
textwidth.o: lib/stuff/x11/text/textwidth.cc lib/stuff/x11/text/../x11.h \
 lib/stuff/x.h lib/stuff/base.h lib/stuff/x11.h lib/stuff/geom.h \
 lib/stuff/util.h
textwidth_l.o: lib/stuff/x11/text/textwidth_l.cc \
 lib/stuff/x11/text/../x11.h lib/stuff/x.h lib/stuff/base.h \
 lib/stuff/x11.h lib/stuff/geom.h lib/stuff/util.h
configwin.o: lib/stuff/x11/windows/configwin.cc \
 lib/stuff/x11/windows/../x11.h lib/stuff/x.h lib/stuff/base.h \
 lib/stuff/x11.h lib/stuff/geom.h lib/stuff/util.h
createwindow.o: lib/stuff/x11/windows/createwindow.cc \
 lib/stuff/x11/windows/../x11.h lib/stuff/x.h lib/stuff/base.h \
 lib/stuff/x11.h lib/stuff/geom.h lib/stuff/util.h
createwindow_rgba.o: lib/stuff/x11/windows/createwindow_rgba.cc \
 lib/stuff/x11/windows/../x11.h lib/stuff/x.h lib/stuff/base.h \
 lib/stuff/x11.h lib/stuff/geom.h lib/stuff/util.h
createwindow_visual.o: lib/stuff/x11/windows/createwindow_visual.cc \
 lib/stuff/x11/windows/../x11.h lib/stuff/x.h lib/stuff/base.h \
 lib/stuff/x11.h lib/stuff/geom.h lib/stuff/util.h
destroywindow.o: lib/stuff/x11/windows/destroywindow.cc \
 lib/stuff/x11/windows/../x11.h lib/stuff/x.h lib/stuff/base.h \
 lib/stuff/x11.h lib/stuff/geom.h lib/stuff/util.h
findwin.o: lib/stuff/x11/windows/findwin.cc lib/stuff/x11/windows/../x11.h \
 lib/stuff/x.h lib/stuff/base.h lib/stuff/x11.h lib/stuff/geom.h \
 lib/stuff/util.h
getwinrect.o: lib/stuff/x11/windows/getwinrect.cc \
 lib/stuff/x11/windows/../x11.h lib/stuff/x.h lib/stuff/base.h \
 lib/stuff/x11.h lib/stuff/geom.h lib/stuff/util.h
lowerwin.o: lib/stuff/x11/windows/lowerwin.cc \
 lib/stuff/x11/windows/../x11.h lib/stuff/x.h lib/stuff/base.h \
 lib/stuff/x11.h lib/stuff/geom.h lib/stuff/util.h
mapwin.o: lib/stuff/x11/windows/mapwin.cc lib/stuff/x11/windows/../x11.h \
 lib/stuff/x.h lib/stuff/base.h lib/stuff/x11.h lib/stuff/geom.h \
 lib/stuff/util.h
movewin.o: lib/stuff/x11/windows/movewin.cc lib/stuff/x11/windows/../x11.h \
 lib/stuff/x.h lib/stuff/base.h lib/stuff/x11.h lib/stuff/geom.h \
 lib/stuff/util.h
raisewin.o: lib/stuff/x11/windows/raisewin.cc \
 lib/stuff/x11/windows/../x11.h lib/stuff/x.h lib/stuff/base.h \
 lib/stuff/x11.h lib/stuff/geom.h lib/stuff/util.h
reparentwindow.o: lib/stuff/x11/windows/reparentwindow.cc \
 lib/stuff/x11/windows/../x11.h lib/stuff/x.h lib/stuff/base.h \
 lib/stuff/x11.h lib/stuff/geom.h lib/stuff/util.h
reshapewin.o: lib/stuff/x11/windows/reshapewin.cc \
 lib/stuff/x11/windows/../x11.h lib/stuff/x.h lib/stuff/base.h \
 lib/stuff/x11.h lib/stuff/geom.h lib/stuff/util.h
selectinput.o: lib/stuff/x11/windows/selectinput.cc \
 lib/stuff/x11/windows/../x11.h lib/stuff/x.h lib/stuff/base.h \
 lib/stuff/x11.h lib/stuff/geom.h lib/stuff/util.h
setborder.o: lib/stuff/x11/windows/setborder.cc \
 lib/stuff/x11/windows/../x11.h lib/stuff/x.h lib/stuff/base.h \
 lib/stuff/x11.h lib/stuff/geom.h lib/stuff/util.h
sethandler.o: lib/stuff/x11/windows/sethandler.cc \
 lib/stuff/x11/windows/../x11.h lib/stuff/x.h lib/stuff/base.h \
 lib/stuff/x11.h lib/stuff/geom.h lib/stuff/util.h
setwinattr.o: lib/stuff/x11/windows/setwinattr.cc \
 lib/stuff/x11/windows/../x11.h lib/stuff/x.h lib/stuff/base.h \
 lib/stuff/x11.h lib/stuff/geom.h lib/stuff/util.h
unmapwin.o: lib/stuff/x11/windows/unmapwin.cc \
 lib/stuff/x11/windows/../x11.h lib/stuff/x.h lib/stuff/base.h \
 lib/stuff/x11.h lib/stuff/geom.h lib/stuff/util.h
window.o: lib/stuff/x11/windows/window.cc lib/stuff/x11/windows/../x11.h \
 lib/stuff/x.h lib/stuff/base.h lib/stuff/x11.h lib/stuff/geom.h \
 lib/stuff/util.h


rune.o: lib/utf/rune.cc lib/plan9.h lib/utf/utf.h
runestrcat.o: lib/utf/runestrcat.cc lib/plan9.h
runestrchr.o: lib/utf/runestrchr.cc lib/plan9.h lib/utf/utf.h
runestrcmp.o: lib/utf/runestrcmp.cc lib/plan9.h lib/utf/utf.h
runestrcpy.o: lib/utf/runestrcpy.cc lib/plan9.h lib/utf/utf.h
runestrdup.o: lib/utf/runestrdup.cc lib/plan9.h
runestrecpy.o: lib/utf/runestrecpy.cc lib/plan9.h lib/utf/utf.h
runestrlen.o: lib/utf/runestrlen.cc lib/plan9.h
runestrncat.o: lib/utf/runestrncat.cc lib/plan9.h lib/utf/utf.h
runestrncmp.o: lib/utf/runestrncmp.cc lib/plan9.h lib/utf/utf.h
runestrncpy.o: lib/utf/runestrncpy.cc lib/plan9.h lib/utf/utf.h
runestrrchr.o: lib/utf/runestrrchr.cc lib/plan9.h lib/utf/utf.h
runestrstr.o: lib/utf/runestrstr.cc lib/plan9.h lib/utf/utf.h
runetype.o: lib/utf/runetype.cc lib/plan9.h lib/utf/utf.h
utfecpy.o: lib/utf/utfecpy.cc lib/plan9.h lib/utf/utf.h
utflen.o: lib/utf/utflen.cc lib/plan9.h lib/utf/utf.h
utfnlen.o: lib/utf/utfnlen.cc lib/plan9.h lib/utf/utf.h
utfrrune.o: lib/utf/utfrrune.cc lib/plan9.h lib/utf/utf.h
utfrune.o: lib/utf/utfrune.cc lib/plan9.h lib/utf/utf.h
utfutf.o: lib/utf/utfutf.cc lib/plan9.h lib/utf/utf.h


hack.o: lib/wmii_hack/hack.cc lib/wmii_hack/hack.h lib/stuff/util.h \
 lib/stuff/geom.h lib/stuff/base.h lib/wmii_hack/util.cc \
 lib/wmii_hack/x11.cc lib/wmii_hack/x11.h
util.o: lib/wmii_hack/util.cc
x11.o: lib/wmii_hack/x11.cc lib/wmii_hack/x11.h


wmiir.o: cmd/wmiir.cc lib/stuff/util.h lib/stuff/geom.h lib/stuff/base.h


caret.o: cmd/menu/caret.cc cmd/menu/dat.h lib/stuff/x.h lib/stuff/base.h \
 lib/stuff/x11.h lib/stuff/geom.h lib/stuff/util.h cmd/menu/fns.h
history.o: cmd/menu/history.cc cmd/menu/dat.h lib/stuff/x.h \
 lib/stuff/base.h lib/stuff/x11.h lib/stuff/geom.h lib/stuff/util.h \
 cmd/menu/fns.h
keys.o: cmd/menu/keys.cc cmd/menu/dat.h lib/stuff/x.h lib/stuff/base.h \
 lib/stuff/x11.h lib/stuff/geom.h lib/stuff/util.h cmd/menu/fns.h
main.o: cmd/menu/main.cc cmd/menu/dat.h lib/stuff/x.h lib/stuff/base.h \
 lib/stuff/x11.h lib/stuff/geom.h lib/stuff/util.h lib/stuff/clientutil.h \
 cmd/menu/fns.h
menu.o: cmd/menu/menu.cc cmd/menu/dat.h lib/stuff/x.h lib/stuff/base.h \
 lib/stuff/x11.h lib/stuff/geom.h lib/stuff/util.h cmd/menu/fns.h


ewmh.o: cmd/strut/ewmh.cc cmd/strut/dat.h lib/stuff/x.h lib/stuff/base.h \
 lib/stuff/x11.h lib/stuff/geom.h lib/stuff/util.h cmd/strut/fns.h
main.o: cmd/strut/main.cc cmd/strut/dat.h lib/stuff/x.h lib/stuff/base.h \
 lib/stuff/x11.h lib/stuff/geom.h lib/stuff/util.h cmd/strut/fns.h
win.o: cmd/strut/win.cc cmd/strut/dat.h lib/stuff/x.h lib/stuff/base.h \
 lib/stuff/x11.h lib/stuff/geom.h lib/stuff/util.h cmd/strut/fns.h
client.o: cmd/tray/client.cc cmd/tray/dat.h lib/stuff/x.h lib/stuff/base.h \
 lib/stuff/x11.h lib/stuff/geom.h lib/stuff/util.h cmd/tray/selection.h \
 cmd/tray/fns.h
ewmh.o: cmd/tray/ewmh.cc cmd/tray/dat.h lib/stuff/x.h lib/stuff/base.h \
 lib/stuff/x11.h lib/stuff/geom.h lib/stuff/util.h cmd/tray/selection.h \
 cmd/tray/fns.h
main.o: cmd/tray/main.cc cmd/tray/dat.h lib/stuff/x.h lib/stuff/base.h \
 lib/stuff/x11.h lib/stuff/geom.h lib/stuff/util.h cmd/tray/selection.h \
 lib/stuff/clientutil.h cmd/tray/fns.h
selection.o: cmd/tray/selection.cc cmd/tray/dat.h lib/stuff/x.h \
 lib/stuff/base.h lib/stuff/x11.h lib/stuff/geom.h lib/stuff/util.h \
 cmd/tray/selection.h cmd/tray/fns.h
tray.o: cmd/tray/tray.cc cmd/tray/dat.h lib/stuff/x.h lib/stuff/base.h \
 lib/stuff/x11.h lib/stuff/geom.h lib/stuff/util.h cmd/tray/selection.h \
 cmd/tray/fns.h
xembed.o: cmd/tray/xembed.cc cmd/tray/dat.h lib/stuff/x.h lib/stuff/base.h \
 lib/stuff/x11.h lib/stuff/geom.h lib/stuff/util.h cmd/tray/selection.h \
 cmd/tray/fns.h


area.o: cmd/wmii/area.cc cmd/wmii/dat.h lib/stuff/x.h lib/stuff/base.h \
 lib/stuff/x11.h lib/stuff/geom.h lib/stuff/util.h cmd/wmii/debug.h \
 cmd/wmii/fns.h
backtrace.o: cmd/wmii/backtrace.cc lib/plan9.h lib/stuff/util.h \
 lib/stuff/geom.h lib/stuff/base.h cmd/wmii/debug.h
bar.o: cmd/wmii/bar.cc cmd/wmii/dat.h lib/stuff/x.h lib/stuff/base.h \
 lib/stuff/x11.h lib/stuff/geom.h lib/stuff/util.h cmd/wmii/debug.h \
 cmd/wmii/fns.h
client.o: cmd/wmii/client.cc cmd/wmii/dat.h lib/stuff/x.h lib/stuff/base.h \
 lib/stuff/x11.h lib/stuff/geom.h lib/stuff/util.h cmd/wmii/debug.h \
 cmd/wmii/fns.h
column.o: cmd/wmii/column.cc cmd/wmii/dat.h lib/stuff/x.h lib/stuff/base.h \
 lib/stuff/x11.h lib/stuff/geom.h lib/stuff/util.h cmd/wmii/debug.h \
 cmd/wmii/fns.h
div.o: cmd/wmii/div.cc cmd/wmii/dat.h lib/stuff/x.h lib/stuff/base.h \
 lib/stuff/x11.h lib/stuff/geom.h lib/stuff/util.h cmd/wmii/debug.h \
 cmd/wmii/fns.h
error.o: cmd/wmii/error.cc cmd/wmii/dat.h lib/stuff/x.h lib/stuff/base.h \
 lib/stuff/x11.h lib/stuff/geom.h lib/stuff/util.h cmd/wmii/debug.h \
 cmd/wmii/fns.h
event.o: cmd/wmii/event.cc cmd/wmii/dat.h lib/stuff/x.h lib/stuff/base.h \
 lib/stuff/x11.h lib/stuff/geom.h lib/stuff/util.h cmd/wmii/debug.h \
 cmd/wmii/fns.h
ewmh.o: cmd/wmii/ewmh.cc cmd/wmii/dat.h lib/stuff/x.h lib/stuff/base.h \
 lib/stuff/x11.h lib/stuff/geom.h lib/stuff/util.h cmd/wmii/debug.h \
 cmd/wmii/fns.h
float.o: cmd/wmii/float.cc cmd/wmii/dat.h lib/stuff/x.h lib/stuff/base.h \
 lib/stuff/x11.h lib/stuff/geom.h lib/stuff/util.h cmd/wmii/debug.h \
 cmd/wmii/fns.h
frame.o: cmd/wmii/frame.cc cmd/wmii/dat.h lib/stuff/x.h lib/stuff/base.h \
 lib/stuff/x11.h lib/stuff/geom.h lib/stuff/util.h cmd/wmii/debug.h \
 cmd/wmii/fns.h
fs.o: cmd/wmii/fs.cc cmd/wmii/dat.h lib/stuff/x.h lib/stuff/base.h \
 lib/stuff/x11.h lib/stuff/geom.h lib/stuff/util.h cmd/wmii/debug.h \
 cmd/wmii/fns.h
key.o: cmd/wmii/key.cc cmd/wmii/dat.h lib/stuff/x.h lib/stuff/base.h \
 lib/stuff/x11.h lib/stuff/geom.h lib/stuff/util.h cmd/wmii/debug.h \
 cmd/wmii/fns.h
layout.o: cmd/wmii/layout.cc cmd/wmii/dat.h lib/stuff/x.h lib/stuff/base.h \
 lib/stuff/x11.h lib/stuff/geom.h lib/stuff/util.h cmd/wmii/debug.h \
 cmd/wmii/fns.h
main.o: cmd/wmii/main.cc cmd/wmii/dat.h lib/stuff/x.h lib/stuff/base.h \
 lib/stuff/x11.h lib/stuff/geom.h lib/stuff/util.h cmd/wmii/debug.h \
 cmd/wmii/fns.h
message.o: cmd/wmii/message.cc cmd/wmii/dat.h lib/stuff/x.h \
 lib/stuff/base.h lib/stuff/x11.h lib/stuff/geom.h lib/stuff/util.h \
 cmd/wmii/debug.h cmd/wmii/fns.h
mouse.o: cmd/wmii/mouse.cc cmd/wmii/dat.h lib/stuff/x.h lib/stuff/base.h \
 lib/stuff/x11.h lib/stuff/geom.h lib/stuff/util.h cmd/wmii/debug.h \
 cmd/wmii/fns.h
print.o: cmd/wmii/print.cc cmd/wmii/dat.h lib/stuff/x.h lib/stuff/base.h \
 lib/stuff/x11.h lib/stuff/geom.h lib/stuff/util.h cmd/wmii/debug.h \
 cmd/wmii/fns.h
root.o: cmd/wmii/root.cc cmd/wmii/dat.h lib/stuff/x.h lib/stuff/base.h \
 lib/stuff/x11.h lib/stuff/geom.h lib/stuff/util.h cmd/wmii/debug.h \
 cmd/wmii/fns.h
rule.o: cmd/wmii/rule.cc cmd/wmii/dat.h lib/stuff/x.h lib/stuff/base.h \
 lib/stuff/x11.h lib/stuff/geom.h lib/stuff/util.h cmd/wmii/debug.h \
 cmd/wmii/fns.h
screen.o: cmd/wmii/screen.cc cmd/wmii/dat.h lib/stuff/x.h lib/stuff/base.h \
 lib/stuff/x11.h lib/stuff/geom.h lib/stuff/util.h cmd/wmii/debug.h \
 cmd/wmii/fns.h
stack.o: cmd/wmii/stack.cc cmd/wmii/dat.h lib/stuff/x.h lib/stuff/base.h \
 lib/stuff/x11.h lib/stuff/geom.h lib/stuff/util.h cmd/wmii/debug.h \
 cmd/wmii/fns.h
utf.o: cmd/wmii/utf.cc cmd/wmii/dat.h lib/stuff/x.h lib/stuff/base.h \
 lib/stuff/x11.h lib/stuff/geom.h lib/stuff/util.h cmd/wmii/debug.h \
 cmd/wmii/fns.h
view.o: cmd/wmii/view.cc cmd/wmii/dat.h lib/stuff/x.h lib/stuff/base.h \
 lib/stuff/x11.h lib/stuff/geom.h lib/stuff/util.h cmd/wmii/debug.h \
 cmd/wmii/fns.h
xdnd.o: cmd/wmii/xdnd.cc cmd/wmii/dat.h lib/stuff/x.h lib/stuff/base.h \
 lib/stuff/x11.h lib/stuff/geom.h lib/stuff/util.h cmd/wmii/debug.h \
 cmd/wmii/fns.h
setfocus.o: cmd/x11/setfocus.cc lib/stuff/x.h lib/stuff/base.h \
 lib/stuff/x11.h lib/stuff/geom.h lib/stuff/util.h
wikeyname.o: cmd/x11/wikeyname.cc lib/stuff/util.h lib/stuff/geom.h \
 lib/stuff/base.h lib/stuff/x.h lib/stuff/x11.h
wiwarp.o: cmd/x11/wiwarp.cc lib/stuff/x.h lib/stuff/base.h lib/stuff/x11.h \
 lib/stuff/geom.h lib/stuff/util.h
wmii9menu.o: cmd/x11/wmii9menu.cc lib/stuff/clientutil.h lib/stuff/util.h \
 lib/stuff/geom.h lib/stuff/base.h lib/stuff/x.h lib/stuff/x11.h
