return {
    {
        'saghen/blink.cmp',
        version = '1.*',
        dependencies = { 'rafamadriz/friendly-snippets' },
        opts = {
            keymap = { preset = 'enter' },
            completion = { documentation = { auto_show = true, } },
            cmdline = {
                keymap = {
                    preset = 'cmdline',
                    ['<Up>'] = { 'select_prev', 'fallback' },
                    ['<Down>'] = { 'select_next', 'fallback' },
                },
                completion = { list = { selection = { preselect = false, auto_insert = true } } },
            },
        },
    },
}
