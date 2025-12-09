return {
    { 'mechatroner/rainbow_csv', ft = "csv", },
    { 'mattn/vim-goimports',     ft = "go", },
    {
        '3rd/diagram.nvim',
        dependencies = {
            {
                "3rd/image.nvim",
                opts = {
                    scale_factor = 1.0,
                },
                integrations = { markdown = { only_render_image_at_cursor_mode = "inline" } },
            }
        },
        config = function()
            require("diagram").setup({
                integrations = {
                    require("diagram.integrations.markdown"),
                    require("diagram.integrations.neorg"),
                },
                events = {
                    clear_buffer = { "BufLeave" },
                },
                renderer_options = {
                    mermaid = {
                        background = "transparent",
                        theme = "dark",
                        scale = 4,
                    },
                    plantuml = {
                        charset = "utf-8",
                    },
                    d2 = {
                        theme_id = 1,
                    },
                    gnuplot = {
                        theme = "dark",
                        size = "800,600",
                    },
                },
            })
        end,
        ft = { "markdown", "norg" },
        keys = {
            {
                "K",
                function()
                    require("diagram").show_diagram_hover()
                end,
                mode = "n",
                ft = { "markdown", "norg" },
                desc = "Show diagram in new tab",
            },
        },

    }
}
