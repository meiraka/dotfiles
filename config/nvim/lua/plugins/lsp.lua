return {
    {
        'neovim/nvim-lspconfig',
        dependencies = {
            'williamboman/mason.nvim',
            'williamboman/mason-lspconfig.nvim',
            'hrsh7th/nvim-cmp',
            'hrsh7th/cmp-nvim-lsp',
            'hrsh7th/cmp-vsnip',
            'hrsh7th/vim-vsnip',
        },
        keys = {
            { '<leader>r', vim.lsp.buf.rename, desc = 'rename' },
            { '<leader>d', vim.lsp.buf.definition , desc = 'jump to definition' },
        },
        event = { "BufReadPre", "BufNewFile" },
        config = function()
            require('mason').setup()
            require("mason-lspconfig").setup()
            vim.lsp.config("lua_ls", {
                settings = {
                    Lua = { diagnostics = { globals = { 'vim', 'Snacks' } } },
                },
            })
            vim.lsp.config("hls", {
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
}
