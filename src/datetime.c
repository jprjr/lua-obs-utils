#include "datetime.h"

#include <time.h>
#include <sys/time.h>

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
    dt->mon   = st.wMonth - 1;
    dt->mday  = st.wDay;
    dt->hour  = st.wHour;
    dt->min   = st.wMinute;
    dt->sec   = st.wSecond;
    dt->milli = st.wMilliseconds;
    dt->wday  = st.wDayOfWeek;

    dt->yday = 0;

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
    dt->mon = tm.tm_mon;
    dt->mday = tm.tm_mday;
    dt->hour = tm.tm_hour;
    dt->min = tm.tm_min;
    dt->sec = tm.tm_sec;
    dt->hour = tm.tm_hour;
    dt->wday = tm.tm_wday;
    dt->yday = tm.tm_yday;
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
