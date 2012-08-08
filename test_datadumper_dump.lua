require "dumper"

local x = "foobar"

local f = function() 
	print("foo and x is: ", x)
end

t = { f, f }

print(DataDumper(t))
