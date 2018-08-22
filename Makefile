.PHONY: all clean library

CC=gcc
CFLAGS=-fPIC -Wall -Wextra -Isrc
LDFLAGS=-s
EXT=so

all: library

library: lib/datetime/core.$(EXT)

lib/datetime:
	exec mkdir lib/datetime

lib/datetime/core.o: src/datetime.c src/datetime.h lib/datetime
	exec $(CC) $(CFLAGS) -c -o $@ $<

lib/datetime/core.$(EXT): lib/datetime/core.o src/datetime.h lib/datetime
	exec $(CC) -o $@ -shared $< $(LDFLAGS)

test: lib/datetime/core.$(EXT) lib/datetime.lua test.lua
	exec luajit test.lua

clean:
	rm -f lib/datetime/core.*
