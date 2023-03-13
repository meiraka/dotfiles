local wezterm = require("wezterm")
local act = wezterm.action
local mux = wezterm.mux
local color = require("color")
local powerline = require("powerline")

local myFont = wezterm.font_with_fallback({
    "HackGen Console NFJ",
    "Symbols Nerd Font Mono",
})
local myColors = wezterm.color.get_builtin_schemes()["Gruvbox dark, medium (base16)"]
local inactive = color.pseudo_alpha(myColors.foreground, myColors.background, 0.3)
myColors.tab_bar = {
    background = color.alpha(myColors.background, 0),
    inactive_tab_edge = inactive,
}
local myWorkspaces = 8
local myLeader = { key = 'f', mods = 'CTRL', timeout_milliseconds = 1000 }
local myKeys = {
    { key = "L", mods = "CTRL|SHIFT", action = act.ShowDebugOverlay },
    { key = "w", mods = "SUPER", action = act.CloseCurrentTab({ confirm = true }) },
    { key = "c", mods = "SUPER", action = act.CopyTo("ClipboardAndPrimarySelection") },
    { key = "v", mods = "SUPER", action = act.PasteFrom("Clipboard") },
    { key = "-", mods = "SUPER", action = act.DecreaseFontSize },
    { key = "+", mods = "SUPER", action = act.IncreaseFontSize },
    { key = "0", mods = "SUPER", action = act.ResetFontSize },
    { key = "h", mods = "LEADER", action = act.SplitHorizontal({}) },
    { key = "v", mods = "LEADER", action = act.SplitVertical({}) },
    { key = "Space", mods = "LEADER", action = act.PaneSelect({}) },
    { key = "f", mods = "LEADER", action = act.ToggleFullScreen },
    { key = "t", mods = "ALT", action = act.EmitEvent("toggle-tabbar") },
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
    local _, _, window = mux.spawn_window({ workspace = "1" })
    mux.set_active_workspace("1")
    -- enables tab_bar and fullscreen in mac
    if string.find(wezterm.target_triple, "apple%-darwin") then
        window:gui_window():toggle_fullscreen()
        local overrides = window:gui_window():get_config_overrides() or {}
        overrides.enable_tab_bar = true
        window:gui_window():set_config_overrides(overrides)
    end
end)

wezterm.on('update-status', function(window, pane)
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

    local right = {}

    -- vcs info from zshprompt
    local vcs = pane:get_user_vars().VCS
    if vcs ~= nil and vcs ~= "" then
        powerline.right_hard(right, color.pseudo_alpha(myColors.background, myColors.foreground, 0.9))
        local repo = pane:get_user_vars().VCS_REPO

        if string.find(repo, "github.com") then
            table.insert(right, { Foreground = { Color = "#FFFFF" } })
            table.insert(right, { Text = wezterm.nerdfonts.dev_github_badge .. ' ' })
        else
            table.insert(right, { Foreground = { Color = "#F1502F" } })
            table.insert(right, { Text = wezterm.nerdfonts.dev_git .. ' ' })
        end
        table.insert(right, { Foreground = { Color = myColors.foreground } })
        table.insert(right, { Text = repo .. ' ' })
        powerline.right_soft(right, myColors.background)

        local branch = pane:get_user_vars().VCS_BRANCH
        local default_branch = pane:get_user_vars().VCS_DEFAULT_BRANCH
        if branch == default_branch then -- main branch
            table.insert(right, { Foreground = { Color = myColors.ansi[4] } })
            table.insert(right, { Text = wezterm.nerdfonts.dev_git_merge .. ' ' })
        else
            table.insert(right, { Foreground = { Color = myColors.ansi[7] } })
            table.insert(right, { Text = wezterm.nerdfonts.dev_git_branch .. ' ' })
        end
        table.insert(right, { Foreground = { Color = myColors.foreground } })
        table.insert(right, { Text = branch .. ' ' })
    end

    -- kube context from zshprompt
    local context = pane:get_user_vars().KUBE_CONTEXT
    if context ~= nil and context ~= "" then
        powerline.right_hard(right, color.pseudo_alpha(myColors.background, myColors.foreground, 0.7))
        table.insert(right, { Foreground = { Color = myColors.ansi[5] } })
        table.insert(right, { Text = '󱃾' .. ' ' })
        table.insert(right, { Foreground = { Color = myColors.foreground } })
        table.insert(right, { Text = context .. ' ' })
        local namespace = pane:get_user_vars().KUBE_NAMESPACE
        if namespace ~= nil and namespace ~= "" then
            powerline.right_soft(right, myColors.background)
            table.insert(right, { Foreground = { Color = myColors.foreground } })
            table.insert(right, { Text = namespace .. ' ' })
        end
    end

    -- clock
    if window:get_dimensions().is_full_screen then
        powerline.right_hard(right, color.pseudo_alpha(myColors.background, myColors.foreground, 0.2))
        table.insert(right, { Foreground = { Color = myColors.background } })
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

return {
    audible_bell = "Disabled",
    enable_tab_bar = false,
    colors = myColors,
    font = myFont,
    font_size = 12.0,
    disable_default_key_bindings = true,
    leader = myLeader,
    keys = myKeys,
    show_new_tab_button_in_tab_bar = false,
    show_tabs_in_tab_bar = false,
    text_background_opacity = 1,
    use_fancy_tab_bar = false,
    use_ime = true,
    window_background_opacity = 1,
    window_decorations = "NONE",
    window_frame = {
        font = myFont,
        font_size = 12.0,
        active_titlebar_bg = myColors.background,
        inactive_titlebar_bg = myColors.background,
    },
    window_padding = { left = '0.5cell', right = 0, top = '0.25cell', bottom = 0 },
    inactive_pane_hsb = {
        saturation = 1.0,
        brightness = 1.0,
    },
}
