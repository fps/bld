require "bld"
require "cpp_compiler"
require "pkg_config"

configure = function() 
	local pkg_config_packages = pkg_config( { { name = "jack" } } )

	local compiler = cpp_compiler()

	local foo1 = shell_cmd("", compiler, "echo", {})
	local foo2 = shell_cmd("", "bar1", "echo", {})

	return pkg("foo", "0.1", { foo1, foo2 }) 
end

bld(arg, configure)

