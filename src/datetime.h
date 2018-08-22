#ifndef JPR_TIME_H
#define JPR_TIME_H

#include <stdint.h>

#if defined(_WIN32) || defined(_WIN64) || defined(WIN32)
#define WINDOWS
#define SHARED_FUNC __declspec(dllexport)
#include <windows.h>
#else
#define SHARED_FUNC
#define _POSIX_C_SOURCE 200809L
#endif

struct datetime {
  int hour;
  int min;
  int sec;
  int wday;
  int mday;
  int yday;
  int mon;
  int year;
  int isdst;
  int milli;
};

typedef struct datetime datetime_t;

SHARED_FUNC int get_datetime(datetime_t *dt, int utc);
SHARED_FUNC double get_time(datetime_t *dt);

#endif
