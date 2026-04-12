local function set_project_root()
	local git_dir = vim.fn.system("git rev-parse --show-toplevel")
	if string.match(git_dir, "fatal:.*") == nil then
		local trimmed_dir = string.gsub(git_dir, "^%s*(.-)%s*$", "%1")
		vim.api.nvim_set_current_dir(trimmed_dir)
	end
end
local function source_init()
	local is_readable = vim.fn.filereadable("init.lua")
	if is_readable ~= 0 then
		require("init")
	end
end

vim.api.nvim_create_autocmd({"BufEnter", "BufWinEnter"}, {
	callback = function()
		set_project_root()
		source_init()
	end
})

