return {
    {
        "rebelot/kanagawa.nvim",
        config = function()
            vim.cmd('colorscheme kanagawa')
        end,
    },
    { 'lewis6991/gitsigns.nvim' },
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
        'akinsho/toggleterm.nvim',
        version = '*',
        opts = {
            insert_mappings = true,
            terminal_mappings = true,
        },
        keys = {
            -- { '<c-t>', '<Cmd>exe v:count1 . "ToggleTerm"<CR>', desc = 'toggle terminal' },
        },
    },
    {
        "folke/snacks.nvim",
        priority = 1000,
        lazy = false,
        opts = {
            bigfile = { enabled = true },
            explorer = { enabled = true },
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
            { "<leader>/",       function() Snacks.picker.grep() end,                       desc = "Grep" },
            { "<c-t>",           function() Snacks.terminal() end,                          desc = "Toggle Terminal" },
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
