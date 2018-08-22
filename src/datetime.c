#include "datetime.h"

#include <time.h>
#include <sys/time.h>

#define yisleap(year) \
    ((year % 4 == 0 && year % 100 != 0) || (year % 400 == 0))

static const int days[2][13] = {
    {0, 0, 31, 59, 90, 120, 151, 181, 212, 243, 273, 304, 334},
    {0, 0, 31, 60, 91, 121, 152, 182, 213, 244, 274, 305, 335}
};

#define get_yday(year,month,day) \
    (days[yisleap(year)][month] + day)

SHARED_FUNC double get_time(datetime_t *dt) {
#ifndef WINDOWS
    struct timeval tv;
    double sec;
    double msec;
    gettimeofday(&tv,NULL);
    tv.tv_usec /= 1000;
    sec = (double)tv.tv_sec;
    msec = (double)tv.tv_usec;
    msec /= 1000;

    return sec + msec;
#else
    return 0;
#endif
}


SHARED_FUNC int get_datetime(datetime_t *dt, int utc) {
#ifdef WINDOWS
    SYSTEMTIME st;
    TIME_ZONE_INFORMATION tz;
    if(utc) {
        GetSystemTime(&st);
        dt->isdst = 0;
    }
    else {
        GetLocalTime(&st);
        dt->isdst = (GetTimeZoneInformation(&tz) == 2 ? 1 : 0);
    }
    dt->year  = st.wYear;
    dt->mon   = st.wMonth;
    dt->mday  = st.wDay;
    dt->hour  = st.wHour;
    dt->min   = st.wMinute;
    dt->sec   = st.wSecond;
    dt->milli = st.wMilliseconds;
    dt->wday  = st.wDayOfWeek + 1;

    dt->yday  = get_yday(dt->year,dt->mon,dt->mday);

#else
    struct tm tm;
    struct timeval tv;

    gettimeofday(&tv,NULL);
    if(utc) {
        gmtime_r(&tv.tv_sec, &tm);
    }
    else {
        localtime_r(&tv.tv_sec,&tm);
    }

    dt->year = tm.tm_year + 1900;
    dt->mon = tm.tm_mon + 1;
    dt->mday = tm.tm_mday;
    dt->hour = tm.tm_hour;
    dt->min = tm.tm_min;
    dt->sec = tm.tm_sec;
    dt->hour = tm.tm_hour;
    dt->wday = tm.tm_wday + 1;
    dt->yday = tm.tm_yday + 1;
    dt->isdst = tm.tm_isdst;
    dt->milli = (tv.tv_usec / 1000);
#endif

    return 0;

}

#ifdef WINDOWS
BOOL WINAPI DllMainCRTStartup(HINSTANCE hinstDLL,DWORD fdwReason,LPVOID lpReserved)
{
    (void)hinstDLL;
    (void)fdwReason;
    (void)lpReserved;
	return 1;
}

#endif
