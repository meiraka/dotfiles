return {
    {
        "rebelot/kanagawa.nvim",
        config = function()
            vim.cmd('colorscheme kanagawa')
        end,
    },
    {
        'nvim-telescope/telescope.nvim',
        dependencies = {
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
        end,
        keys = {
            -- { '<leader>f', '<cmd>Telescope file_browser<cr>', desc = 'browse files' },
            -- { '<leader>g', '<cmd>Telescope live_grep<cr>',    desc = 'grep files' },
        },
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
            { '<c-t>', '<Cmd>exe v:count1 . "ToggleTerm"<CR>', desc = 'toggle terminal' },
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
