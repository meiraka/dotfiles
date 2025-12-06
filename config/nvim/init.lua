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
vim.g.mapleader = " "

vim.opt.backspace = "start,eol,indent"
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true

vim.opt.mouse = ""
vim.opt.clipboard = 'unnamedplus'
vim.opt.wildmode = "list:longest,full"
vim.opt.termguicolors = true
vim.opt.foldmethod = "indent"
vim.opt.foldenable = false
vim.opt.number = true
vim.opt.cursorline = true
vim.opt.hlsearch = true
vim.opt.incsearch = true
vim.opt.winborder = "rounded"

vim.diagnostic.config({
    severity_sort = true,
    signs = {
        text = {
            [vim.diagnostic.severity.ERROR] = "󰅚",
            [vim.diagnostic.severity.WARN] = "󰀪",
            [vim.diagnostic.severity.INFO] = "",
            [vim.diagnostic.severity.HINT] = "󰌶",
        },
    },
})

vim.keymap.set('n', '<leader>b', '<cmd>b#<cr>')
require("lazy").setup("plugins")
