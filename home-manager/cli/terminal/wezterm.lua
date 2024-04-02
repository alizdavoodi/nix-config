local wezterm = require("wezterm")
local config = wezterm.config_builder()
local padding = 1

config.leader = { key = "a", mods = "CTRL", timeout_milliseconds = 1000 }
config.unix_domains = {
	{
		name = "unix",
	},
}

-- This causes `wezterm` to act as though it was started as
-- `wezterm connect unix` by default, connecting to the unix
-- domain on startup.
-- If you prefer to connect manually, leave out this line.
config.default_gui_startup_args = { "connect", "unix" }

-- Plugins
--
-- nvim plugin smart-splits
local smart_splits = wezterm.plugin.require("https://github.com/mrjones2014/smart-splits.nvim")
-- you can put the rest of your Wezterm config here
smart_splits.apply_to_config(config)

-- Load the smart workspace switcher plugin
local workspace_switcher = wezterm.plugin.require("https://github.com/MLFlexer/smart_workspace_switcher.wezterm")
workspace_switcher.set_zoxide_path(wezterm.home_dir .. "/.nix-profile/bin/zoxide")
--

config.default_prog = { "zsh" }
-- Define configuration.
-- Body and display.
config.window_padding = {
	top = padding,
	left = padding,
	right = padding,
	bottom = padding,
}
config.audible_bell = "Disabled"
config.default_cursor_style = "SteadyBar"
config.scrollback_lines = 50000

-- TabBar
config.tab_bar_at_bottom = true

-- Font.
config.font_size = 15
config.freetype_load_target = "Normal"
-- config.freetype_load_flags = "NO_HINTING"
config.line_height = 1.1
config.front_end = "OpenGL"

-- Theme.
config.color_scheme = "Dracula (Official)"

-- Specific to macos
config.native_macos_fullscreen_mode = true

-- Keybindings
config.keys = {
	{
		key = "9",
		mods = "ALT",
		action = workspace_switcher.switch_workspace(),
	},
	{ key = "q", mods = "LEADER|CTRL", action = wezterm.action.QuickSelect },
}

return config
