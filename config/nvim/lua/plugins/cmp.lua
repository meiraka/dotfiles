return {
    {
        'saghen/blink.cmp',
        cond = false,
        version = '1.*',
        dependencies = { 'rafamadriz/friendly-snippets' },
        opts = {
            keymap = { preset = 'enter' },
            completion = {
                documentation = { auto_show = true, },
                menu = {
                    draw = {
                        columns = { { 'kind_icon' }, { 'label', 'label_description', gap = 1 }, { 'kind' } },
                        components = {
                            kind = { highlight = function(_) return "Comment" end },
                        },
                    },
                },
            },
            cmdline = {
                keymap = {
                    preset = 'cmdline',
                    ['<Up>'] = { 'select_prev', 'fallback' },
                    ['<Down>'] = { 'select_next', 'fallback' },
                },
                completion = {
                    list = { selection = { preselect = false, auto_insert = true } },
                    menu = { auto_show = true },
                },
            },
        },
    },
    {
        'hrsh7th/nvim-cmp',
        dependencies = {
            'hrsh7th/cmp-buffer',
            'hrsh7th/cmp-cmdline',
            'hrsh7th/cmp-nvim-lsp',
            'hrsh7th/cmp-vsnip',
            'hrsh7th/vim-vsnip',
            'onsails/lspkind.nvim',
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
                    format = function(entry, item)
                        item = require("lspkind").cmp_format({ maxwidth = 50 })(entry, item)
                        item.kind_hl_group = "Comment"
                        item.menu_hl_group = "Comment"
                        return item
                    end,
                },
                snippet = { expand = function(args) vim.fn["vsnip#anonymous"](args.body) end },
                sources = {
                    { name = "nvim_lsp" },
                    { name = 'vsnip' },
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
                    { name = 'path' }
                }, {
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
