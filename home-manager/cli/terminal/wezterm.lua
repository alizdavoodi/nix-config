local wezterm = require("wezterm")
local config = wezterm.config_builder()
local padding = 3

-- Define configuration.
-- Body and display.
config.enable_tab_bar = false
config.window_padding = {
	top = padding,
	left = padding,
	right = padding,
	bottom = padding,
}
config.audible_bell = "Disabled"
config.default_cursor_style = "SteadyBar"

-- Font.
config.font = wezterm.font("JetBrainsMono Nerd Font")
config.font_size = 14.5
config.freetype_load_target = "Normal"
-- config.freetype_load_flags = "NO_HINTING"
-- config.front_end = "OpenGL"

-- Theme.
config.color_scheme = "Builtin Pastel Dark"
config.colors = {
	background = "#000000",
	foreground = "#ffffff",
	selection_bg = "#333333",
	selection_fg = "#ffffff",
	cursor_bg = "#ffffff",
	cursor_border = "#ffffff",
	cursor_fg = "#000000",
}
-- Specific to macos
config.native_macos_fullscreen_mode = true

-- Keybinding.
-- config.keys = {
-- 	{ key = "PageUp", mods = "CTRL", action = wezterm.action.DisableDefaultAssignment },
-- 	{ key = "PageDown", mods = "CTRL", action = wezterm.action.DisableDefaultAssignment },
-- }

return config
