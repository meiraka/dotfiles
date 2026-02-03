vim.g.neotest_statusline = ""
return {
    {
        "andythigpen/nvim-coverage",
        dependencies = { 'nvim-lua/plenary.nvim' },
        lazy = true,
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
        opts = {
            consumers = {
                -- call CoverageLoad after test
                coverage = function(client)
                    client.listeners.results = function(_, _, partial)
                        if not partial then
                            require("coverage").load(true)
                        end
                    end
                    return {}
                end,
                -- lualine status line
                statusline = function(client)
                    local m = { lualine = "" }
                    local listener = function(adapter_id, _, _)
                        local config = require('neotest.config')
                        local status = { passed = 0, failed = 0, skipped = 0, running = 0 }
                        local tree = assert(client:get_position(nil, { adapter = adapter_id }))
                        local results = client:get_results(adapter_id)
                        for _, pos in tree:iter() do
                            if pos.type == "test" then
                                local result = results[pos.id]
                                if result and status[result.status] ~= nil then
                                    status[result.status] = status[result.status] + 1
                                elseif client:is_running(pos.id, { adapter = adapter_id }) then
                                    status.running = status.running + 1
                                end
                            end
                        end
                        local result = {}
                        for k, v in pairs(status) do
                            if status[k] > 0 then
                                table.insert(result, string.format('%%#%s#%s %d', config.highlights[k], config.icons[k], v))
                            end
                        end
                        m.lualine = table.concat(result, ' ')
                    end
                    client.listeners.run = listener
                    client.listeners.results = listener
                    return m
                end,
            },
            adapters_config = {
                ["neotest-golang"] = {
                    runner = "gotestsum",
                    go_test_args = {
                        "-v",
                        "-race",
                        "-count=1",
                        "-coverprofile=" .. vim.fn.getcwd() .. "/coverage.out",
                    },
                    warn_test_name_dupes = false,
                    sanitize_output = true,
                }
            },
            icons = {
                passed = "",
                running = "",
                failed = "",
                unknown = ""
            },
        },
        config = function(_, opts)
            opts.adapters = {}
            for k, v in pairs(opts.adapters_config) do
                table.insert(opts.adapters, require(k)(v))
            end
            -- update golang config on the fly
            opts.consumers.golang = function(_)
                return {
                    -- update build tag
                    tags = function(tags)
                        local new_args = {}
                        -- remove tags from go_test_args
                        local skip = false
                        for _, v in ipairs(opts.adapters_config["neotest-golang"].go_test_args) do
                            if v == "-tags" then
                                skip = true
                            elseif skip then
                                skip = false
                            else
                                table.insert(new_args, v)
                            end
                        end
                        -- add new tags
                        for _, v in ipairs(tags) do
                            table.insert(new_args, "-tags")
                            table.insert(new_args, v)
                        end
                        -- update config
                        opts.adapters_config["neotest-golang"].go_test_args = new_args
                        opts.adapters = {}
                        for k, v in pairs(opts.adapters_config) do
                            table.insert(opts.adapters, require(k)(v))
                        end
                        require("neotest").setup(opts)
                    end,
                }
            end
            require("neotest").setup(opts)
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
