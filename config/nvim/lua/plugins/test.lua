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
            -- { '<leader>t', '<cmd>TestNearest<cr>', desc = 'Run Test' },
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
                version = "*",
                build = function()
                    vim.system({ "go", "install", "gotest.tools/gotestsum@latest" }):wait()
                end,
            },
        },
        config = function()
            local config = { runner = "gotestsum" }
            require("neotest").setup({
                adapters = {
                    require("neotest-golang")(config),
                },
            })
        end,
        keys = {
            { '<leader>tt', function() require("neotest").run.run() end,                        desc = 'Test nearest func' },
            { '<leader>tc', function() require("neotest").run.run(vim.fn.expand("%")) end,      desc = 'Test current file' },
            { '<leader>ts', function() require("neotest").summary.toggle() end,                 desc = 'Toggle test summary' },
            { '<leader>to', function() require("neotest").output_panel.toggle() end,            desc = 'Toggle test output' },
            { '[n',         function() require("neotest").jump.prev({ status = "failed" }) end, desc = 'Prev test failed' },
            { ']n',         function() require("neotest").jump.next({ status = "failed" }) end, desc = 'Next test failed' },
        },
    },
}
