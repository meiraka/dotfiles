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
                    max_width_window_percentage = 50,
                    max_height_window_percentage = 50,
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
    }
}
