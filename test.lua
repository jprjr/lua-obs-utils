local datetime = require('lib.datetime')

local my_dt_local = datetime.date("*t")
local lua_dt_local = os.date("*t")

local function format_type(v)
  local t = type(v)
  if t == 'boolean' then
    return (v and 'true' or 'false')
  elseif t == 'nil' then
    return 'nil'
  elseif t == 'string' or t == 'number' then
    return v
  end
  return 'table'
end


local function test(title,st_table,my_table)
  io.stdout:write("Running test " .. title)
  if type(st_table) == 'table' then
    for k,v in pairs(st_table) do
      local d_v = format_type(v)
      local d_myv = format_type(my_table[k])
      -- print (k .. ', ' .. d_v .. '=' .. d_myv)
      if my_table[k] ~= v then
        io.stdout:write("...failure!\n")
        print("  Error on key " .. k .. ", expected " .. d_v .. ", got " .. d_myv)
        os.exit(1)
      end
    end
    io.stdout:write("...passed\n")
    -- print("msec = " .. my_table.msec)
  else
    local d_v = format_type(st_table)
    local d_myv = format_type(my_table)
    -- print (d_v .. '=' .. d_myv)
    if st_table ~= my_table then
      io.stdout:write("...failure!\n")
      print("  expected " .. d_v .. ", got " .. d_myv)
      os.exit(1)
    end
    io.stdout:write("...passed\n")
  end
end

test("date('*t')",os.date("*t"),datetime.date("*t"))
test("date('!*t')",  os.date("!*t"),datetime.date("!*t"))
test("date('*t',906000490.123)", os.date("*t",906000490), datetime.date("*t",906000490.123))
test("date('!*t',906000490.123)", os.date("!*t",906000490), datetime.date("!*t",906000490.123))

test("time()",os.time(),math.floor(datetime.time()))

local dtable = {year = 1998, month = 9, day = 16, 
     hour = 23, min = 48, sec = 10, isdst = false}

local dstable = {year = 1998, month = 9, day = 16, 
     hour = 23, min = 48, sec = 10, isdst = true}

test("time(table)",os.time(dtable),datetime.time(dtable))
test("time(table[isdst=true])",os.time(dstable),datetime.time(dstable))

test("date('%c')",os.date("%c"),datetime.date("%c"))

test("date('%Y-%m-%d %H:%M:%S',906000490.123)",os.date("%Y-%m-%d %H:%M:%S",906000490.123), datetime.date("%Y-%m-%d %H:%M:%S",906000490.123))

test("date('!%Y-%m-%d %H:%M:%S.%N',906000490.123)","1998-09-17 02:48:10.123", datetime.date("!%Y-%m-%d %H:%M:%S.%N",906000490.123))

print("All tests passed")
os.exit(0)

