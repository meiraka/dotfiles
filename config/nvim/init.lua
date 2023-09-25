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
    -- use { 'ellisonleao/gruvbox.nvim', config = function()
    --     require("gruvbox").setup({
    --         italic = false,
    --     })
    --     vim.cmd('colorscheme gruvbox')
    -- end }
    use { 'rebelot/kanagawa.nvim', config = function()
        vim.cmd('colorscheme kanagawa')
    end }
    use { 'junegunn/fzf', run = ':call fzf#install()' }
    use { 'junegunn/fzf.vim' }
    use { 'mattn/vim-goimports' }
    use { 'neovim/nvim-lspconfig',
        requires = {
            { 'williamboman/mason.nvim' },
            { 'williamboman/mason-lspconfig.nvim' },
            { 'hrsh7th/nvim-cmp' },
            { 'hrsh7th/cmp-nvim-lsp' },
            { 'hrsh7th/cmp-vsnip' },
            { 'hrsh7th/vim-vsnip' },
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
    }
    use { 'nvim-lualine/lualine.nvim', requires = { 'nvim-tree/nvim-web-devicons' }, config = function()
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
    end }
    use { 'lewis6991/gitsigns.nvim', config = function() require('gitsigns').setup() end }
    use { 'tpope/vim-fugitive' }
    use { 'nvim-treesitter/nvim-treesitter', tag = '*',
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
    use { 'akinsho/toggleterm.nvim', tag = '*', config = function()
        require("toggleterm").setup({
            insert_mappings = true,
            terminal_mappings = true,
        })
    end }
    use { 'klen/nvim-test', config = function()
        require('nvim-test').setup({
            term = 'toggleterm',
        })
    end }
    use { 'nvim-telescope/telescope.nvim',
        requires = {
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
    }

    -- use({ "folke/noice.nvim",
    --     requires = {
    --         "MunifTanjim/nui.nvim",
    --         "rcarriga/nvim-notify",
    --     },
    --     config = function()
    --         require("notify").setup({ background_colour = '#000000'})
    --         require("noice").setup({})
    --     end,
    -- })
    
    use { 'elkowar/yuck.vim' }

    vim.g.mapleader = " "
    vim.keymap.set('n', '<leader>t', '<cmd>TestNearest<cr>')
    vim.keymap.set('n', '<leader>h', vim.lsp.buf.hover)
    vim.keymap.set('n', '<leader>r', vim.lsp.buf.rename)
    vim.keymap.set('n', '<leader>b', '<cmd>b#<cr>')
    vim.keymap.set('n', '<leader>f', '<cmd>Telescope file_browser<cr>')
    vim.keymap.set('n', '<leader>g', '<cmd>Telescope live_grep<cr>')

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

    -- Automatically set up your configuration after cloning packer.nvim
    -- Put this at the end after all plugins
    if packer_bootstrap then
        require('packer').sync()
    end
end)
