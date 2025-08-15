-- .wezterm.lua
local wezterm = require("wezterm")
local mux = wezterm.mux
local act = wezterm.action

-- Build the config
local config = wezterm.config_builder()

-- Run bash by default
local operating_system = wezterm.target_triple
if operating_system:find("windows") then
	config.default_prog = { "C:/Program Files/Git/bin/bash.exe" }
end

-- Default working directory
config.default_cwd = wezterm.home_dir

-- Disable audio bell
config.audible_bell = "Disabled"

-- Cursor style
config.default_cursor_style = "SteadyBar"

-- Font
config.font = wezterm.font("JetBrainsMonoNL NF Medium")
config.font_size = 14

-- Color scheme
config.color_scheme = "Catppuccin Mocha"

-- Some specific colors
MOCHA_BLUE = "#89b4fa"
MOCHA_SURFACE0 = "#313244"
MOCHA_SURFACE1 = "#45475a"
MOCHA_MANTLE = "#181825"
MOCHA_CRUST = "#11111b"
MOCHA_TEXT = "#cdd6f4"
MOCHA_MAUVE = "#cba6f7"
MOCHA_PEACH = "#fab387"
MOCHA_GREEN = "#a6e3a1"

-- Tabs
config.enable_tab_bar = true
config.use_fancy_tab_bar = false
config.show_new_tab_button_in_tab_bar = false

-- Window Decorations
config.window_decorations = "INTEGRATED_BUTTONS|RESIZE"
config.integrated_title_buttons = { "Close" }
config.integrated_title_button_style = "Gnome"

-- Padding
config.window_padding = {
	top = 10,
	bottom = 10,
	left = 10,
	right = 10,
}

-- Basic update interval
config.status_update_interval = 1000

-- SHOW CURRENT TIME
-- Time Icons and Formatting
TIME_LEFT_SEPARATOR = wezterm.format({
	{ Foreground = { Color = MOCHA_MAUVE } },
	{ Text = "" },
})
CLOCK_ICON = wezterm.format({
	{ Background = { Color = MOCHA_MAUVE } },
	{ Foreground = { Color = MOCHA_MANTLE } },
	{ Text = " " },
})
TIME_RIGHT_SEPARATOR = wezterm.format({
	{ Foreground = { Color = MOCHA_SURFACE0 } },
	{ Text = " " },
})

local function get_clock()
	-- Get the current time
	local current_time = wezterm.strftime("%H:%M")
	-- Format the time string
	local time = wezterm.format({
		{ Background = { Color = MOCHA_SURFACE0 } },
		{ Text = " " .. current_time },
	})
	-- Set the window status
	return TIME_LEFT_SEPARATOR .. CLOCK_ICON .. time .. TIME_RIGHT_SEPARATOR
end

-- Zoom Icon and formatting
ZOOM_ICON = wezterm.format({
	{ Foreground = { Color = MOCHA_GREEN } },
	{ Text = "  " },
})

local function get_zoom(window)
	local zoom = ""
	local tab = window:active_tab()
	if tab then
		for _, p in ipairs(tab:panes_with_info()) do
			if p.is_active and p.is_zoomed then
				zoom = ZOOM_ICON
				break
			end
		end
	end
	return zoom
end

wezterm.on("update-status", function(window, _)
	local zoom = get_zoom(window)
	local clock = get_clock()
	window:set_right_status(zoom .. clock)
end)

-- INACTIVE PANE DIMMING
config.inactive_pane_hsb = {
	saturation = 0.8,
	brightness = 0.6,
}

-- TABS

-- Custom tab format
ACTIVE_TAB_LEFT_SEPARATOR = wezterm.format({
	{ Background = { Color = MOCHA_CRUST } },
	{ Foreground = { Color = MOCHA_SURFACE1 } },
	{ Text = "" },
})
ACTIVE_TAB_RIGHT_SEPARATOR = wezterm.format({
	{ Background = { Color = MOCHA_CRUST } },
	{ Foreground = { Color = MOCHA_PEACH } },
	{ Text = " " },
})
INACTIVE_TAB_LEFT_SEPARATOR = wezterm.format({
	{ Background = { Color = MOCHA_CRUST } },
	{ Foreground = { Color = MOCHA_SURFACE0 } },
	{ Text = "" },
})
INACTIVE_TAB_RIGHT_SEPARATOR = wezterm.format({
	{ Background = { Color = MOCHA_CRUST } },
	{ Foreground = { Color = MOCHA_BLUE } },
	{ Text = " " },
})

