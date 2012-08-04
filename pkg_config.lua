function capture_cmd_output(cmd)
	local tmp = os.tmpname()
	local command = cmd .. " > " .. tmp
	-- print("command: " , command)
	os.execute(cmd .. " > " .. tmp)
	
	-- print("reading output")
	local file = io.input(tmp)
	local result = io.read("*all")

	io.close(file)

	-- print("removing tmp file: ", tmp)
	os.execute("rm " .. tmp)

	-- print("output: ", result)
	return result
end

function remove_newlines(string)
	return string:gsub("\n", "")
end

-- packages is a table of tables where every table 
-- has keys:
--
-- name: package name
-- 
-- optional:
--
-- version: precise version
-- min_version: minimum version
-- max_version: maximum version
function pkg_config(packages)
	local cflags_out = "" 
	local ldflags_out = ""
	local aflags_out = ""

	for key, pkg in pairs(packages) do
		local cflags = remove_newlines(capture_cmd_output("pkg-config --cflags " .. pkg.name))
		local ldflags = remove_newlines(capture_cmd_output("pkg-config --libs " .. pkg.name))
		local aflags = remove_newlines(capture_cmd_output("pkg-config --static " .. pkg.name))

		cflags_out = cflags_out .. " " .. cflags
		ldflags_out = ldflags_out .. " " .. ldflags
		aflags_out = aflags_out .. " " .. aflags

		print("pkg_config: ", pkg.name, " cflags: ", "\"".. cflags .. "\"", " ldflags: ", "\"" .. ldflags .. "\"", " static: " .. "\"" .. aflags .. "\"")
	end

	return { cflags = cflags_out, ldflags = ldflags_out }
end

