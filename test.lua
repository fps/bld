require "bld"
require "cpp_compiler"
require "pkg_config"

configure = function() 
	local packages = pkg_config( { { name = "jack" } } )

	local compiler = cpp_compiler(packages)

	local foo1 = compiler.compile("foo.cc", { }) 
	-- local foo2 = shell_cmd("", "bar1", "echo", {})

	return pkg("foo", "0.1", { foo1 }) 
end

bld(arg, configure)

