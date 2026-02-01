return {
    {
        "andythigpen/nvim-coverage",
        dependencies = { 'nvim-lua/plenary.nvim' },
        event = 'VeryLazy',
        opts = {
            auto_reload = false, -- update from neotest consumer
            signs = {
                covered = { text = " " },
                uncovered = { text = "█" },
            },
        },
        keys = {
            { '<leader>tc', "<cmd>CoverageToggle<cr>", desc = 'Toggle Test Coverage' },
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
                consumers = {
                    -- call CoverageLoad after test
                    coverage = function(client)
                        client.listeners.results = function(_, _, partial)
                            if not partial then
                                require("coverage").load(true)
                            end
                        end
                    end,
                    -- set g:neotest_statusline
                    statusline = function(client)
                        client.listeners.results = function(adapter_id, _, _)
                            local status = require("neotest").state.status_counts(adapter_id)
                            local icons = {
                                passed = "",
                                failed = "",
                                skipped = "",
                                running = "",
                            }
                            local result = {}
                            for k, v in pairs(icons) do
                                if status[k] > 0 then
                                    table.insert(result, string.format('%%#%s#%s %d', "Neotest" .. k, v, status[k]))
                                end
                            end
                            vim.g.neotest_statusline = table.concat(result, ' ')
                        end
                    end
                },
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
