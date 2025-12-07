return {
    -- {
    --     'nvim-treesitter/nvim-treesitter',
    --     version = '*',
    --     build = ":TSUpdate",
    --     config = function()
    --         require('nvim-treesitter.configs').setup({
    --             ensure_installed = { 'go', 'css', 'yaml', 'regex', 'bash', 'markdown', 'markdown_inline' },
    --             sync_install = false,
    --             highlight = {
    --                 enable = true,
    --                 disable = { 'lua', 'vim', 'javascript' },
    --             },
    --         })
    --     end,
    -- },
    {
        'nvim-treesitter/nvim-treesitter',
        branch = "main",
        build = ":TSUpdate",
        opts = {
            ensure_installed = { 'go', 'css', 'yaml', 'regex', 'bash', 'markdown', 'markdown_inline' },
        },
        config = function(_, opts)
            require("nvim-treesitter").setup(opts)
            if vim.fn.executable('tree-sitter') == 1 then -- https://github.com/nvim-treesitter/nvim-treesitter/issues/8010
                require("nvim-treesitter").install(opts.ensure_installed)
            else
                vim.notify("nvim-treesitter: tree-sitter cli is not installed", vim.log.levels.WARN,
                    { title = "Setup plugins" })
            end
            vim.api.nvim_create_autocmd('FileType', {
                pattern = opts.ensure_installed,
                callback = function()
                    -- syntax highlighting, provided by Neovim
                    vim.treesitter.start()
                    -- folds, provided by Neovim
                    vim.wo.foldexpr = 'v:lua.vim.treesitter.foldexpr()'
                    vim.wo.foldmethod = 'expr'
                    -- indentation, provided by nvim-treesitter
                    vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
                end,
            })
        end,
    },
}
