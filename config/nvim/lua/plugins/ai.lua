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
                            env = (function()
                                if jit.os == "OSX" then
                                    return { OPENAI_API_KEY = "cmd:security find-generic-password -s 'Codex Auth' -w | jq -r .OPENAI_API_KEY" }
                                end
                                return {}
                            end)()
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
            { "<leader>a", "<cmd>CodeCompanionChat Toggle<cr>", mode = { "n", "v" }, desc = "CodeCompanion Chat" },
            { "<c-a>",     "<cmd>CodeCompanionActions<cr>",     mode = { "n", "v" }, desc = "CodeCompanion Actions" },
            { "ga",        "<cmd>CodeCompanionChat Add<cr>",    mode = { "v" },      desc = "CodeCompanion Add" },
        },
    },
}
