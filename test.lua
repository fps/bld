require "bld"
require "cpp_compiler"
require "pkg_config"

configure = function() 
	local packages = pkg_config( { { name = "jack" }, { name = "sndfile" }, { name = "lilv-0" } } )

	local compiler = cpp_compiler(packages)

	local foo = compiler.compile({}, glob("*.cc")) 
	local foolib = compiler.shared_library(foo, "foo", glob("*.o"))

	return pkg("foo", "0.1", { foolib }) 
end

bld(arg, configure)

