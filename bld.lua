require "dumper"

function lift(x)
	local v = x
	return function()
		return v
	end
end


function valevaleval(v)
        if type(v) == "function" then
                return valevaleval(v())
        else
                return v
        end
end

function valeval(v)
        if type(v) == "function" then
                return v()
        else
                return v
        end
end

function rule(dependencies, transformation)
	print("-- adding rule") 

	
	local d = dependencies
	local tr = transformation

        return function()
			if type(d) == "table" then
				for i,j in pairs(d) do
					valeval(j)
				end
			else 
				valeval(d)
			end
                        tr()
        end
end

function exists(n)
	local f = io.open(n)
	if f then
		io.close(f)
	end
	return f ~= nil
end

function file_check(dependency)
	local s = dependency
	
	return function(dependency) 
		if exists(valeval(s)) then
			return true
		end

		print ("-- -- build")
		return false
	end
end

function shell_cmd(dependencies, cmd)
	local d = dependencies
	local c = cmd

	local f = function() 
		print("-- running: ", cmd)
		os.execute(c) 
	end
        return rule(d, f)
end

function pkg(name, version, rules)
	local n = name
	local v = version
	local r = rules
	
	return function()
		print("-- project: ", name, " version: ", version)
		for target,build in pairs(r) do
			build()
		end
	end
end

function glob_closure(globble)
	return { "foo.c", "foo2.c" } 
end

function glob(globble)
	return function()
		return glob_closure(globble) 
	end 
end


function bld(args, configure)
	if args[1] == "configure" then
		local t = { configure() }
		local out = assert(io.open("out.bld", "wb"))
		out:write(DataDumper(t))
		assert(out:close()) 
	end
	
	if args[1] == "build" then
		local t = dofile("out.bld")
		for i,j in pairs(t) do
			j() 
		end
	end
end	
