local wezterm = require("wezterm")
local config = wezterm.config_builder()
local act = wezterm.action
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
config.window_decorations = "RESIZE"
config.audible_bell = "Disabled"
config.default_cursor_style = "SteadyBar"
config.scrollback_lines = 50000
config.max_fps = 120

-- TabBar
config.tab_bar_at_bottom = true

-- Font.
config.font = wezterm.font("JetBrains Mono")
-- config.font = wezterm.font_with_fallback({
-- 	"Fira Code",
-- 	"JetBrains Mono",
-- })
config.font_size = 16
config.freetype_load_target = "Normal"
config.line_height = 1.1
config.front_end = "WebGpu"

-- Theme.
config.color_scheme = "Rosé Pine (Gogh)"

-- config.colors = {
-- 	background = "black",
-- }
-- Specific to macos
config.native_macos_fullscreen_mode = true

-- Keybindings
config.keys = {
	{ key = "s", mods = "CTRL|SHIFT", action = workspace_switcher.switch_workspace() },
	{ key = "t", mods = "LEADER|SHIFT", action = wezterm.action.ShowLauncherArgs({ flags = "FUZZY|WORKSPACES" }) },
	{ key = "q", mods = "CTRL|SHIFT", action = wezterm.action.QuickSelect },

	{
		key = "U",
		mods = "LEADER",
		action = wezterm.action.QuickSelectArgs({
			label = "open url",
			patterns = {
				"https?://\\S+",
			},
			skip_action_on_paste = true,
			action = wezterm.action_callback(function(window, pane)
				local url = window:get_selection_text_for_pane(pane)
				wezterm.log_info("opening: " .. url)
				wezterm.open_with(url)
			end),
		}),
	},

	-- Make Option-Left equivalent to Alt-b which many line editors interpret as backward-word
	{ key = "LeftArrow", mods = "OPT", action = wezterm.action({ SendString = "\x1bb" }) },
	-- Make Option-Right equivalent to Alt-f; forward-word
	{ key = "RightArrow", mods = "OPT", action = wezterm.action({ SendString = "\x1bf" }) },

	-- Custom: switch tabs with CTRL+h / CTRL+l
	-- The first CTRL-h/CTRL-l entered after <leader> both
	--   1. activate a temporary key-table (`tab_nav`) that stays
	--      alive while you keep CTRL pressed (≈500 ms idle timeout)
	--   2. perform the tab move once.
	-- Subsequent CTRL-h/CTRL-l presses continue to run as long as
	-- CTRL is held.  Releasing CTRL (or waiting >500 ms) exits the
	-- key-table automatically, so the leader key is required again
	-- for the next navigation series.
	{
		key = "h",
		mods = "LEADER|CTRL",
		action = act.Multiple({
			act.ActivateKeyTable({
				name = "tab_nav",
				one_shot = false,
				until_unknown = true,
				timeout_milliseconds = 500,
			}),
			act.ActivateTabRelative(-1),
		}),
	},
	{
		key = "l",
		mods = "LEADER|CTRL",
		action = act.Multiple({
			act.ActivateKeyTable({
				name = "tab_nav",
				one_shot = false,
				until_unknown = true,
				timeout_milliseconds = 500,
			}),
			act.ActivateTabRelative(1),
		}),
	},
}

-- Define key table for repeated tab navigation
config.key_tables = {
	tab_nav = {
		{ key = "h", mods = "CTRL", action = act.ActivateTabRelative(-1) },
		{ key = "l", mods = "CTRL", action = act.ActivateTabRelative(1) },
		{ key = "Escape", action = "PopKeyTable" },
	},
}

-- nvim plugin smart-splits
local smart_splits = wezterm.plugin.require("https://github.com/mrjones2014/smart-splits.nvim")
-- you can put the rest of your Wezterm config here
smart_splits.apply_to_config(config, {
	-- the default config is here, if you'd like to use the default keys,
	-- you can omit this configuration table parameter and just use
	-- smart_splits.apply_to_config(config)

	-- directional keys to use in order of: left, down, up, right
	direction_keys = { "h", "j", "k", "l" },
	-- modifier keys to combine with direction_keys
	modifiers = {
		move = "LEADER", -- modifier to use for pane movement, e.g. CTRL+h to move left
		resize = "META", -- modifier to use for pane resize, e.g. META+h to resize to the left
	},
})

return config
