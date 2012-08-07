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

function capture_cmd_output_lines(cmd)
	local tmp = os.tmpname()
	local command = cmd .. " > " .. tmp
	-- print("command: " , command)
	os.execute(cmd .. " > " .. tmp)

	-- print("reading output")

	local result = { }

	for line in io.lines(tmp) do
		-- print("line: ", line)
		table.insert(result, line)
	end

	-- print("removing tmp file: ", tmp)
	os.execute("rm " .. tmp)

	-- print("output: ", result)
	return result
end


function remove_newlines(string)
	return string:gsub("\n", "")
end


