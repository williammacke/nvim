vim.g.maplocalleader = ' '
require("config.lazy")



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

dap.defaults.fallback.auto_continue_if_many_stopped = false
dap.defaults.cpp.auto_continue_if_many_stopped = false
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

require("dapui").setup({
	layouts = { {
		elements = { {
			id = "scopes",
			size = 0.25
		}, {
			id = "breakpoints",
			size = 0.25
		}, {
			id = "stacks",
			size = 0.25
		}, {
			id = "watches",
			size = 0.25
		} },
		position = "left",
		size = 30
	}, {
		elements= {{
			id = "repl",
			size = 1.0
		}},
		position = "bottom",
		size = 10
	}}})



	require("key_binding")
	require("rooting")
