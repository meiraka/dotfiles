return {
    { 'junegunn/fzf',           build = ':call fzf#install()' },
    { 'junegunn/fzf.vim' },
    { 'tpope/vim-fugitive' },
    {
        'klen/nvim-test',
        config = function()
            require('nvim-test').setup({
                term = 'toggleterm',
            })
        end
    },
}
