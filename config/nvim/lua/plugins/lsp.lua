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
            { '<leader>r', vim.lsp.buf.rename,                                       desc = 'LSP Rename' },
            { '<leader>d', vim.lsp.buf.definition,                                   desc = 'LSP Definition' },
            { 'K',         function() vim.lsp.buf.hover({ border = 'rounded' }) end, desc = 'LSP Hover' },
        },
        event = { "BufReadPre", "BufNewFile" },
        config = function()
            require('mason').setup()
            require("mason-lspconfig").setup()
            vim.lsp.config("*", {
                capabilities = require('cmp_nvim_lsp').default_capabilities(),
            })

            vim.lsp.config("lua_ls", {
                capabilities = require('cmp_nvim_lsp').default_capabilities(),
                settings = {
                    Lua = { diagnostics = { globals = { 'vim', 'Snacks' } } },
                },
            })
            vim.lsp.config("hls", {
                capabilities = require('cmp_nvim_lsp').default_capabilities(),
                filetypes = { 'haskell', 'lhaskell', 'cabal' },
            })
            vim.lsp.enable({ "hls" })
            vim.api.nvim_create_autocmd('LspAttach', {
                group = vim.api.nvim_create_augroup('my.lsp', {}),
                callback = function(args)
                    local client = assert(vim.lsp.get_client_by_id(args.data.client_id))
                    if not client:supports_method('textDocument/willSaveWaitUntil') and client:supports_method('textDocument/formatting') then
                        vim.api.nvim_create_autocmd('BufWritePre', {
                            group = vim.api.nvim_create_augroup('my.lsp', { clear = false }),
                            buffer = args.buf,
                            callback = function()
                                vim.lsp.buf.format({ bufnr = args.buf, id = client.id, timeout_ms = 1000 })
                            end,
                        })
                    end
                end,
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
