include config.mk
INCLUDES := -Iinclude
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

SETFOCUS_OBJECTS := cmd/x11/setfocus.o
WIKEYNAME_OBJECTS := cmd/x11/wikeyname.o
WIWARP_OBJECTS := cmd/x11/wiwarp.o
WMII9MENU_OBJECTS := cmd/x11/wmii9menu.o

X11_OBJECTS := ${SETFOCUS_OBJECTS} \
			   ${WIKEYNAME_OBJECTS} \
			   ${WIWARP_OBJECTS} \
			   ${WMII9MENU_OBJECTS}


SETFOCUS_APP := cmd/x11/setfocus.out
WIKEYNAME_APP := cmd/x11/wikeyname.out
WIWARP_APP := cmd/x11/wiwarp.out
WMII9MENU_APP := cmd/x11/wmii9menu.out



APPS := ${SETFOCUS_APP} \
	    ${WIKEYNAME_APP} \
	    ${WIWARP_APP} \
	    ${WMII9MENU_APP}

OBJECTS := ${X11_OBJECTS}

.c.o :
	@echo CC $<
	@${CC} ${CFLAGS} -c $< -o $@

.cc.o :
	@echo CXX $<
	@${CXX} ${CXXFLAGS} -c $< -o $@

all: ${APPS}

${SETFOCUS_APP}: ${SETFOCUS_OBJECTS}
	@echo LD ${SETFOCUS_APP}
	@${CXX} -o ${SETFOCUS_APP} ${SETFOCUS_OBJECTS}

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
	@rm -f ${APPS} ${OBJECTS}

.PHONY: clean
