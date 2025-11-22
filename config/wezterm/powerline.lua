local wezterm = require("wezterm")
return {
    right_hard = function(fmt, bg)
        table.insert(fmt, { Foreground = { Color = bg } })
        table.insert(fmt, { Text = wezterm.nerdfonts.ple_left_half_circle_thick })
        table.insert(fmt, { Background = { Color = bg } })
        table.insert(fmt, { Text = ' ' })
    end,
    right_soft = function(fmt, bg)
        table.insert(fmt, { Foreground = { Color = bg } })
        table.insert(fmt, { Text = wezterm.nerdfonts.ple_left_half_circle_thin })
        table.insert(fmt, { Text = ' ' })
    end
}
