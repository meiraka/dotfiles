vim.opt.tabstop = 8
vim.opt.wrap = false
vim.opt.expandtab = false
vim.opt.listchars = "tab:--|,trail:·,precedes:…,extends:…,nbsp:‗"
vim.opt.list = true

local updateVTS = function(vts, istr)
    for index, str in pairs(vim.split(istr, "\t")) do
        local current = vim.fn.strcharlen(str) + 1
        local old = vts[index] or 0
        if old < current then
            vts[index] = current
        end
        index = index + 1
    end
    return vts
end

SetVTS = function()
    local t = 30
    local maxline = t
    local tbl = {}
    local i = 1
    while i < maxline do
        tbl = updateVTS(tbl, vim.fn.getline(i))
        i = i + 1
    end
    local arg = ""
    for k, v in ipairs(tbl) do
        if k ~= 1 then
            arg = arg .. ","
        end
        arg = arg .. v
    end
    vim.opt.vts = arg
end

SetVTS()
