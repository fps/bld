require "bld"
require "cpp_compiler"
require "pkg_config"

configure = function() 
	local packages = pkg_config( { { name = "jack" }, { name = "sndfile" } } )

	local compiler = cpp_compiler(packages)

	local foo = compiler.compile("foo.cc") 
	local foolib = compiler.shared_library("foo", foo)

	return pkg("foo", "0.1", { foo1 }) 
end

bld(arg, configure)

