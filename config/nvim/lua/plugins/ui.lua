return {
    {
        "rebelot/kanagawa.nvim",
        lazy = false,
        priority = 1000,
        config = function()
            vim.cmd('colorscheme kanagawa')
        end,
    },
    {
        'lewis6991/gitsigns.nvim',
        event = { 'BufReadPre', 'BufNewFile' },
        keys = {
            { "<leader>gh", function() require('gitsigns').stage_hunk() end,                                       mode = { "n" },           desc = "Git stage hunk" },
            { "<leader>gH", function() require('gitsigns').reset_hunk() end,                                       mode = { "n" },           desc = "Git reset hunk" },
            { "gh",         function() require('gitsigns').stage_hunk({ vim.fn.line('.'), vim.fn.line('v') }) end, mode = { "v" },           desc = "Git stage hunk" },
            { "gH",         function() require('gitsigns').reset_hunk({ vim.fn.line('.'), vim.fn.line('v') }) end, mode = { "v" },           desc = "Git reset hunk" },
            { "<leader>gp", function() require('gitsigns').preview_hunk() end,                                     desc = "Git preview hunk" },
            { "<leader>ga", function() require('gitsigns').stage_buffer() end,                                     desc = "Git stage buffer" },
            { "<leader>gr", function() require('gitsigns').reset_buffer() end,                                     desc = "Git reset buffer" },
        },
    },
    {
        'nvim-lualine/lualine.nvim',
        dependencies = { 'nvim-tree/nvim-web-devicons' },
        opts = {
            options = {
                -- globalstatus = true,
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
            spec = {
                { "<leader>g", group = "Git" },
                { "<leader>f", group = "Find" },
                { "<leader>x", group = "Diagnostics, Quickfix, Loclist" },
                { "<leader>l", group = "LSP" },
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
        lazy = false,
        priority = 900,
        build = function()
            if vim.fn.executable('rg') == 0 then
                if vim.fn.executable('cargo') == 1 then
                    vim.fn.jobstart('cargo install ripgrep')
                end
            end
        end,
        opts = {
            bigfile = { enabled = true },
            explorer = {
                enabled = true,
                replace_netrw = true,
            },
            image = { enabled = true },
            indent = {
                enabled = true,
                animate = { enabled = false },
            },
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
            { "<c-t>",           function() Snacks.terminal() end,                                       desc = "Terminal" },
            -- Top Pickers & Explorer
            { "<leader><space>", function() Snacks.picker.smart({ filter = { cwd = true } }) end,        desc = "Smart Find Files" },
            { "<leader>,",       function() Snacks.picker.buffers() end,                                 desc = "List Buffers" },
            { "<leader>/",       function() Snacks.picker.grep() end,                                    desc = "Grep Files" },
            { "<leader>:",       function() Snacks.picker.command_history() end,                         desc = "Command History" },
            { "<leader>e",       function() Snacks.explorer() end,                                       desc = "File Explorer" },

            -- find
            { "<leader>fb",      function() Snacks.picker.buffers() end,                                 desc = "Buffers" },
            { "<leader>fc",      function() Snacks.picker.files({ cwd = vim.fn.stdpath("config") }) end, desc = "Find Config File" },
            { "<leader>ff",      function() Snacks.picker.files() end,                                   desc = "Find Files" },
            { "<leader>fg",      function() Snacks.picker.git_files() end,                               desc = "Find Git Files" },
            { "<leader>fp",      function() Snacks.picker.projects() end,                                desc = "Projects" },
            { "<leader>fr",      function() Snacks.picker.recent() end,                                  desc = "Recent" },
            -- git
            { "<leader>gb",      function() Snacks.picker.git_branches() end,                            desc = "Git Branches" },
            { "<leader>gl",      function() Snacks.picker.git_log() end,                                 desc = "Git Log" },
            { "<leader>gL",      function() Snacks.picker.git_log_line() end,                            desc = "Git Log Line" },
            { "<leader>gs",      function() Snacks.picker.git_status() end,                              desc = "Git Status" },
            { "<leader>gS",      function() Snacks.picker.git_stash() end,                               desc = "Git Stash" },
            { "<leader>gd",      function() Snacks.picker.git_diff() end,                                desc = "Git Diff (Hunks)" },
            { "<leader>gf",      function() Snacks.picker.git_log_file() end,                            desc = "Git Log File" },
            -- LSP
            { "<leader>ld",      function() Snacks.picker.lsp_definitions() end,                         desc = "LSP Definition" },
            { "<leader>lD",      function() Snacks.picker.lsp_declarations() end,                        desc = "LSP Declaration" },
            { "<leader>lr",      function() Snacks.picker.lsp_references() end,                          nowait = true,                     desc = "LSP References" },
            { "<leader>li",      function() Snacks.picker.lsp_implementations() end,                     desc = "LSP Implementation" },
            { "<leader>lt",      function() Snacks.picker.lsp_type_definitions() end,                    desc = "LSP Type Definition" },
            { "<leader>ls",      function() Snacks.picker.lsp_symbols() end,                             desc = "LSP Symbols" },
            { "<leader>lS",      function() Snacks.picker.lsp_workspace_symbols() end,                   desc = "LSP Workspace Symbols" },
            -- Other
            { "<leader>cR",      function() Snacks.rename.rename_file() end,                             desc = "Rename File" },
            { "<leader>n",       function() Snacks.notifier.show_history() end,                          desc = "Notification history" },
            { "<leader>un",      function() Snacks.notifier.hide() end,                                  desc = "Dismiss All Notifications" },
            { "]]",              function() Snacks.words.jump(vim.v.count1) end,                         desc = "Next Reference",           mode = { "n", "t" } },
            { "[[",              function() Snacks.words.jump(-vim.v.count1) end,                        desc = "Prev Reference",           mode = { "n", "t" } },
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
            { "<leader>xx", "<cmd>Trouble diagnostics toggle<cr>",              desc = "Diagnostics", },
            { "<leader>xX", "<cmd>Trouble diagnostics toggle filter.buf=0<cr>", desc = "Diagnostics/Buffer", },
            -- { "<leader>cs", "<cmd>Trouble symbols toggle focus=false<cr>",      desc = "List Symbols", },
            { "<leader>h",  "<cmd>Trouble lsp toggle<cr>",                      desc = "LSP References", },
            { "<leader>xl", "<cmd>Trouble loclist toggle<cr>",                  desc = "Location List", },
            { "<leader>xq", "<cmd>Trouble qflist toggle<cr>",                   desc = "Quickfix List", },
        },
    },
}
