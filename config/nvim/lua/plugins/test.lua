return {
    {
        "andythigpen/nvim-coverage",
        cmd = { "Coverage", "CoverageLoad", "CoverageSummary" },
        lazy = true,
        opts = {
            signs = {
                covered = { text = "░" },
                uncovered = { text = "░" },
            },
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
                lazy = true,
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
                        go_test_args = {
                            "-v",
                            "-race",
                            "-count=1",
                            "-coverprofile=" .. vim.fn.getcwd() .. "/coverage.out",
                        },
                        warn_test_name_dupes = false,
                        sanitize_output = true,
                    }),
                },
                icons = {
                    passed = "",
                    running = "",
                    failed = "",
                    unknown = ""
                },
            })
        end,
        keys = {
            {
                '<leader>tt',
                function()
                    local t = require("neotest")
                    t.output_panel.clear()
                    t.run.run()
                end,
                desc = 'Test nearest func'
            },
            {
                '<leader>tf',
                function()
                    local path = vim.fn.expand("%")
                    -- run xx_test.go from xx.go
                    if vim.bo.filetype == "go" and not string.match(path, "_test.go$") then
                        path = string.gsub(path, ".go$", "_test.go")
                    end
                    local t = require("neotest")
                    t.output_panel.clear()
                    t.run.run(path)
                end,
                desc = 'Test current file'
            },
            {
                '<leader>td',
                function()
                    local t = require("neotest")
                    t.output_panel.clear()
                    t.run.run(vim.fn.expand("%:p:h"))
                end,
                desc = 'Test current dir'
            },
            { '<leader>ts', function() require("neotest").summary.toggle() end,                 desc = 'Toggle test summary' },
            { '<leader>to', function() require("neotest").output_panel.toggle() end,            desc = 'Toggle test output' },
            { '[n',         function() require("neotest").jump.prev({ status = "failed" }) end, desc = 'Previous test failed' },
            { ']n',         function() require("neotest").jump.next({ status = "failed" }) end, desc = 'Next test failed' },
        },
    },
}
