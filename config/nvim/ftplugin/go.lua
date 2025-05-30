local arrayEq = function(a, b)
    if #a ~= #b then
        return false
    end
    for i = 1, #a do
        if a[i] ~= b[i] then
            return false
        end
    end
    return true
end

-- set gopls and nvim-test go build tags.
local tags = {}
local go_tags = function(p)
    if arrayEq(p.fargs, tags) then
        return
    end
    for k, _ in pairs(tags) do tags[k] = nil end
    local flags = {}
    local args = { 'test', '-v' }

    local t = p.fargs
    for i = 1, #t do
        table.insert(tags, t[i])
        table.insert(flags, '-tags=' .. t[i])
        table.insert(args, '-tags=' .. t[i])
    end

    vim.lsp.config('gopls', {
        capabilities = require('cmp_nvim_lsp').default_capabilities(),
        settings = {
            gopls = { buildFlags = flags },
        },
    })
    -- restart gopls
    for _, v in ipairs(vim.lsp.get_clients({ name = 'gopls' })) do
        v.stop()
    end
    vim.defer_fn(function() vim.cmd("e") end, 100)
    require('nvim-test.runners.go-test'):setup {
        args = args
    }
end

vim.api.nvim_create_user_command('GoTags', go_tags, { nargs = '*' })
