return {
    {
        "monaqa/dial.nvim",
        keys = {
            { "<C-a>",  function() require("dial.map").manipulate("increment", "normal") end,  help = "increment" },
            { "<C-x>",  function() require("dial.map").manipulate("decrement", "normal") end,  help = "decrement" },
            { "g<C-a>", function() require("dial.map").manipulate("increment", "gnormal") end, help = "increment group" },
            { "g<C-x>", function() require("dial.map").manipulate("decrement", "gnormal") end, help = "decrement group" },
            { "<C-a>",  function() require("dial.map").manipulate("increment", "visual") end,  help = "increment",       mode = { "x" } },
            { "<C-x>",  function() require("dial.map").manipulate("decrement", "visual") end,  help = "decrement",       mode = { "x" } },
            { "g<C-a>", function() require("dial.map").manipulate("increment", "gvisual") end, help = "increment group", mode = { "x" } },
            { "g<C-x>", function() require("dial.map").manipulate("decrement", "gvisual") end, help = "decrement group", mode = { "x" } },
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
