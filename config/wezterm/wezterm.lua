local wezterm = require("wezterm")
local act = wezterm.action
local mux = wezterm.mux
local color = require("color")
local powerline = require("powerline")
local config = wezterm.config_builder()

config:set_strict_mode(true)

config.font = wezterm.font("PlemolJP35 Console NF", { weight = "Medium", style = "Normal" })
config.font_rules = { { italic = true, font = config.font } }
config.font_size = 12
config.dpi = 192

config.text_background_opacity = 1
config.window_background_opacity = 0.95
config.macos_window_background_blur = 20
config.colors = wezterm.color.get_builtin_schemes()["Gruvbox Material (Gogh)"]
config.colors.tab_bar = {
    background = color.alpha(config.colors.background, config.window_background_opacity),
    inactive_tab_edge = color.pseudo_alpha(config.colors.foreground, config.colors.background, 0.3),
}

config.disable_default_key_bindings = true
config.leader = { key = 'f', mods = 'CTRL', timeout_milliseconds = 1000 }
config.keys = {
    { key = "L",     mods = "CTRL|SHIFT", action = act.ShowDebugOverlay },
    { key = "w",     mods = "SUPER",      action = act.CloseCurrentTab({ confirm = true }) },
    { key = "c",     mods = "SUPER",      action = act.CopyTo("ClipboardAndPrimarySelection") },
    { key = "v",     mods = "SUPER",      action = act.PasteFrom("Clipboard") },
    { key = "-",     mods = "SUPER",      action = act.DecreaseFontSize },
    { key = "+",     mods = "SUPER",      action = act.IncreaseFontSize },
    { key = "0",     mods = "SUPER",      action = act.ResetFontSize },
    { key = "h",     mods = "LEADER",     action = act.SplitHorizontal({}) },
    { key = "v",     mods = "LEADER",     action = act.SplitVertical({}) },
    { key = "Space", mods = "LEADER",     action = act.PaneSelect({}) },
    { key = "f",     mods = "LEADER",     action = act.ToggleFullScreen },
    { key = "t",     mods = "ALT",        action = act.EmitEvent("toggle-tabbar") },
}


config.window_decorations = "NONE"
config.window_padding = { left = '0.5cell', right = 0, top = '0.25cell', bottom = 0 }
config.enable_tab_bar = true
config.show_new_tab_button_in_tab_bar = false
config.show_tabs_in_tab_bar = false
config.use_fancy_tab_bar = false
config.inactive_pane_hsb = {
    saturation = 1.0,
    brightness = 1.0,
}
config.audible_bell = "Disabled"
config.use_ime = true

-- workspaces
local workspaces = 8
for i = 1, workspaces do
    table.insert(config.keys, {
        key = tostring(i),
        mods = 'ALT',
        action = act.SwitchToWorkspace({
            name = tostring(i),
        }),
    })
end

wezterm.on("gui-startup", function()
    -- setup and activate first workspace
    local _, _, window = mux.spawn_window({ workspace = "1" })
    mux.set_active_workspace("1")
    -- enables window decorations in mac
    if string.find(wezterm.target_triple, "apple%-darwin") then
        local overrides = window:gui_window():get_config_overrides() or {}
        overrides.window_decorations = "RESIZE"
        window:gui_window():set_config_overrides(overrides)
    end
end)

wezterm.on('update-status', function(window, pane)
    -- workspace indicator
    local wsExists = {}
    for _, l in ipairs(mux.get_workspace_names()) do wsExists[l] = true end
    local fmt = {}
    table.insert(fmt, { Background = { Color = config.colors.tab_bar.background } })
    for i = 1, workspaces do
        local ws = tostring(i)
        if ws == window:active_workspace() then
            -- active workspace
            table.insert(fmt, { Foreground = { Color = config.colors.foreground } })
            table.insert(fmt, { Text = " ●" })
        elseif wsExists[ws] then
            -- inactive workspaces
            table.insert(fmt, { Foreground = { Color = config.colors.tab_bar.inactive_tab_edge } })
            table.insert(fmt, { Text = " ●" })
        else
            -- empty workspaces
            table.insert(fmt, { Foreground = { Color = config.colors.tab_bar.inactive_tab_edge } })
            table.insert(fmt, { Text = " ○" })
        end
    end
    table.insert(fmt, { Text = " " })
    window:set_left_status(wezterm.format(fmt))

    local right = {}

    -- kube context from zshprompt
    local kube_color = config.colors.ansi[5]
    local context = pane:get_user_vars().KUBE_CONTEXT
    if context ~= nil and context ~= "" then
        powerline.right_hard(right, kube_color)
        table.insert(right, { Foreground = { Color = config.colors.background } })
        table.insert(right, { Text = '󱃾' .. ' ' })
        table.insert(right, { Text = context .. ' ' })
        local namespace = pane:get_user_vars().KUBE_NAMESPACE
        if namespace ~= nil and namespace ~= "" then
            powerline.right_soft(right, config.colors.background)
            table.insert(right, { Text = namespace .. ' ' })
        end
    end

    -- clock
    if window:get_dimensions().is_full_screen then
        powerline.right_hard(right, color.pseudo_alpha(config.colors.background, config.colors.foreground, 0.2))
        table.insert(right, { Foreground = { Color = config.colors.background } })
        table.insert(right, { Text = wezterm.strftime('%a %b %d %Y %H:%M:%S') .. ' ' })
    end
    window:set_right_status(wezterm.format(right))
end)

wezterm.on("toggle-tabbar", function(window, _)
    local overrides = window:get_config_overrides() or {}
    if not overrides.enable_tab_bar then
        overrides.enable_tab_bar = true
    else
        overrides.enable_tab_bar = false
    end
    window:set_config_overrides(overrides)
end)

return config
