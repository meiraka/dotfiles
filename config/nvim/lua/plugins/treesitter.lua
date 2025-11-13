return {
    {
        'nvim-treesitter/nvim-treesitter',
        version = '*',
        build = ":TSUpdate",
        config = function()
            require('nvim-treesitter.configs').setup({
                ensure_installed = { 'go', 'css', 'yaml', 'regex', 'bash', 'markdown', 'markdown_inline' },
                sync_install = false,
                highlight = {
                    enable = true,
                    disable = { 'lua', 'vim', 'javascript' },
                },
            })
        end
    },
}
