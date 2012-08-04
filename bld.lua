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

function rule_closure(source, transformation, parameters, check)
	if not (nil == check) then 
		--  print ("-- check!")
		if check(valeval(target), valeval(source)) == true  then
			print ("-- done")
			return 
		end
	end

	print ("-- transforming: ", valeval(source))
        return transformation(valeval(source), valeval(parameters))
end

function rule(sources, transformation, parameters, check)
	print("-- adding rule") 

	
	local s = sources
	local tr = transformation
	local p = parameters
	local c = check

        return function()
                        return rule_closure(s, tr, p, c)
        end
end

function exists(n)
	local f = io.open(n)
	if f then
		io.close(f)
	end
	return f ~= nil
end

function file_check(source)
	local s = source
	
	return function(source) 
		if exists(valeval(s)) then
			return true
		end

		print ("-- -- build")
		return false
	end
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
        return rule(s, f, {  }, file_check(t))
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
