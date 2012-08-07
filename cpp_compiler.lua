-- packages is a table returned by the pkg_config function
function cpp_compiler(packages)
	local compiler = { }

	local p = packages

	compiler.compile = function(dependencies, source) 
		print(p.cflags)

		function f()
			local cmd = "g++ -c " .. p.cflags .. " " .. source
			print(cmd)
			os.execute(cmd)
		end
		return rule(dependencies, f)
	end

	compiler.shared_library = function(dependencies, basename, sources)
		return shell_cmd(dependencies, "g++ -shared -fPIC -o lib" .. name .. ".so" .. p.ldflags)
	end

	return compiler
end
