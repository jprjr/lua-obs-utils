# lua-obs-utils

Just starting on a small collection of utility scripts for OBS.

## Build instructions

I usually build this on MacOS + Docker, this allows me to build
for all 3 OBS platforms at once.

Just run:

```
make dist
```

And you'll have a tar.gz and .zip made with a ready-to-go package.

## Scripts

### time.lua

A script for displaying a basic clock in OBS. Uses a C module
to get time in milliseconds.

## Downloads

See the [releases tab](https://github.com/jprjr/lua-obs-utils/releases)
for downloads with binaries for MacOS, Windows, and Linux.

## LICENSE

MIT license, see `LICENSE`
