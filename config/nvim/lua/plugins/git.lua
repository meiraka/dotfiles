return {
    { 'tpope/vim-fugitive', event = 'VeryLazy', },
    {
        'lewis6991/gitsigns.nvim',
        event = { 'BufReadPre', 'BufNewFile' },
        keys = {
            { "<leader>gh", function() require('gitsigns').stage_hunk() end,                                       mode = { "n" },           desc = "Git stage hunk" },
            { "<leader>gH", function() require('gitsigns').reset_hunk() end,                                       mode = { "n" },           desc = "Git reset hunk" },
            { "gh",         function() require('gitsigns').stage_hunk({ vim.fn.line('.'), vim.fn.line('v') }) end, mode = { "v" },           desc = "Git stage hunk" },
            { "gH",         function() require('gitsigns').reset_hunk({ vim.fn.line('.'), vim.fn.line('v') }) end, mode = { "v" },           desc = "Git reset hunk" },
            { "<leader>gp", function() require('gitsigns').preview_hunk() end,                                     desc = "Git preview hunk" },
            { "<leader>ga", function() require('gitsigns').stage_buffer() end,                                     desc = "Git stage buffer" },
            { "<leader>gr", function() require('gitsigns').reset_buffer() end,                                     desc = "Git reset buffer" },
            {
                "]g",
                function()
                    if vim.wo.diff then
                        vim.cmd.normal({ ']c', bang = true })
                    else
                        require("gitsigns").nav_hunk('next')
                    end
                end,
                desc = "Next git hunk",
            },
            {
                "[g",
                function()
                    if vim.wo.diff then
                        vim.cmd.normal({ '[c', bang = true })
                    else
                        require("gitsigns").nav_hunk('prev')
                    end
                end,
                desc = "Previous git hunk"
            },
        },
    },
}
