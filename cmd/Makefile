ROOT=..
include $(ROOT)/mk/hdr.mk
include $(ROOT)/mk/xnjj.mk

xnjjr.c: $(ROOT)/mk/xnjj.mk

DIRS =	menu \
	strut \
	tray \
	xnjj \
	x11
TARG =	wihack    \
	xnjj.rc   \
	xnjj.sh   \
	xnjjr

LIBS += $(LIBS9) $(LIBJYQ)

include $(ROOT)/mk/many.mk
include $(ROOT)/mk/dir.mk

