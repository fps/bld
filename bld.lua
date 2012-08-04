require "dumper"
require "pkg_config"

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

function rule_closure(target, source, transformation, parameters, check)
	if not (nil == check) then 
		--  print ("-- check!")
		if check(valeval(target), valeval(source)) == true  then
			print ("-- done")
			return 
		end
	end

	print ("-- building: ", valeval(target), "from: ", valeval(source))
        return transformation(valeval(target), valeval(source), valeval(parameters))
end

function rule(target, sources, transformation, parameters, check)
	print("-- adding rule") 

	local t = target
	local s = sources
	local tr = transformation
	local p = parameters
	local c = check

        return function()
                        return rule_closure(t, s, tr, p, c)
        end
end

function exists(n)
	local f = io.open(n)
	if f then
		io.close(f)
	end
	return f ~= nil
end

function file(target, source)
	local t = target
	return function(target) 
		if exists(valeval(target)) then
			return true
		end

		print ("-- -- build")
		return false
	end
end

function cc(target, source, parameters)
	local t = target
	local s = source
	local p = parameters
	local f = function(target, source, parameters)
		local cmd = "g++ -o " .. valeval(t) .. " -c " .. valeval(s)
		print(cmd)
		os.execute(cmd)
	end
	return rule(t, s, f, p, file(t, s))
end

function exe(target, source, parameters)

end

function shell_cmd(target, source, cmd, parameters)
	local t = target
	local s = source
	local c = cmd
	local p = parameters
	local f = function() 
		print("-- running: ", cmd)
		os.execute(c) 
	end
        return rule(t, s, f, {  }, file(t,s))
end

function pkg(name, version, rules)
	local n = name
	local v = version
	
	return function()
		print("-- project: ", name, " version: ", version)
		for target,build in pairs(rules) do
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
