return {
    {
        'klen/nvim-test',
        dependencies = {
            {
                'akinsho/toggleterm.nvim',
                version = '*',
                opts = {
                    insert_mappings = true,
                    terminal_mappings = true,
                },
            },
        },
        opts = {
            term = 'toggleterm',
        },
        keys = {
            { '<leader>t', '<cmd>TestNearest<cr>', desc = 'Run Test' },
        },
    },
    {
        "nvim-neotest/neotest",
        dependencies = {
            "nvim-neotest/nvim-nio",
            "nvim-lua/plenary.nvim",
            "antoinemadec/FixCursorHold.nvim",
            {
                "fredrikaverpil/neotest-golang",
                version = "*",                                                              -- Optional, but recommended; track releases
                build = function()
                    vim.system({ "go", "install", "gotest.tools/gotestsum@latest" }):wait() -- Optional, but recommended
                end,
            },
        },
        config = function()
            local config = {
                -- runner = "gotestsum", -- Optional, but recommended
            }
            require("neotest").setup({
                adapters = {
                    require("neotest-golang")(config),
                },
            })
        end,
    },
}
