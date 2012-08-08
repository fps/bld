require "dumper"

local x = "foobar"

local f = function() 
	print("foo", x)
end

t = { f, f }

print(DataDumper(t))
