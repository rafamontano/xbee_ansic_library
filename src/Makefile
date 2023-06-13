
CC ?= gcc

LIBVERSION = 1.0.0
XBEE_SOVERSION = 1

# Generated Library name.
XBEE_LIBNAME := libxbee

XBEE_SO_LDFLAG=-Wl,-soname=$(XBEE_LIBNAME).so.$(XBEE_SOVERSION)

PREFIX = /usr/local
INCLUDE_PATH = include
LIBRARY_PATH = lib

# validate gcc version for use fstack-protector-strong
MIN_GCC_VERSION = "4.9"
GCC_VERSION := "`$(CC) -dumpversion`"
IS_GCC_ABOVE_MIN_VERSION := $(shell expr "$(GCC_VERSION)" ">=" "$(MIN_GCC_VERSION)")
ifeq "$(IS_GCC_ABOVE_MIN_VERSION)" "1"
    CFLAGS += -fstack-protector-strong
else
    CFLAGS += -fstack-protector
endif

# extra defines
DEFINE = -DPOSIX \
 	-DZCL_ENABLE_TIME_SERVER \
	-DXBEE_DEVICE_ENABLE_ATMODE \
	-DXBEE_XMODEM_TESTING \
	-DXBEE_CMD_REQUEST_TABLESIZE=10

# Location of Source Code.
SRC = .

#library file extensions
SHARED = so
STATIC = a

INSTALL_INCLUDE_PATH = $(DESTDIR)$(PREFIX)/$(INCLUDE_PATH)
INSTALL_LIBRARY_PATH = $(DESTDIR)$(PREFIX)/$(LIBRARY_PATH)

INSTALL_HEADERS_DIR = $(INSTALL_INCLUDE_PATH)

INSTALL ?= cp -f

#PLATFORM_DIR = ../platform/posix
PLATFORM_DIR = ../ports/posix
#MBEDTLS_INCLUDE_DIR = ../include/mbedtls
#UTIL_INCLUDE_DIR = ../include/util
#WPAN_INCLUDE_DIR = ../include/wpan
#XBEE_INCLUDE_DIR = ../include/xbee
#ZIGBEE_INCLUDE_DIR = ../include/zigbee

#XBee library names
XBEE_SHARED = $(XBEE_LIBNAME).$(SHARED)
XBEE_SHARED_VERSION = $(XBEE_LIBNAME).$(SHARED).$(LIBVERSION)
XBEE_SHARED_SO = $(XBEE_LIBNAME).$(SHARED).$(XBEE_SOVERSION)
XBEE_STATIC = $(XBEE_LIBNAME).$(STATIC)

SHARED_CMD = $(CC) -shared -o

CFLAGS += -I../include
CFLAGS += -I$(PLATFORM_DIR)
CFLAGS += -fPIC -Wall -g -MMD -MP $(DEFINE)

# Libraries to Link.
CFLAGS += $(shell pkg-config --cflags mbedtls)
LDLIBS += $(shell pkg-config --libs --static mbedtls)

# Linking Flags.
LDFLAGS += -shared

