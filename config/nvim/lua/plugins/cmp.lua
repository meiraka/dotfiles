return {
    {
        'saghen/blink.cmp',
        enabled = false,
        version = '1.*',
        dependencies = { 'rafamadriz/friendly-snippets' },
        opts = {
            keymap = { preset = 'enter' },
            completion = { documentation = { auto_show = true, } },
            cmdline = {
                keymap = {
                    preset = 'cmdline',
                    ['<Up>'] = { 'select_prev', 'fallback' },
                    ['<Down>'] = { 'select_next', 'fallback' },
                },
                completion = { list = { selection = { preselect = false, auto_insert = true } } },
            },
        },
    },
    {
        'hrsh7th/nvim-cmp',
        enabled = true,
        dependencies = {
            'hrsh7th/cmp-nvim-lsp',
            'hrsh7th/cmp-vsnip',
            'hrsh7th/vim-vsnip',
        },
        config = function()
            vim.lsp.config("*", {
                capabilities = require('cmp_nvim_lsp').default_capabilities(),
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
