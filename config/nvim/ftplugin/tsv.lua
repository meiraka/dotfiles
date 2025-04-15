vim.opt.tabstop = 8
vim.opt.wrap = false
vim.opt.expandtab = false
vim.opt.listchars = "tab:--|,trail:·,precedes:…,extends:…,nbsp:‗"
vim.opt.list = true

local calcVTS = function(vts, row)
    for index, str in pairs(vim.split(vim.fn.getline(row), "\t")) do
        local current = vim.fn.strcharlen(str) + 1
        local old = vts[index] or 0
        if old < current then
            vts[index] = current
        end
    end
    return vts
end


SetVTS = function(s, e)
    local vts = {}
    for i, v in ipairs(vim.opt_local.vts:get()) do
        vts[i] = tonumber(v)
    end
    for i = s, e do
        vts = calcVTS(vts, i)
    end
    vim.opt_local.vts = vts
end

SetVTS(1, 81)

local tsvUpdateEvents = {
    callback = function()
        local line = vim.api.nvim_win_get_cursor(0)[1]
        SetVTS(line, line + 1)
    end
}
vim.api.nvim_create_autocmd("TextChangedI", tsvUpdateEvents)
vim.api.nvim_create_autocmd("TextChanged", tsvUpdateEvents)
