.PHONY: all clean library cleanup

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

clean:
	rm -f $(LIBRARY) $(OBJS)

cleanup:
	rm -f $(OBJS)
