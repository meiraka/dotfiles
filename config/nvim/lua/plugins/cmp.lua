return {
    {
        'saghen/blink.cmp',
        version = '1.*',
        dependencies = {
            { 'saghen/blink.compat',         version = '2.*', lazy = true, opts = {} },
            { 'dmitmel/cmp-cmdline-history' },
            { 'rafamadriz/friendly-snippets' },
        },
        opts = {
            fuzzy = { sorts = { 'exact', 'score', 'sort_text' } },
            sources = {
                providers = {
                    cmdline_history = {
                        name = 'cmdline_history',
                        module = 'blink.compat.source',
                        score_offset = 1,
                    },
                },
            },
            keymap = { preset = 'enter' },
            completion = {
                documentation = { auto_show = true, },
                menu = {
                    draw = {
                        columns = { { 'kind_icon' }, { 'label', 'label_description', gap = 1 }, { 'kind' } },
                        components = {
                            kind_icon = {
                                text = function(ctx) return select(1, require('mini.icons').get('lsp', ctx.kind)) .. " " end,
                                highlight = function(ctx) return select(2, require('mini.icons').get('lsp', ctx.kind)) end,
                            },
                            kind = { highlight = "Comment" },
                        },
                    },
                    cmdline_position = function()
                        if vim.g.ui_cmdline_pos ~= nil then
                            local pos = vim.g.ui_cmdline_pos -- (1, 0)-indexed
                            return { pos[1], pos[2] }        -- offset border
                        end
                        local height = (vim.o.cmdheight == 0) and 1 or vim.o.cmdheight
                        return { vim.o.lines - height, 0 }
                    end,
                },
            },
            cmdline = {
                sources = { 'buffer', 'cmdline', 'cmdline_history' },
                completion = {
                    list = { selection = { preselect = false, auto_insert = true } },
                    menu = { auto_show = true },
                },
            },
        },
    },
    {
        'hrsh7th/nvim-cmp',
        cond = false,
        dependencies = {
            'hrsh7th/cmp-buffer',
            'hrsh7th/cmp-cmdline',
            'hrsh7th/cmp-nvim-lsp',
            'hrsh7th/cmp-vsnip',
            'hrsh7th/vim-vsnip',
        },
        config = function()
            vim.lsp.config("*", { capabilities = require('cmp_nvim_lsp').default_capabilities() })
            local cmp = require("cmp");
            cmp.setup({
                performance = {
                    debounce = 0,
                    throttle = 0,
                },
                window = {
                    completion = {
                        winhighlight = "Normal:Pmenu,FloatBorder:Pmenu,Search:None",
                        col_offset = -3,
                        side_padding = 0,
                        scrollbar = false,
                    },
                    documentation = {
                        border = "solid",
                    },
                },
                formatting = {
                    fields = { "icon", "abbr", "kind", "menu" },
                    format = function(_, item)
                        item.icon, item.icon_hl_group = require("mini.icons").get("lsp", item.kind)
                        item.kind_hl_group = "Comment"
                        item.menu_hl_group = "Comment"
                        return item
                    end,
                },
                snippet = { expand = function(args) vim.fn["vsnip#anonymous"](args.body) end },
                sources = {
                    { name = "nvim_lsp" },
                    { name = 'vsnip' },
                    { name = 'buffer' },
                },
                mapping = cmp.mapping.preset.insert({
                    ["<C-p>"] = cmp.mapping.select_prev_item(),
                    ["<C-n>"] = cmp.mapping.select_next_item(),
                    ['<C-l>'] = cmp.mapping.complete(),
                    ['<C-e>'] = cmp.mapping.abort(),
                    ["<CR>"] = cmp.mapping.confirm { select = true },
                }),
            })
            cmp.setup.cmdline('/', {
                mapping = cmp.mapping.preset.cmdline(),
                sources = {
                    { name = 'buffer' }
                }
            })
            cmp.setup.cmdline(':', {
                mapping = cmp.mapping.preset.cmdline(),
                sources = cmp.config.sources({
                    { name = 'path' },
                    {
                        name = 'cmdline',
                        option = {
                            ignore_cmds = { 'Man', '!' }
                        }
                    }
                })
            })
        end
    },
}
