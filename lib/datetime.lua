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
]]

local tlib
local os = string.lower(ffi.os)

if os == 'osx' or os == 'linux' then
  tlib = ffi.load('./lib/datetime/core.so')
else
  tlib = ffi.load('./lib/datetime/core.dll')
end

local datetime = {}

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
      month = time.mon + 1,
      day = time.mday,
      hour = time.hour,
      min = time.min,
      sec = time.sec,
      milli = time.milli,
      wday = time.wday + 1,
      yday = time.yday + 1,
      isdst = time.isdst == 1
    }
  end
end


return datetime
