.PHONY: all clean library cleanup dist

VERSION=1.0.0

CC=gcc
CFLAGS=-fPIC -Wall -Wextra -Isrc
LDFLAGS=-s
EXT=so
PLATFORM=osx
ARCH=x64

OBJS = \
  src/datetime.o \
  src/hrtime.o

LIBRARY=lib/datetime/core_$(PLATFORM)_$(ARCH).$(EXT)

all: library

library: $(LIBRARY)

src/%.o: src/%.c
	exec $(CC) $(CFLAGS) -c -o $@ $<


$(LIBRARY): $(OBJS)
	exec mkdir -p lib/datetime
	exec $(CC) -o $@ -shared $^ $(LDFLAGS)

test: $(LIBRARY) lib/datetime.lua test.lua
	exec luajit ./test.lua

dist:
	make -f Makefile.docker
	mkdir -p lua-obs-utils-$(VERSION)/lib/datetime
	cp time.lua  lua-obs-utils-$(VERSION)/
	cp lib/datetime/*   lua-obs-utils-$(VERSION)/lib/datetime/
	cp lib/datetime.lua lua-obs-utils-$(VERSION)/lib/datetime.lua
	cp README.md lua-obs-utils-$(VERSION)/
	cp LICENSE lua-obs-utils-$(VERSION)/
	tar cf lua-obs-utils-$(VERSION).tar lua-obs-utils-$(VERSION)
	xz lua-obs-utils-$(VERSION).tar
	zip -r lua-obs-utils-$(VERSION).zip lua-obs-utils-$(VERSION)

clean:
	rm -f $(LIBRARY) $(OBJS)

cleanup:
	rm -f $(OBJS)
