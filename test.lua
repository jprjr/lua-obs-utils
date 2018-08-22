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
  print("Running test " .. title)
  if type(st_table) == 'table' then
    for k,v in pairs(st_table) do
      local d_v = format_type(v)
      local d_myv = format_type(my_table[k])
      print (k .. ', ' .. d_v .. '=' .. d_myv)
      if my_table[k] ~= v then
        print("Error on key " .. k .. ", expected " .. d_v .. ", got " .. d_myv)
        os.exit(1)
      end
    end
  else
    local d_v = format_type(st_table)
    local d_myv = format_type(my_table)
    print (k .. ', ' .. d_v .. '=' .. d_myv)
    if st_table ~= my_table then
      print("Error: expected " .. d_v .. ", got " .. d_myv)
      os.exit(1)
    end
  end
end

test("Local time test",os.date("*t"),datetime.date("*t"))
test("UTC time test",  os.date("!*t"),datetime.date("!*t"))

print("All tests passed")
os.exit(0)