# Target output to generate.
SRCS += $(wildcard $(SRC)/posix/*.c)
SRCS += $(wildcard $(SRC)/util/*.c)
SRCS += $(wildcard $(SRC)/wpan/*.c)
SRCS += $(wildcard $(SRC)/xbee/*.c)
SRCS += $(wildcard $(SRC)/zigbee/*.c)
SRCS += $(wildcard $(SRC)/mbedtls/*.c)
SRCS += $(wildcard $(PLATFORM_DIR)/*.c)

OBJS = $(SRCS:.c=.o)

.PHONY: all shared static install uninstall clean

all: shared static

shared: $(XBEE_SHARED)

static: $(XBEE_STATIC)

#.c.o:

#	$(CC) -c $(CFLAGS) $<

$(SRCS:.c=.d):%.d:%.c
	$(CC) $(CFLAGS) -MM $< >$@

#static libraries
#XBEE
$(XBEE_STATIC): $(OBJS)
	$(AR) cr $@ $^
#$(XBEE_STATIC): $(OBJS)
#	$(AR) rcs $@ $<

#shared libraries .so.1.0.0
#XBee
$(XBEE_SHARED_VERSION): $(OBJS)
	$(CC) -shared -o $@ $^ $(XBEE_SO_LDFLAG) $(LDFLAGS)

#$(XBEE_SHARED_SO): $(OBJS)
#	$(CC) -shared -o $@ $^ $(XBEE_SO_LDFLAG) $(LDFLAGS)

#$(XBEE_SHARED): $(OBJS)
#	$(CC) -shared -o $@ $^ $(XBEE_SO_LDFLAG) $(LDFLAGS)

#links .so -> .so.1 -> .so.1.0.0
#XBee
$(XBEE_SHARED_SO): $(XBEE_SHARED_VERSION)
	ln -s $(XBEE_SHARED_VERSION) $(XBEE_SHARED_SO)
$(XBEE_SHARED): $(XBEE_SHARED_SO)
	ln -s $(XBEE_SHARED_SO) $(XBEE_SHARED)

install:
	# Install library and pkg-config file.
	install -d $(INSTALL_LIBRARY_PATH) 
	install -d $(INSTALL_LIBRARY_PATH)/pkgconfig
	install -d $(INSTALL_HEADERS_DIR)/wpan
	install -d $(INSTALL_HEADERS_DIR)/xbee $(INSTALL_HEADERS_DIR)/zigbee
	install -d $(INSTALL_HEADERS_DIR)/ports/posix
	install -d $(INSTALL_HEADERS_DIR)/mbedtls

	#install -m 0644 ${S}/src/libxbee.so ${D}${libdir}
	#install -m 0644 ${S}/src/libxbee.so.1 ${D}${libdir}
	#install -m 0644 ${S}/src/libxbee.so.1.0.0 ${D}${libdir}

	install -m 0644 $(XBEE_LIBNAME).$(STATIC) $(INSTALL_LIBRARY_PATH)
	install -m 0644 $(XBEE_SHARED_VERSION) $(INSTALL_LIBRARY_PATH)
	ln -s $(INSTALL_LIBRARY_PATH)/$(XBEE_SHARED_VERSION) $(INSTALL_LIBRARY_PATH)/$(XBEE_SHARED)
	ln -s $(INSTALL_LIBRARY_PATH)/$(XBEE_SHARED_VERSION) $(INSTALL_LIBRARY_PATH)/$(XBEE_SHARED_SO)

	#$(XBEE_SHARED_SO) $(XBEE_SHARED_VERSION)
	
	#install -m 0644 lib$(XBEE_LIBNAME).a $(INSTALL_LIBRARY_PATH)
	install -m 0644 ../xbee.pc $(INSTALL_LIBRARY_PATH)/pkgconfig
	# Install header files.
	install -m 0644 ../include/wpan/*.h $(INSTALL_HEADERS_DIR)/wpan
	install -m 0644 ../include/xbee/*.h $(INSTALL_HEADERS_DIR)/xbee
	install -m 0644 ../ports/posix/*.h $(INSTALL_HEADERS_DIR)/ports/posix
	install -m 0644 ../include/zigbee/*.h $(INSTALL_HEADERS_DIR)/zigbee
	install -m 0644 ../include/mbedtls/*.h $(INSTALL_HEADERS_DIR)/mbedtls

uninstall: 
	# Uninstall library and pkg-config file.
	-rm -f $(INSTALL_LIBRARY_PATH)/$(XBEE_LIBNAME).$(STATIC)
	-rm -f $(INSTALL_LIBRARY_PATH)/$(XBEE_SHARED)
	-rm -f $(INSTALL_LIBRARY_PATH)/$(XBEE_SHARED_SO)
	-rm -f $(INSTALL_LIBRARY_PATH)/$(XBEE_SHARED_VERSION)

	-rm -f $(INSTALL_LIBRARY_PATH)/pkgconfig/xbee.pc
	# Uninstall header files.
	-rm -f $(INSTALL_HEADERS_DIR)/wpan/*.h
	-rm -f $(INSTALL_HEADERS_DIR)/xbee/*.h
	-rm -f $(INSTALL_HEADERS_DIR)/zigbee/*.h
	-rm -f $(INSTALL_HEADERS_DIR)/mbedtls/*.h

clean:
	-rm -f $(XBEE_LIBNAME).$(STATIC) $(OBJS) $(SRCS:.c=.d)
	-rm -f $(XBEE_SHARED) $(XBEE_SHARED_VERSION) $(XBEE_SHARED_SO) $(XBEE_STATIC) #delete Xbee
	

