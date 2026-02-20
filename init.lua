vim.g.maplocalleader = ' '
require("config.lazy")
local function map(mode, lhs, rhs, opts)
    local options = { noremap = true, silent = true }
    if opts then
        if opts.desc then
            opts.desc = "keymaps.lua: " .. opts.desc
        end
        options = vim.tbl_extend('force', options, opts)
    end
    vim.keymap.set(mode, lhs, rhs, options)
end


map("i", "fj", "<Esc>", {desc = "Exit insert mode"})
map("n", "<Leader>b", "<Cmd>DapToggleBreakpoint<Cr>", {desc = "Toggle breakpoint"})


vim.api.nvim_create_autocmd('FileType', {
  pattern = { 'cpp' },
  callback = function() vim.treesitter.start()
	  vim.wo[0][0].foldexpr = 'v:lua.vim.treesitter.foldexpr()'
	  vim.wo[0][0].foldmethod = 'expr' 
          end,
})


require("referencer").setup({
    enable = false,                      -- enable after LSP attach
    format = "  %d reference(s)",       -- format string for reference count
    show_no_reference = true,            -- show if refs count = 0
    kinds = { 5, 6, 8, 12, 13, 14, 23}, -- LSP SymbolKinds to show references for
    hl_group = "Comment",                -- default highlight group
    color = nil,                         -- optional custom color (overrides hl_group)
    virt_text_pos = "eol",               -- virtual text position (eol | overlay | right_align)
    pattern = nil,                       -- pattern for LspAttach autocmd to auto-enable
    lsp_servers = {}                     -- list of servers for which this plugin will be active. nil or {} is ALL LSP clients
})

vim.lsp.enable({"clangd"})

local dap = require("dap")
dap.adapters.gdb = {
  type = "executable",
  command = "gdb",
  args = { "--interpreter=dap", "--eval-command", "set print pretty on" }
}

dap.configurations.c = {
  {
    name = "Launch",
    type = "gdb",
    request = "launch",
    program = function()
      return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
    end,
    args = {}, -- provide arguments if needed
    cwd = "${workspaceFolder}",
    stopAtBeginningOfMainSubprogram = false,
  },
  {
    name = "Select and attach to process",
    type = "gdb",
    request = "attach",
    program = function()
      return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
    end,
    pid = function()
      local name = vim.fn.input('Executable name (filter): ')
      return require("dap.utils").pick_process({ filter = name })
    end,
    cwd = '${workspaceFolder}'
  },
  {
    name = 'Attach to gdbserver :1234',
    type = 'gdb',
    request = 'attach',
    target = 'localhost:1234',
    program = function()
      return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
    end,
    cwd = '${workspaceFolder}'
  }
}

dap.configurations.cpp = dap.configurations.c
test_var = 10


function set_project_root()
	local git_dir = vim.fn.system("git rev-parse --show-toplevel")
	if string.match(git_dir, "fatal:.*") == nil then
		local trimmed_dir = string.gsub(git_dir, "^%s*(.-)%s*$", "%1")
		vim.api.nvim_set_current_dir(trimmed_dir)
	end
end
