return {
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
                dependencies = {
                    "uga-rosa/utf8.nvim",
                },
            },
        },
        config = function()
            require("neotest").setup({
                adapters = {
                    require("neotest-golang")({
                        runner = "gotestsum",
                        warn_test_name_dupes = false,
                        sanitize_output = true,
                    }),
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
