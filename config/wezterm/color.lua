local wezterm = require("wezterm")
return {
    alpha = function(fg, a)
        local fh, fs, fl, _ = wezterm.color.parse(fg):hsla()
        return wezterm.color.from_hsla(fh, fs, fl, a)
    end,

    pseudo_alpha = function(fg, bg, a)
        local fh, fs, fl, _ = wezterm.color.parse(fg):hsla()
        local bh, bs, bl, _ = wezterm.color.parse(bg):hsla()
        return wezterm.color.from_hsla(fh * a + bh * (1 - a), fs * a + bs * (1 - a), fl * a + bl * (1 - a), 1)
    end,
}
