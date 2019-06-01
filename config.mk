# Customize below to fit your system

# Paths
PREFIX = /usr/local
  BIN = $(PREFIX)/bin
  MAN = $(PREFIX)/share/man
  DOC = $(PREFIX)/share/doc/wmii
  ETC = $(PREFIX)/etc
  LIBDIR = $(PREFIX)/lib
  INCLUDE = $(PREFIX)/include
  PYPREFIX = --prefix=$(PREFIX)

# Includes and libs
INCLUDES = -I. -I$(ROOT)/include -I$(INCLUDE) -I/usr/include
LIBS = -L$(ROOT)/lib -L/usr/lib

TERMINAL = xterm

# Flags
include $(ROOT)/mk/gcc.mk
CXXFLAGS += -Os $(DEBUGCXXFLAGS)
LDFLAGS += -g

# Compiler, Linker. Linker should usually *not* be ld.
CXX = c++ -c
LD = c++
# Archiver
AR = ar crs

X11PACKAGES = x11 xinerama xrender xrandr
INCX11 = $$(pkg-config --cflags $(X11PACKAGES))
LIBJYQ = $(LIBDIR)/libjyq.a

# Enable RTLD. Only necessary for Xft support.
CFLAGS += -DHAVE_RTLD
LDFLAGS += -ldl # Comment this out on BSD systems.

SOLDFLAGS += $(LDFLAGS)
SHARED = -shared -Wl,-soname=$(SONAME)
STATIC = -static
