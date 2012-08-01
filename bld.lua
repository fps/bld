require "dumper"

function lift(x)
	local v = x
	return function()
		return v
	end
end


function cpp_closure(compiler, source)
	command = compiler .. " " .. "-c" .. " " .. source
	print("executing: ", command)
	os.execute (command) 
	return true
end

function cpp(source)
	local s = source
	return function() 
		return cpp_closure("g++", s) 
	end 
end

function dynlib_closure(name, tasks)
	print ("building: ", name, " (dynlib)")
	for i = 1, # tasks do 
		tasks[i]() 
	end 
	return true
end

function dynlib(name, sources)
	local s = sources()
	local tasks = {}
	for i = 1, #s do
		print ("adding task: ", s[i])
		local task = cpp(s[i])
		table.insert(tasks, task) 
	end
	return function ()
		return dynlib_closure(name, tasks) 
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

function configure() 
	return { dynlib("foo", glob("*.c")) } end

if arg[1] == "configure" then
	local t = configure()
	local out = assert(io.open("out.bld", "wb"))
	out:write(DataDumper(t))
	assert(out:close()) end

if arg[1] == "build" then
	local t = dofile("out.bld")
	t[1]() end

