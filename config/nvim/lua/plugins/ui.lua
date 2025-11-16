return {
    {
        "rebelot/kanagawa.nvim",
        config = function()
            vim.cmd('colorscheme kanagawa')
        end,
    },
    {
        'lewis6991/gitsigns.nvim',
        event = { 'BufReadPre', 'BufNewFile' },
        keys = {
            { "<leader>gh", function() require('gitsigns').stage_hunk() end,                                       mode = { "n" }, desc = "Git stage hunk" },
            { "<leader>gH", function() require('gitsigns').reset_hunk() end,                                       mode = { "n" }, desc = "Git reset hunk" },
            { "gh",         function() require('gitsigns').stage_hunk({ vim.fn.line('.'), vim.fn.line('v') }) end, mode = { "v" }, desc = "Git stage hunk" },
            { "gH",         function() require('gitsigns').reset_hunk({ vim.fn.line('.'), vim.fn.line('v') }) end, mode = { "v" }, desc = "Git reset hunk" },
        },
    },
    {
        'nvim-lualine/lualine.nvim',
        dependencies = { 'nvim-tree/nvim-web-devicons' },
        opts = {
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
        },
        config = function(_, opts)
            require('nvim-web-devicons').setup({})
            require('lualine').setup(opts)
        end
    },
    {
        "folke/which-key.nvim",
        event = "VeryLazy",
        opts = {
            win = {
                width = 0.8,
                col = 0.5,
                border = "rounded",
            },
        },
        keys = {
            {
                "<leader>?",
                function()
                    require("which-key").show({ global = false })
                end,
                desc = "Buffer Local Keymaps (which-key)",
            },
        },
    },
    {
        "folke/snacks.nvim",
        priority = 1000,
        lazy = false,
        opts = {
            bigfile = { enabled = true },
            explorer = {
                enabled = true,
                replace_netrw = true,
            },
            image = { enabled = true },
            indent = { enabled = true },
            input = { enabled = true },
            picker = { enabled = true },
            notifier = { enabled = true },
            quickfile = { enabled = true },
            scope = { enabled = true },
            statuscolumn = { enabled = true },
            terminal = {
                enabled = true,
                win = { position = 'float' },
                start_insert = false,
                auto_insert = false,
            },
            words = { enabled = true },
        },
        keys = {
            { "<leader><space>", function() Snacks.picker.smart({ filter = { cwd = true } }) end, desc = "Smart Find Files" },
            { "<leader>/",       function() Snacks.picker.grep() end,                             desc = "Grep" },
            { "<c-t>",           function() Snacks.terminal() end,                                desc = "Toggle Terminal" },
            { "<leader>nn",      function() Snacks.notifier.show_history() end,                   desc = "Notification history" },
            { "<leader><Tab>",   function() Snacks.explorer() end,                                desc = "Tree" },
        },
    },
    {
        'folke/trouble.nvim',
        dependencies = { "nvim-tree/nvim-web-devicons" },
        opts = {
            auto_close = true,
            modes = {
                diagnostics = {
                    auto_open = false,
                    preview = {
                        type = "float",
                        relative = "editor",
                        border = "rounded",
                        title = "Preview",
                        title_pos = "center",
                        position = { 0, -2 },
                        size = { width = 0.3, height = 0.3 },
                        zindex = 200,
                    },
                },
                lsp = {
                    focus = true,
                    win = { position = 'right', size = 0.3 },
                },
            },
        },
        cmd = "Trouble",
        keys = {
            { "<leader>xx", "<cmd>Trouble diagnostics toggle<cr>",              desc = "Diagnostics (Trouble)", },
            { "<leader>xX", "<cmd>Trouble diagnostics toggle filter.buf=0<cr>", desc = "Buffer Diagnostics (Trouble)", },
            { "<leader>cs", "<cmd>Trouble symbols toggle focus=false<cr>",      desc = "Symbols (Trouble)", },
            { "<leader>h",  "<cmd>Trouble lsp toggle<cr>",                      desc = "LSP Definitions / references / ... (Trouble)", },
            { "<leader>xl", "<cmd>Trouble loclist toggle<cr>",                  desc = "Location List (Trouble)", },
            { "<leader>xq", "<cmd>Trouble qflist toggle<cr>",                   desc = "Quickfix List (Trouble)", },
        },
    },
}
