local wezterm = require("wezterm")
return {
    right_hard = function(fmt, bg)
        table.insert(fmt, { Foreground = { Color = bg } })
        table.insert(fmt, { Text = wezterm.nerdfonts.pl_right_hard_divider })
        table.insert(fmt, { Background = { Color = bg } })
        table.insert(fmt, { Text = ' ' })
    end,
    right_soft = function(fmt, bg)
        table.insert(fmt, { Foreground = { Color = bg } })
        table.insert(fmt, { Text = wezterm.nerdfonts.pl_right_soft_divider })
        table.insert(fmt, { Text = ' ' })
    end
}
