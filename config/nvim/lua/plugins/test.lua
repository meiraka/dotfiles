return {
    {
        'klen/nvim-test',
        dependencies = {
            {
                'akinsho/toggleterm.nvim',
                version = '*',
                opts = {
                    insert_mappings = true,
                    terminal_mappings = true,
                },
            },
        },
        opts = {
            term = 'toggleterm',
        },
        keys = {
            { '<leader>t', '<cmd>TestNearest<cr>', desc = 'run test' },
        },
    },
}
