require "bld"

require "util"
require "file_system"

-- packages is a table returned by the pkg_config function
function cpp_compiler(packages)
	local compiler = { }

	local p = packages

	compiler.compile = function(dependencies, sources) 
		local d = dependencies
		local s = sources
		local f = function ()
			local src = valeval(s)

			for i,j in ipairs(src) do
				local cmd = "g++ -c " .. p.cflags .. " " .. j
				print("cpp_compiler.compile: " .. cmd)
				os.execute(cmd)
			end
		end
		return rule(d, f)
	end

	compiler.shared_library = function(dependencies, basename, sources)
		local d = dependencies
		local s = sources
		
		local f = function()
			local src = table.concat(valeval(s), " ")
			local cmd =  "g++ -shared -fPIC -o lib" .. basename .. ".so" .. p.cflags .. " " .. src 
			print("cpp_compiler.shared_library: " .. cmd)
			os.execute(cmd)
		end
		return rule(d, f)
	end

	return compiler
end
