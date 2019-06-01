ROOT=.
include $(ROOT)/mk/hdr.mk
include $(ROOT)/mk/xnjj.mk

DIRS = \
	doc	     \
	examples     \
	man	     \
	lib	     \
	cmd	     \
	rc	     \
	alternative_xnjjrcs

DOCS = FAQ \
       LICENSE \
       README.md

DISTRO = unstable

include $(ROOT)/mk/dir.mk

