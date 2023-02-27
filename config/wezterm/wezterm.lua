local wezterm = require("wezterm")
local act = wezterm.action
local mux = wezterm.mux

local leader = { key = 'f', mods = 'CTRL', timeout_milliseconds = 1000 }
local mykeys = {
    { key = "c", mods = "SUPER", action = act.CopyTo("ClipboardAndPrimarySelection") },
    { key = "v", mods = "SUPER", action = act.PasteFrom("Clipboard") },
    { key = "-", mods = "SUPER", action = act.DecreaseFontSize },
    { key = "+", mods = "SUPER", action = act.IncreaseFontSize },
    { key = "0", mods = "SUPER", action = act.ResetFontSize },
}

-- workspace indicator
local numWS = 8
for i = 1, numWS do
    table.insert(mykeys, {
        key = tostring(i),
        mods = 'ALT',
        action = act.SwitchToWorkspace({
            name = tostring(i),
        }),
    })
end

wezterm.on("gui-startup", function()
    mux.spawn_window({ workspace = "1" })
    mux.set_active_workspace("1")
end)

local alpha = function(fg, a)
    local fh, fs, fl, _ = wezterm.color.parse(fg):hsla()
    return wezterm.color.from_hsla(fh, fs, fl, a)
end
local pseudoAlpha = function(fg, bg, a)
    local fh, fs, fl, _ = wezterm.color.parse(fg):hsla()
    local bh, bs, bl, _ = wezterm.color.parse(bg):hsla()
    return wezterm.color.from_hsla(fh * a + bh * (1 - a), fs * a + bs * (1 - a), fl * a + bl * (1 - a), 1)
end

local colors = wezterm.color.get_builtin_schemes()["Gruvbox dark, medium (base16)"]
-- local inactive = pseudoAlpha(colors.foreground, colors.background, 0.3)
local notexists = pseudoAlpha(colors.foreground, colors.background, 0.2)
colors.tab_bar = { background = alpha(colors.background, 0.95) }
wezterm.on('update-status', function(window, _)
    -- local wsExists = {}
    -- for _, l in ipairs(mux.get_workspace_names()) do wsExists[l] = true end
    local fmt = {}
    table.insert(fmt, { Background = { Color = alpha(colors.background, 0.95) } })
    for i = 1, numWS do
        local ws = tostring(i)
        if ws == window:active_workspace() then
            table.insert(fmt, { Foreground = { Color = colors.foreground } })
            -- elseif wsExists[ws] then
            --     table.insert(fmt, { Foreground = { Color = inactive } })
        else
            table.insert(fmt, { Foreground = { Color = notexists } })
        end
        table.insert(fmt, { Text = " ●" })
    end
    table.insert(fmt, { Text = " " })

    window:set_left_status(wezterm.format(fmt))
end)


return {
    audible_bell = "Disabled",
    enable_tab_bar = true,
    -- color_scheme = "Gruvbox dark, medium (base16)",
    colors = colors,
    font = wezterm.font_with_fallback({
        "HackGen Console NFJ",
    }),
    font_size = 12.0,
    disable_default_key_bindings = true,
    leader = leader,
    keys = mykeys,
    show_new_tab_button_in_tab_bar = false,
    text_background_opacity = 0.95,
    tab_max_width = 0,
    use_fancy_tab_bar = false,
    window_background_opacity = 0.95,
    window_decorations = "NONE",
    window_padding = { left = '0.5cell', right = 0, top = '0.25cell', bottom = 0 },
    inactive_pane_hsb = {
        saturation = 1.0,
        brightness = 1.0,
    },
}
