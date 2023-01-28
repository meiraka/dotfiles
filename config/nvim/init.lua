local ensure_packer = function()
    local fn = vim.fn
    local install_path = fn.stdpath('data') .. '/site/pack/packer/start/packer.nvim'
    if fn.empty(fn.glob(install_path)) > 0 then
        fn.system({ 'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path })
        vim.cmd [[packadd packer.nvim]]
        return true
    end
    return false
end

local packer_bootstrap = ensure_packer()

return require('packer').startup(function(use)
    use { 'wbthomason/packer.nvim' }
    use { 'junegunn/fzf', run = ':call fzf#install()' }
    use { 'junegunn/fzf.vim' }
    use { 'mattn/vim-goimports' }
    use { 'neovim/nvim-lspconfig',
        requires = {
            { 'williamboman/mason.nvim' },
            { 'williamboman/mason-lspconfig.nvim' },
            { 'hrsh7th/nvim-cmp' },
            { 'hrsh7th/cmp-nvim-lsp' },
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
                sources = { { name = "nvim_lsp" } },
                mapping = cmp.mapping.preset.insert({
                    ["<C-p>"] = cmp.mapping.select_prev_item(),
                    ["<C-n>"] = cmp.mapping.select_next_item(),
                    ['<C-l>'] = cmp.mapping.complete(),
                    ['<C-e>'] = cmp.mapping.abort(),
                    ["<CR>"] = cmp.mapping.confirm { select = true },
                }),
            })
        end
    }
    use { 'ellisonleao/gruvbox.nvim', config = function() vim.cmd('colorscheme gruvbox') end }
    use { 'nvim-treesitter/nvim-treesitter',
        run = function()
            local ts_update = require('nvim-treesitter.install').update({ with_sync = true })
            ts_update()
        end,
        config = function()
            require('nvim-treesitter.configs').setup({
                ensure_installed = { 'go', 'css', 'yaml', 'regex', 'bash', 'markdown', 'markdown_inline' },
                highlight = {
                    enable = true,
                    disable = { 'lua', 'vim', 'javascript' },
                },
            })
        end
    }
    use { 'akinsho/toggleterm.nvim', tag = '*', config = function() require("toggleterm").setup() end }
    use({ "folke/noice.nvim",
        requires = {
            "MunifTanjim/nui.nvim",
            "rcarriga/nvim-notify",
        },
        config = function()
            require("noice").setup({})
        end,
    })

    vim.g.mapleader = " "
    vim.keymap.set('n', '<leader>h', vim.lsp.buf.hover)
    vim.keymap.set('n', '<leader>r', vim.lsp.buf.rename)
    vim.keymap.set('n', '<leader>b', '<cmd>b#<cr>')

    vim.keymap.set('n', '<c-t>', '<Cmd>exe v:count1 . "ToggleTerm"<CR>')
    vim.keymap.set('n', 'ff', '<cmd>Files<cr>')
    vim.keymap.set('n', 'fb', '<cmd>Buffers<cr>')
    vim.opt.mouse = nil
    vim.cmd([[
command LspDefinition lua vim.lsp.buf.definition()
command LspFormat lua vim.lsp.buf.format { async = true }
command LspReferences lua vim.lsp.buf.references()
command LspCodeAction lua vim.lsp.buf.code_action()
set laststatus=0
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

    -- Automatically set up your configuration after cloning packer.nvim
    -- Put this at the end after all plugins
    if packer_bootstrap then
        require('packer').sync()
    end
end)
