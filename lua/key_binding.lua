
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
map("n", "<Leader>d", "<Cmd>lua require('dapui').toggle()<CR>", {desc = "Toggle Debug"})
map("n", "<Right>", "<Cmd>DapStepOver<Cr>", {})
map("n", "<Up>", "<Cmd>DapStepInto<Cr>", {})
map("n", "<Down>", "<Cmd>DapStepOut<Cr>", {})
map("n", "<Leader>r", "<Cmd>DapContinue<Cr>", {})
map("n", "<Leader>e", "<Cmd>CMakeBuild -j 9<Cr>", {})
map("n", "<Leader>q", "<Cmd>DapTerminate<Cr>", {})
