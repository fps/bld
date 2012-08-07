require "util"

function glob_now(globble)
	return capture_cmd_output_lines("ls " .. globble) 
end

function glob(globble)
	local g = globble
	return function()
	       return glob_now(g) 
	end 
end