local function get_process_name(tab)
	local process = tab.active_pane.foreground_process_name

	process = process:gsub("%.exe$", "")
	process = process:gsub("^.*[/\\]", "")
	if process == "lua-language-server" then
		process = "nvim"
	end
	if process == "node" then
		process = "nvim"
	end
	return process
end

wezterm.on("format-tab-title", function(tab, _, _, _, _, _)
	local accent_color = MOCHA_BLUE
	local background_color = MOCHA_SURFACE0
	if tab.is_active then
		accent_color = MOCHA_PEACH
		background_color = MOCHA_SURFACE1
	end

	--
	local process = get_process_name(tab)
	local process_text = wezterm.format({
		{ Background = { Color = background_color } },
		{ Foreground = { Color = MOCHA_TEXT } },
		{ Text = process .. " " },
	})

	local number = tab.tab_index + 1 -- WezTerm uses 0-based indexing
	local number_text = wezterm.format({
		{ Background = { Color = accent_color } },
		{ Foreground = { Color = MOCHA_SURFACE0 } },
		{ Text = " " .. number },
	})

	if tab.is_active then
		return ACTIVE_TAB_LEFT_SEPARATOR .. process_text .. number_text .. ACTIVE_TAB_RIGHT_SEPARATOR
	else
		return INACTIVE_TAB_LEFT_SEPARATOR .. process_text .. number_text .. INACTIVE_TAB_RIGHT_SEPARATOR
	end
end)

-- KEYBINDS
config.leader = {
	key = "a",
	mods = "CTRL",
	timeout_milliseconds = 1000,
}
config.keys = {
	{
		key = "v",
		mods = "LEADER|CTRL",
		action = act.SplitPane({ direction = "Right" }),
	},
	{
		key = "s",
		mods = "LEADER|CTRL",
		action = act.SplitPane({ direction = "Down" }),
	},
	{
		key = "x",
		mods = "LEADER|CTRL",
		action = act.CloseCurrentPane({ confirm = true }),
	},
	{
		key = "w",
		mods = "LEADER|CTRL",
		action = act.CloseCurrentTab({ confirm = true }),
	},
	{
		key = "a",
		mods = "LEADER|CTRL",
		action = act.TogglePaneZoomState,
	},
	{
		key = "c",
		mods = "LEADER|CTRL",
		action = act.SpawnCommandInNewTab({ cwd = "~" }),
	},
	{
		key = "n",
		mods = "LEADER|CTRL",
		action = act.ActivateTabRelative(1),
	},
	{
		key = "h",
		mods = "CTRL",
		action = act.ActivatePaneDirection("Left"),
	},
	{
		key = "j",
		mods = "LEADER|CTRL",
		action = act.ActivatePaneDirection("Down"),
	},
	{
		key = "k",
		mods = "LEADER|CTRL",
		action = act.ActivatePaneDirection("Up"),
	},
	{
		key = "l",
		mods = "CTRL",
		action = act.ActivatePaneDirection("Right"),
	},
	{
		key = "p",
		mods = "LEADER|CTRL",
		action = act.PaneSelect({ mode = "SwapWithActiveKeepFocus" }),
	},
	{
		key = "LeftArrow",
		mods = "CTRL",
		action = act.AdjustPaneSize({ "Left", 1 }),
	},
	{
		key = "RightArrow",
		mods = "CTRL",
		action = act.AdjustPaneSize({ "Right", 1 }),
	},
	{
		key = "UpArrow",
		mods = "CTRL",
		action = act.AdjustPaneSize({ "Up", 1 }),
	},
	{
		key = "DownArrow",
		mods = "CTRL",
		action = act.AdjustPaneSize({ "Down", 1 }),
	},
	{
		key = "1",
		mods = "CTRL",
		action = act.ActivateTab(0),
	},
	{
		key = "2",
		mods = "CTRL",
		action = act.ActivateTab(1),
	},
	{
		key = "3",
		mods = "CTRL",
		action = act.ActivateTab(2),
	},
	{
		key = "4",
		mods = "CTRL",
		action = act.ActivateTab(3),
	},
	{
		key = "5",
		mods = "CTRL",
		action = act.ActivateTab(4),
	},
	{
		key = "F11",
		action = act.ToggleFullScreen,
	},
	{
		key = "l",
		mods = "LEADER|CTRL",
		action = act.ShowDebugOverlay,
	},
}

return config
