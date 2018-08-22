print(package.searchpath('lib.datetime',package.path))
local datetime = require('lib.datetime')
local inspect = require'inspect'

print(inspect(datetime.date("*t")))
print(inspect(os.date("*t")))
print('--------')

print(inspect(datetime.date("!*t")))
print(inspect(os.date("!*t")))
