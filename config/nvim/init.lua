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
require("lazy").setup({
    { "rebelot/kanagawa.nvim", config = function()
            vim.cmd('colorscheme kanagawa')
        end,
    },
    { 'junegunn/fzf', build = ':call fzf#install()' },
    { 'junegunn/fzf.vim' },
    { 'mattn/vim-goimports' },
    { 'neovim/nvim-lspconfig',
        dependencies = {
            'williamboman/mason.nvim',
            'williamboman/mason-lspconfig.nvim',
            'hrsh7th/nvim-cmp',
            'hrsh7th/cmp-nvim-lsp',
            'hrsh7th/cmp-vsnip',
            'hrsh7th/vim-vsnip',
        },
        config = function()
            require('mason').setup()
            require("mason-lspconfig").setup()
            require('mason-lspconfig').setup_handlers({ function(server)
                require('lspconfig')[server].setup({
                    capabilities = require('cmp_nvim_lsp').default_capabilities(),
                    settings = {
                        Lua = { diagnostics = { globals = { 'vim' } } }, -- suppress neovim's undefined global `vim`
                    },
                })
            end
            })
            require('lspconfig').hls.setup({
                capabilities = require('cmp_nvim_lsp').default_capabilities(),
                filetypes = { 'haskell', 'lhaskell', 'cabal' },
            })
            local cmp = require("cmp");
            cmp.setup({
                snippet = { expand = function(args) vim.fn["vsnip#anonymous"](args.body) end },
                sources = {
                    { name = "nvim_lsp" },
                    { name = 'vsnip' },
                },
                mapping = cmp.mapping.preset.insert({
                    ["<C-p>"] = cmp.mapping.select_prev_item(),
                    ["<C-n>"] = cmp.mapping.select_next_item(),
                    ['<C-l>'] = cmp.mapping.complete(),
                    ['<C-e>'] = cmp.mapping.abort(),
                    ["<CR>"] = cmp.mapping.confirm { select = true },
                }),
            })
        end
    },
    { 'nvim-lualine/lualine.nvim', dependencies = { 'nvim-tree/nvim-web-devicons' }, config = function()
        require('nvim-web-devicons').setup({})
        -- laststatus = 3 errors with noice
        -- vim.opt.laststatus = 3
        vim.opt.laststatus = 2
        require('lualine').setup({
            options = {
                -- globalstatus = true,
                -- theme = 'gruvbox',
                theme = 'kanagawa',
            },
            sections = {
                lualine_a = { 'mode' },
                lualine_b = { 'filetype' },
                lualine_x = { 'diff' },
                lualine_y = {},
                lualine_z = { 'diagnostics' },
            },
        })
    end },
    { 'lewis6991/gitsigns.nvim', config = function() require('gitsigns').setup() end },
    { 'tpope/vim-fugitive' },
    { 'nvim-treesitter/nvim-treesitter', version = '*',
        build = ":TSUpdate",
        config = function()
            require('nvim-treesitter.configs').setup({
                ensure_installed = { 'go', 'css', 'yaml', 'regex', 'bash', 'markdown', 'markdown_inline' },
                sync_install = false,
                highlight = {
                    enable = true,
                    disable = { 'lua', 'vim', 'javascript' },
                },
            })
        end
    },
    { 'akinsho/toggleterm.nvim', version = '*', config = function()
        require("toggleterm").setup({
            insert_mappings = true,
            terminal_mappings = true,
        })
    end },
    { 'klen/nvim-test', config = function()
        require('nvim-test').setup({
            term = 'toggleterm',
    })
    end },
    { 'nvim-telescope/telescope.nvim',
        dependencies = {
            'nvim-telescope/telescope-file-browser.nvim',
            'nvim-lua/plenary.nvim',
        },
        config = function()
            if vim.fn.executable('rg') == 0 then
                if vim.fn.executable('cargo') == 1 then
                    vim.fn.jobstart('cargo install ripgrep')
                end
            end
            require('telescope').setup({
                hijack_netrw = true,
            })
            require('telescope').load_extension 'file_browser'
        end
    },
    { 'folke/trouble.nvim',
        dependencies = { "nvim-tree/nvim-web-devicons" },
    },
    { 'elkowar/yuck.vim' },
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
vim.opt.mouse = nil
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
