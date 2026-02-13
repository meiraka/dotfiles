return {
    {
        "monaqa/dial.nvim",
        keys = {
            { "<C-a>",  function() require("dial.map").manipulate("increment", "normal") end,  desc = "increment" },
            { "<C-x>",  function() require("dial.map").manipulate("decrement", "normal") end,  desc = "decrement" },
            { "g<C-a>", function() require("dial.map").manipulate("increment", "gnormal") end, desc = "increment group" },
            { "g<C-x>", function() require("dial.map").manipulate("decrement", "gnormal") end, desc = "decrement group" },
            { "<C-a>",  function() require("dial.map").manipulate("increment", "visual") end,  desc = "increment",       mode = { "x" } },
            { "<C-x>",  function() require("dial.map").manipulate("decrement", "visual") end,  desc = "decrement",       mode = { "x" } },
            { "g<C-a>", function() require("dial.map").manipulate("increment", "gvisual") end, desc = "increment group", mode = { "x" } },
            { "g<C-x>", function() require("dial.map").manipulate("decrement", "gvisual") end, desc = "decrement group", mode = { "x" } },
        },
        config = function()
            local augend = require("dial.augend")
            require("dial.config").augends:register_group {
                default = {
                    augend.integer.alias.decimal,
                    augend.date.alias["%Y/%m/%d"],
                    augend.constant.alias.bool,
                    augend.constant.alias.Bool,
                    augend.semver.alias.semver,
                },
            }
        end
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
