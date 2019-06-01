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


SETFOCUS_APP := setfocus.out
WIKEYNAME_APP := wikeyname.out
WIWARP_APP := wiwarp.out
WMII9MENU_APP := wmii9menu.out



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
