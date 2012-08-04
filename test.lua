require "bld"

configure = function() 
	local compiler = cc("foo.o", "foo.c", {})	

	local foo1 = shell_cmd("foo1", compiler, "echo", {})
	local foo2 = shell_cmd("foo2", "bar1", "echo", {})

	return pkg("foo", "0.1", { foo1, foo2 }) 
end

bld(arg, configure)

