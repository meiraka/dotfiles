for _, file in ipairs(vim.fn.readdir(vim.fs.joinpath(vim.fn.stdpath('config'), "lua", "plugins"))) do
    if string.sub(file, 1, 2) == "ai" and file ~= "ai-stub.lua" then
        return {}
    end
end
return {
    { "yetone/avante.nvim",           lazy = true },
    { "olimorris/codecompanion.nvim", lazy = true },
}
