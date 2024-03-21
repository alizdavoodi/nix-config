local wezterm = require("wezterm")
local config = wezterm.config_builder()
local padding = 0

-- Define configuration.
-- Body and display.
config.enable_tab_bar = false
config.line_height = 1.0
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
config.font_size = 12.5
-- config.freetype_load_target = "Normal"

-- Theme.
config.color_scheme = "ayu"
-- config.colors = {
-- 	background = "#0B1015",
-- 	foreground = "#FCFCFC",
-- 	selection_bg = "#202c3e",
-- 	selection_fg = "#fcfcfc",
-- 	cursor_bg = "#344866",
-- 	cursor_fg = "#fcfcfc",
-- }
-- Specific to macos
config.native_macos_fullscreen_mode = true

-- Keybinding.
-- config.keys = {
-- 	{ key = "PageUp", mods = "CTRL", action = wezterm.action.DisableDefaultAssignment },
-- 	{ key = "PageDown", mods = "CTRL", action = wezterm.action.DisableDefaultAssignment },
-- }

return config
