-- packages is a table returned by the pkg_config function
function cpp_compiler(packages)
	local compiler = { }

	compiler.compile = function(source) 
		return shell_cmd(source, "g++ -c " .. packages.cflags .. " " .. valeval(source))
	end

	compiler.shared_library = function(name , sources)
		
		return shell_cmd(source, "g++ -shared -fPIC -o" .. name .. )
	end

	return compiler
end
