local ffi = require'ffi'

ffi.cdef[[
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

int get_datetime(datetime_t *dt, int utc);
double get_time(datetime_t *dt);
]]

local tlib
local os = string.lower(ffi.os)

if os == 'osx' or os == 'linux' then
  tlib = ffi.load('./lib/datetime/core.so')
else
  tlib = ffi.load('./lib/datetime/core.dll')
end

local datetime = {}

function datetime.time(time)
  local dt
  if time then
    dt = ffi.new("datetime_t")
    dt.year = time.year
    dt.mon = time.month
    dt.mday = time.day
    dt.hour = time.hour
    dt.min = time.min
    dt.sec = time.sec
    dt.isdst = time.isdst and 1 or 0
  end
  return tlib.get_time(dt)
end

function datetime.date(format,time)
  local utc_test = format:sub(1,1)
  local utc = format:sub(1,1) == '!' and 1 or 0

  if utc == 1 then
    format = format:sub(2)
  end

  if not time then
    time = ffi.new("datetime_t");
    tlib.get_datetime(time,utc)
  end

  if format == "*t" then
    return {
      year = time.year,
      month = time.mon,
      day = time.mday,
      hour = time.hour,
      min = time.min,
      sec = time.sec,
      milli = time.milli,
      wday = time.wday,
      yday = time.yday,
      isdst = time.isdst == 1
    }
  end
end


return datetime
