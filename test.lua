require "bld"

configure = function() 
	local foo1 = shell_cmd("foo1", "bar1", "echo", {})
	local foo2 = shell_cmd("foo2", "bar1", "echo", {})

	return pkg("foo", "0.1", { foo1, foo2 }) 
end

bld(arg, configure)

