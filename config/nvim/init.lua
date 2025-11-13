local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
    vim.fn.system({
        "git",
        "clone",
        "--filter=blob:none",
        "https://github.com/folke/lazy.nvim.git",
        "--branch=stable", -- latest stable release
        lazypath,
    })
end
vim.opt.rtp:prepend(lazypath)
require("lazy").setup("plugins")

vim.api.nvim_create_autocmd("QuickFixCmdPost", {
    callback = function()
        vim.cmd([[Trouble qflist open]])
    end,
})

vim.diagnostic.config({
  signs = {
    text = {
      [vim.diagnostic.severity.ERROR] = "󰅚",
      [vim.diagnostic.severity.WARN] = "󰀪",
      [vim.diagnostic.severity.INFO] = "",
      [vim.diagnostic.severity.HINT] = "󰌶",
    },
  },
})

vim.g.mapleader = " "
vim.keymap.set('n', '<leader>t', '<cmd>TestNearest<cr>')
vim.keymap.set('n', '<leader>h', vim.lsp.buf.hover)
vim.keymap.set('n', '<leader>r', vim.lsp.buf.rename)
vim.keymap.set('n', '<leader>b', '<cmd>b#<cr>')
vim.keymap.set('n', '<leader>f', '<cmd>Telescope file_browser<cr>')
vim.keymap.set('n', '<leader>g', '<cmd>Telescope live_grep<cr>')
vim.keymap.set("n", "<leader>l", function() require("trouble").toggle() end)

vim.keymap.set('n', '<c-t>', '<Cmd>exe v:count1 . "ToggleTerm"<CR>')
vim.keymap.set('n', 'ff', '<cmd>Files<cr>')
vim.opt.mouse = ""
vim.cmd([[
command LspDefinition lua vim.lsp.buf.definition()
command LspFormat lua vim.lsp.buf.format { async = true }
command LspReferences lua vim.lsp.buf.references()
command LspCodeAction lua vim.lsp.buf.code_action()
set wildmode=list:longest,full
set termguicolors
set foldmethod=indent
set nofoldenable
set number
set cursorline
set hlsearch
set incsearch
set backspace=start,eol,indent
set tabstop=4
set shiftwidth=4
set expandtab
    ]])
