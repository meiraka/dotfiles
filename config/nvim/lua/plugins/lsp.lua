vim.api.nvim_create_autocmd('User', {
    pattern = 'VeryLazy',
    callback = function()
        vim.api.nvim_create_autocmd('LspAttach', {
            group = vim.api.nvim_create_augroup('my.lsp', {}),
            callback = function(args)
                local client = assert(vim.lsp.get_client_by_id(args.data.client_id))
                if not client:supports_method('textDocument/willSaveWaitUntil') and client:supports_method('textDocument/formatting') then
                    vim.api.nvim_create_autocmd('BufWritePre', {
                        group = vim.api.nvim_create_augroup('my.lsp', { clear = false }),
                        buffer = args.buf,
                        callback = function()
                            if vim.bo.filetype ~= "go" then
                                vim.lsp.buf.format({ bufnr = args.buf, id = client.id, timeout_ms = 1000 })
                            end
                        end,
                    })
                end
            end,
        })

        vim.lsp.config("lua_ls", {
            settings = {
                Lua = { diagnostics = { globals = { 'vim', 'Snacks' } } },
            },
        })
        vim.lsp.enable({ "hls" })
    end
})
return {
    {
        "mason-org/mason-lspconfig.nvim",
        opts = {},
        dependencies = {
            { "mason-org/mason.nvim", opts = {} },
            "neovim/nvim-lspconfig",
        },
        event = { "BufReadPre", "BufNewFile" },
        cmd = { "Mason" },
        keys = {
            { '<leader>r', vim.lsp.buf.rename,                                       desc = 'LSP Rename' },
            { '<leader>d', vim.lsp.buf.definition,                                   desc = 'LSP Definition' },
            { 'K',         function() vim.lsp.buf.hover({ border = 'rounded' }) end, desc = 'LSP Hover' },
        },
    },
    { 'neovim/nvim-lspconfig' },
}
