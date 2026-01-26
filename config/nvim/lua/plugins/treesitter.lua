local tt = "nvim-treesitter-textobjects"
return {
    {
        'nvim-treesitter/nvim-treesitter',
        branch = "main",
        -- FIXME: TSUpdate crashes vim
        -- build = ":TSUpdate",
        opts = {
            ensure_installed = {
                'bash', 'go',
                'css', 'html', 'latex',
                'json', 'yaml', 'promql',
                'regex',
                'markdown', 'markdown_inline',
            },
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
    {
        'nvim-treesitter/nvim-treesitter-textobjects',
        branch = "main",
        opts = {
            select = {
                lookahead = true,
                selection_modes = {
                    ['@parameter.outer'] = 'v', -- charwise
                    ['@function.outer'] = 'V',  -- linewise
                    ['@class.outer'] = '<c-v>', -- blockwise
                },
            },
        },
        keys = {
            {
                "af",
                function() require(tt .. ".select").select_textobject("@function.outer", "textobjects") end,
                mode = { "x", "o" },
                desc = "Function block",
            },
            {
                "if",
                function() require(tt .. ".select").select_textobject("@function.inner", "textobjects") end,
                mode = { "x", "o" },
                desc = "Function block",
            },
            {
                "ac",
                function() require(tt .. ".select").select_textobject("@class.outer", "textobjects") end,
                mode = { "x", "o" },
                desc = "Class block",
            },
            {
                "ic",
                function() require(tt .. ".select").select_textobject("@class.inner", "textobjects") end,
                mode = { "x", "o" },
                desc = "Class block",
            },
            {
                "as",
                function() require(tt .. ".select").select_textobject("@class.inner", "textobjects") end,
                mode = { "x", "o" },
                desc = "Scope block",
            },
            { "<leader>a", function() require(tt .. ".swap").swap_next "@parameter.inner" end, desc = "Swap inner" },
            { "<leader>A", function() require(tt .. ".swap").swap_next "@parameter.outer" end, desc = "Swap outer" },
            {
                "]f",
                function() require(tt .. ".move").goto_next_start("@function.outer", "textobjects") end,
                mode = { "n", "x", "o" },
                desc = "Next function start",
            },
            {
                "[f",
                function() require(tt .. ".move").goto_previous_start("@function.outer", "textobjects") end,
                mode = { "n", "x", "o" },
                desc = "Previous function start",
            },
            {
                "]F",
                function() require(tt .. ".move").goto_next_end("@function.outer", "textobjects") end,
                mode = { "n", "x", "o" },
                desc = "Next function end",
            },
            {
                "[F",
                function() require(tt .. ".move").goto_previous_end("@function.outer", "textobjects") end,
                mode = { "n", "x", "o" },
                desc = "Previous function end",
            },
            {
                "]s",
                function() require(tt .. ".move").goto_next_start("@local.scope", "locals") end,
                mode = { "n", "x", "o" },
                desc = "Next scope start",
            },
            {
                "[s",
                function() require(tt .. ".move").goto_previous_start("@local.scope", "locals") end,
                mode = { "n", "x", "o" },
                desc = "Previous scope start",
            },
            {
                "]c",
                function() require(tt .. ".move").goto_next_start("@class.outer", "textobjects") end,
                mode = { "n", "x", "o" },
                desc = "Next class start",
            },
            {
                "[c",
                function() require(tt .. ".move").goto_previous_start("@class.outer", "textobjects") end,
                mode = { "n", "x", "o" },
                desc = "Previous class start",
            },
            { ";", function() require('nvim-treesitter-textobjects.repeatable_move').repeat_last_move_next() end,     mode = { "n", "x", "o" } },
            { ",", function() require('nvim-treesitter-textobjects.repeatable_move').repeat_last_move_previous() end, mode = { "n", "x", "o" } },
            { "f", function() require('nvim-treesitter-textobjects.repeatable_move').builtin_f_expr() end,            mode = { "n", "x", "o" } },
            { "F", function() require('nvim-treesitter-textobjects.repeatable_move').builtin_F_expr() end,            mode = { "n", "x", "o" } },
            { "t", function() require('nvim-treesitter-textobjects.repeatable_move').builtin_t_expr() end,            mode = { "n", "x", "o" } },
            { "T", function() require('nvim-treesitter-textobjects.repeatable_move').builtin_T_expr() end,            mode = { "n", "x", "o" } },
        },
    },
    {
        'Wansmer/treesj',
        opts = {
            use_default_keymaps = false,
            max_join_length = 240,
        },
        keys = {
            { "<leader>j", function() require('treesj').join() end,  desc = "Join block of code" },
            { "<leader>s", function() require('treesj').split() end, desc = "Split block of code" },
        },
    },
}
