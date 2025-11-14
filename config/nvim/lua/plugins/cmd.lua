return {
    { 'junegunn/fzf',      build = ':call fzf#install()' },
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
