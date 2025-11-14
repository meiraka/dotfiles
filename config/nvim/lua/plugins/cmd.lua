return {
    { 'junegunn/fzf',      build = ':call fzf#install()' },
    {
        'ibhagwan/fzf-lua',
        dependencies = { "nvim-tree/nvim-web-devicons" },
        opts = {},
        keys = {
            { '<leader>f', '<cmd>FzfLua files<cr>',     desc = 'open file' },
            { '<leader>g', '<cmd>FzfLua live_grep<cr>', desc = 'grep' },
        },
    },
    { 'tpope/vim-fugitive' },
    {
        'klen/nvim-test',
        opts = {
            term = 'toggleterm',
        },
        keys = {
            { '<leader>t', '<cmd>TestNearest<cr>', desc = 'run test' },
        },
    },
}
