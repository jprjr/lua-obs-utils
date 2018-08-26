#ifndef JPR_PLATFORM_H
#define JPR_PLATFORM_H

#if defined(_WIN32) || defined(_WIN64) || defined(WIN32)
#define WINDOWS
#include <windows.h>
#define SHARED_FUNC __declspec(dllexport)

#else
#define _POSIX_C_SOURCE 200809L
#define SHARED_FUNC
#endif

#endif
