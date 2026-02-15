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
