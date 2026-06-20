for _, file in ipairs(vim.fn.readdir(vim.fs.joinpath(vim.fn.stdpath('config'), "lua", "plugins"))) do
    if string.sub(file, 1, 2) == "ai" and file ~= "ai-stub.lua" then
        return {}
    end
end
return {
    { "yetone/avante.nvim", lazy = true },
    {
        "olimorris/codecompanion.nvim",
        opts = {
            language = "Japanese",
            interactions = {
                -- chat = { adapter = "codex", model = "gpt-4.1" },
            },
            adapters = {
                acp = { opts = { show_presets = false } },
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
            { "<leader>c", "<cmd>CodeCompanionChat Toggle<cr>", desc = "Chat" }
        },
    },
}
