return {
    {
        'sainnhe/gruvbox-material',
        lazy = false,
        priority = 1000,
        config = function()
            -- Optionally configure and load the colorscheme
            -- directly inside the plugin declaration.
            vim.g.gruvbox_material_sign_column_background = 'linenr'
            vim.g.gruvbox_material_dim_inactive_windows = true
            vim.g.gruvbox_material_background = 'hard'
            vim.cmd.colorscheme('gruvbox-material')
        end,
    },
    {
        "echasnovski/mini.icons",
        opts = {},
        lazy = true,
        specs = {
            { "nvim-tree/nvim-web-devicons", enabled = false, optional = true },
        },
        init = function()
            package.preload["nvim-web-devicons"] = function()
                require("mini.icons").mock_nvim_web_devicons()
                return package.loaded["nvim-web-devicons"]
            end
        end,
    },
    {
        'nvim-lualine/lualine.nvim',
        dependencies = { 'nvim-tree/nvim-web-devicons' },
        opts = {
            options = {
                globalstatus = true,
                theme = 'gruvbox-material',
                section_separators = { left = '', right = '' },
                component_separators = { left = '', right = '' },
            },
            sections = {
                lualine_a = { 'mode' },
                lualine_b = {
                    { 'filetype', icon_only = true, padding = { left = 1 }, separator = '' },
                    { 'filename', symbols = { modified = '', readonly = '' }, padding = { right = 1 }, separator = '' },
                },
                lualine_c = {
                    {
                        'diff',
                        symbols = { added = ' ', modified = ' ', removed = ' ' },
                        source = function()
                            local gitsigns = vim.b.gitsigns_status_dict
                            if gitsigns then
                                return {
                                    added = gitsigns.added,
                                    modified = gitsigns.changed,
                                    removed = gitsigns.removed
                                }
                            end
                        end
                    },
                    { 'diagnostics' },
                },
                lualine_x = {
                    {
                        function() return require("noice").api.status.search.get_hl() end,
                        cond = function() return require("noice").api.status.search.has() end,
                    },
                },
                lualine_y = { 'b:gitsigns_status_dict.root', function()
                    local root = vim.b.gitsigns_status_dict.root
                    if root == "" then
                        return ""
                    end
                    local cwd = vim.fn.getcwd()
                    if root == cwd then
                        return ""
                    end
                    return string.sub(cwd, string.len(root) + 2, -1)
                end
                },
                lualine_z = { { 'b:gitsigns_status_dict.head' } },
            },
        },
    },
    {
        'b0o/incline.nvim',
        opts = {
            window = {
                placement = { vertical = "bottom" },
                overlap = { borders = true },
                padding = 0,
                margin = { horizontal = 0 },
            },
            render = function(props)
                local filename = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(props.buf), ':t')
                if filename == '' then
                    filename = '[No Name]'
                end

                local ft_icon, ft_color = require('nvim-web-devicons').get_icon_color(filename)
                return {
                    ft_icon and
                    { ' ', ft_icon, ' ', guibg = ft_color, guifg = require('incline.helpers').contrast_color(ft_color) } or
                    '',
                    ' ',
                    { filename },
                    ' ',
                }
            end,
        },
        event = 'VeryLazy',
    },
    {
        "folke/which-key.nvim",
        event = "VeryLazy",
        opts = {
            win = {
                no_overlap = true,
                width = 0.2,
                height = -6,
                col = -2,
                border = "rounded",
            },
            spec = {
                { "<leader>g", group = "Git" },
                { "<leader>f", group = "Find" },
                { "<leader>x", group = "List" },
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
            styles = {
                snacks_image = {
                    relative = "editor",
                    col = -1,
                },
            },
            bigfile = { enabled = true },
            explorer = {
                enabled = true,
                replace_netrw = true,
            },
            image = {
                enabled = true,
                doc = {
                    enabled = true,
                    inline = false,
                    float = true,
                },
            },
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
                win = {
                    position = 'float',
                    border = 'rounded',
                },
                start_insert = false,
                auto_insert = false,
            },
            words = { enabled = true },
        },
        keys = {
            { "<M-Space>",       function() Snacks.terminal() end,                                       desc = "Terminal",                 mode = { "n", "t" } },
            { "<M-Esc>",         "<C-\\><C-n>",                                                          desc = "Normal mode",              mode = { "t" } },
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
        "folke/noice.nvim",
        event = "VeryLazy",
        opts = {
            lsp = {
                override = {
                    ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
                    ["vim.lsp.util.stylize_markdown"] = true,
                    ["cmp.entry.get_documentation"] = true, -- requires hrsh7th/nvim-cmp
                },
            },

            routes = {
                { view = "popup", filter = { event = "msg_show", cmdline = "Git status.*" }, },
                { view = "popup", filter = { event = "msg_show", cmdline = "G status.*" }, },
                { view = "mini",  filter = { event = "msg_show", cmdline = "Git .*" }, },
                { view = "mini",  filter = { event = "msg_show", cmdline = "G .*" }, },
                { view = "mini",  filter = { event = "msg_show", cmdline = ".*fugitive#.*" }, },
                { view = "popup", filter = { event = "msg_show", min_height = 2 }, },
            },
            -- format = { notify = { "{level} ", "{event}", "{kind}", "{cmdline} ", "{title} ", "{message}", } },
        },
        dependencies = {
            "MunifTanjim/nui.nvim",
        },
    },
    {
        'folke/trouble.nvim',
        dependencies = { "nvim-tree/nvim-web-devicons" },
        opts = {
            auto_close = true,
            modes = {
                diagnostics = {
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
            { "<leader>xl", "<cmd>Trouble loclist toggle<cr>",                  desc = "Location List", },
            { "<leader>xq", "<cmd>Trouble qflist toggle<cr>",                   desc = "Quickfix List", },
        },
    },
    {
        "rachartier/tiny-inline-diagnostic.nvim",
        event = "VeryLazy",
        priority = 1000,
        opts = {
            preset = "classic",
            transparent_bg = true,
            options = {
                use_icons_from_diagnostic = true,
                show_source = { enabled = true },
                multilines = {
                    enabled = true,
                    always_show = true,
                },
            },
        },
        config = function(_, opts)
            require("tiny-inline-diagnostic").setup(opts)
            vim.diagnostic.config({ virtual_text = false }) -- Disable Neovim's default virtual text diagnostics
        end,
    },
    {
        "folke/todo-comments.nvim",
        dependencies = { "nvim-lua/plenary.nvim", },
        opts = {},
        keys = {
            { "<leader>xt", "<cmd>Trouble todo toggle<cr>", desc = "TODO", },
        },
    },
}
