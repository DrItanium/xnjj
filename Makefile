ROOT=.
include $(ROOT)/mk/hdr.mk
include $(ROOT)/mk/wmii.mk

DIRS = \
	doc	     \
	examples     \
	man	     \
	lib	     \
	cmd	     \
	rc	     \
	alternative_wmiircs

DOCS = FAQ \
       LICENSE \
       README.md

include $(ROOT)/mk/dir.mk

