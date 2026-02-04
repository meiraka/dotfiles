return {
    {
        "machakann/vim-sandwich",
        keys = {
            { "sa" },
            { "sd" },
            { "sr" },
            { "ib", mode = { "x" } },
            { "ab", mode = { "x" } },
        },
    },
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
}
