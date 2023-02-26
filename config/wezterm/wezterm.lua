local wezterm = require("wezterm")
local act = wezterm.action

return {
    audible_bell = "Disabled",
    enable_tab_bar = false,
    color_scheme = "Gruvbox dark, medium (base16)",
    font = wezterm.font_with_fallback({
        "HackGen Console NFJ",
    }),
    font_size = 11.0,
    disable_default_key_bindings = true,
    keys = {
        { key = "c", mods = "SUPER", action = act.CopyTo("ClipboardAndPrimarySelection") },
        { key = "v", mods = "SUPER", action = act.PasteFrom("Clipboard") },
    },
    text_background_opacity = 0.95,
    use_fancy_tab_bar = false,
    window_background_opacity = 0.95,
    window_decorations = "NONE",
    window_padding = { left = '0.5cell', right = 0, top = '0.25cell', bottom = 0 },
}
