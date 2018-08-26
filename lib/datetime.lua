local ffi = require'ffi'
local floor = math.floor
local match = string.match
local gsub = string.gsub

ffi.cdef[[
struct datetime {
  int year;
  int month;
  int day;
  int hour;
  int min;
  int sec;
  int yday;
  int wday;
  int isdst;
  int msec;
};

typedef struct datetime datetime_t;

struct hrtime {
    int64_t sec;
    int64_t msec;
};

typedef struct hrtime hrtime_t;

int get_datetime(datetime_t *, int);
int get_hrtime(hrtime_t *);
int datetime_to_hrtime(datetime_t *, hrtime_t *);

]]

local tlib

local function init(path)
  local os = string.lower(ffi.os)
  local ext = '.so'
  if os == 'windows' then
    ext = '.dll'
  end

  tlib = ffi.load(path .. '/lib/datetime/core_' .. os .. '_' .. string.lower(ffi.arch) .. ext)
end

local dt_keys = {
  'year','month','day','hour','min','sec','wday','yday','msec',
}

local datetime = {}

local function orzero(v)
  return v ~= nil and v or 0
end

function datetime.time(ts)
  local num
  if not ts then
    local hr = ffi.new("hrtime_t");
    tlib.get_hrtime(hr);
    num = tonumber(hr.sec + (hr.msec / 1000))
  else
    num = os.time(ts)
    num = num + (orzero(ts.msec) / 1000)
  end

  return num
end

function datetime.date(format,time)
  local utc
  local f
  local msec = 0

  if format == nil then
    format = "%c"
  end

  if not time then
    local t = ffi.new("datetime_t")
    local hr = ffi.new("hrtime_t")

    tlib.get_datetime(t,1)
    tlib.datetime_to_hrtime(t,hr)
    time = tonumber(hr.sec)
    msec = tonumber(t.msec)
  else
    msec = floor((time - floor(time)) * 1000)
    time = floor(time)
  end

  format = gsub(format,"%%N",string.format("%03d",msec))

  local r = os.date(format,time)
  if type(r) == "table" then
    r.msec = msec
  end

  return r

end

datetime.clock = os.clock
datetime.init = init


return datetime
