return {
    {
        "olimorris/codecompanion.nvim",
        opts = {
            opts = {
                language = "Japanese",
            },
            interactions = {
                chat = { adapter = "codex" },
                inline = { adapter = "" },
                cli = { adapter = "" },
            },
            adapters = {
                acp = {
                    opts = { show_presets = false },
                    codex = function()
                        return require("codecompanion.adapters").extend("codex", {
                            commands = { default = { "npx", "-y", "@agentclientprotocol/codex-acp" } },
                        })
                    end,
                    claude_code = function()
                        return require("codecompanion.adapters").extend("claude_code", {
                            commands = {
                                default = { "npx", "-y", "@agentclientprotocol/claude-agent-acp" },
                                yolo = { "npx", "-y", "@agentclientprotocol/claude-agent-acp", "--yolo" },
                            },
                        })
                    end,
                },
                http = { opts = { show_presets = false } },
            },
            display = {
                chat = {
                    window = {
                        layout = "float",
                        width = 0.8,
                        height = 0.8,
                        border = "rounded",
                    },
                },
            },
        },
        keys = {
            { "<leader>'", "<cmd>CodeCompanionChat Toggle<cr>", mode = { "n", "v" }, desc = "CodeCompanion Chat" },
            { "<C-a>",     "<cmd>CodeCompanionActions<cr>",     mode = { "n", "v" }, desc = "CodeCompanion Actions" },
        },
    },
}
