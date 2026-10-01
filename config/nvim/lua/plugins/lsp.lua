vim.api.nvim_create_autocmd('User', {
    pattern = 'VeryLazy',
    callback = function()
        vim.keymap.set('n', '<leader>r', vim.lsp.buf.rename, { desc = 'LSP Rename' })
        vim.keymap.set('n', '<leader>d', vim.lsp.buf.definition, { desc = 'LSP Definition' })
        vim.keymap.set('n', 'K', function() vim.lsp.buf.hover({ border = 'rounded' }) end, { desc = 'LSP Hover' })

        -- formatting
        local fmt_ignore = { 'gopls', 'ts_ls' }
        vim.api.nvim_create_autocmd('LspAttach', {
            group = vim.api.nvim_create_augroup('MyLspAttach', { clear = true }),
            callback = function(args)
                local client = assert(vim.lsp.get_client_by_id(args.data.client_id))

                for _, name in ipairs(fmt_ignore) do
                    if name == client.name then
                        return
                    end
                end
                if not client:supports_method('textDocument/willSaveWaitUntil') and client:supports_method('textDocument/formatting') then
                    vim.api.nvim_create_autocmd('BufWritePre', {
                        group = vim.api.nvim_create_augroup('LSPFormat/' .. client.name .. tostring(args.buf), { clear = true }),
                        buffer = args.buf,
                        callback = function()
                            vim.lsp.buf.format({ bufnr = args.buf, id = client.id, timeout_ms = 1000 })
                        end,
                    })
                end
            end,
        })

        vim.lsp.config("lua_ls", {
            settings = {
                Lua = {
                    diagnostics = {
                        globals = { 'vim', 'Snacks' },
                        disable = { "missing-parameter", "missing-fields", "undefined-field" },
                    },
                },
            },
        })
        vim.lsp.enable({ "hls" })
        vim.lsp.enable({ "jdtls" })
    end
})
return {
    {
        "mason-org/mason-lspconfig.nvim",
        opts = {
            ensure_installed = {
                "gopls",
                "lua_ls",
                "pylsp",
            },
        },
        dependencies = {
            { "mason-org/mason.nvim", opts = {} },
            "neovim/nvim-lspconfig",
        },
        event = { "BufReadPre", "BufNewFile" },
        cmd = { "Mason" },
    },
    { 'neovim/nvim-lspconfig' },
    { "mfussenegger/nvim-jdtls", ft = "java" },
}
