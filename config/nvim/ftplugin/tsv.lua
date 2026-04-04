vim.opt_local.tabstop = 8
vim.opt_local.wrap = false
vim.opt_local.expandtab = false
vim.opt_local.listchars = "tab:  │,trail:·,precedes:…,extends:…,nbsp:‗"
vim.opt_local.list = true

local buf = vim.api.nvim_get_current_buf()
local timeout = 0.01

local calculated = {}
local is_calculated = function(line)
    return calculated[line] == true
end

local calculate_tabstop_by_row = function(vts, row)
    for index, str in pairs(vim.split(vim.fn.getline(row), "\t")) do
        local current = vim.fn.strcharlen(str) + 1
        local old = vts[index] or 0
        if old < current then
            vts[index] = current
        end
    end
    return vts
end

local update_tabstop = function(startline, endline)
    local start = vim.fn.reltime()
    local vts = {}
    for i, v in ipairs(vim.opt_local.vts:get()) do
        vts[i] = tonumber(v)
    end
    local last = 0

    for i = startline, endline do
        vts = calculate_tabstop_by_row(vts, i)
        calculated[i] = true
        last = i
        if vim.fn.reltimefloat(vim.fn.reltime(start)) > timeout then
            break
        end
    end
    vim.opt_local.vts = vts
    return last, vim.fn.reltime(start)
end

local last = vim.fn.line('$')
local last_calculated, _ = update_tabstop(1, last)

-- vim.notify(last_calculated .. "/" .. last .. " lines calculated in" .. vim.fn.reltimestr(latency) .. " seconds", vim.log.levels.DEBUG)

if last ~= last_calculated then
    vim.api.nvim_create_autocmd({ "CursorMoved" }, {
        buffer = buf,
        callback = function()
            local top = vim.fn.line('w0')
            local bottom = vim.fn.line('w$')

            if is_calculated(top) and is_calculated(bottom) then
                return
            end
            update_tabstop(top, bottom)
        end,
    })
end

vim.api.nvim_create_autocmd({ "TextChangedI", "TextChanged" }, {
    buffer = buf,
    callback = function()
        local line = vim.api.nvim_win_get_cursor(0)[1]
        update_tabstop(line, line)
    end,
})
