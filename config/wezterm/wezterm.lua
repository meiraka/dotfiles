local wezterm = require("wezterm")
local act = wezterm.action
local mux = wezterm.mux
local color = require("color")

local myColors = wezterm.color.get_builtin_schemes()["Gruvbox dark, medium (base16)"]
myColors.tab_bar = { background = color.alpha(myColors.background, 0) }
local myWorkspaces = 8

local myLeader = { key = 'f', mods = 'CTRL', timeout_milliseconds = 1000 }
local myKeys = {
    { key = "c", mods = "SUPER", action = act.CopyTo("ClipboardAndPrimarySelection") },
    { key = "v", mods = "SUPER", action = act.PasteFrom("Clipboard") },
    { key = "-", mods = "SUPER", action = act.DecreaseFontSize },
    { key = "+", mods = "SUPER", action = act.IncreaseFontSize },
    { key = "0", mods = "SUPER", action = act.ResetFontSize },
}
for i = 1, myWorkspaces do
    table.insert(myKeys, {
        key = tostring(i),
        mods = 'ALT',
        action = act.SwitchToWorkspace({
            name = tostring(i),
        }),
    })
end

wezterm.on("gui-startup", function()
    -- setup and activate first workspace
    mux.spawn_window({ workspace = "1" })
    mux.set_active_workspace("1")
end)

local inactive = color.pseudo_alpha(myColors.foreground, myColors.background, 0.3)
wezterm.on('update-status', function(window, _)
    -- workspace indicator
    local wsExists = {}
    for _, l in ipairs(mux.get_workspace_names()) do wsExists[l] = true end
    local fmt = {}
    table.insert(fmt, { Background = { Color = myColors.tab_bar.background } })
    for i = 1, myWorkspaces do
        local ws = tostring(i)
        if ws == window:active_workspace() then
            -- active workspace
            table.insert(fmt, { Foreground = { Color = myColors.foreground } })
            table.insert(fmt, { Text = " ●" })
        elseif wsExists[ws] then
            -- inactive workspaces
            table.insert(fmt, { Foreground = { Color = inactive } })
            table.insert(fmt, { Text = " ●" })
        else
            -- empty workspaces
            table.insert(fmt, { Foreground = { Color = inactive } })
            table.insert(fmt, { Text = " ○" })
        end
    end
    table.insert(fmt, { Text = " " })

    window:set_left_status(wezterm.format(fmt))
end)

return {
    audible_bell = "Disabled",
    enable_tab_bar = true,
    -- color_scheme = "Gruvbox dark, medium (base16)",
    colors = myColors,
    font = wezterm.font_with_fallback({
        "HackGen Console NFJ",
    }),
    font_size = 12.0,
    disable_default_key_bindings = true,
    leader = myLeader,
    keys = myKeys,
    show_new_tab_button_in_tab_bar = false,
    text_background_opacity = 1,
    tab_max_width = 0, -- disable tab
    use_fancy_tab_bar = false,
    window_background_opacity = 1,
    window_decorations = "NONE",
    window_padding = { left = '0.5cell', right = 0, top = '0.25cell', bottom = 0 },
    inactive_pane_hsb = {
        saturation = 1.0,
        brightness = 1.0,
    },
}
