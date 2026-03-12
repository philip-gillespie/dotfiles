-- .wezterm.lua
local wezterm = require("wezterm")
local act = wezterm.action

-- Build the config
local config = wezterm.config_builder()

-- Run bash by default
local operating_system = wezterm.target_triple
local is_mac = operating_system:find("apple") ~= nil
local mod = is_mac and "CMD" or "CTRL"
local nav_mod = is_mac and "CMD" or "LEADER|CTRL"

if is_mac then
	-- TITLE_BAR gives you the traffic lights, but RESIZE removes the thick ugly bar
	config.window_decorations = "INTEGRATED_BUTTONS|RESIZE"
	config.integrated_title_button_style = "MacOsNative"
else
	-- Your Linux/Gnome preference
	config.window_decorations = "INTEGRATED_BUTTONS|RESIZE"
	config.integrated_title_buttons = { "Close" }
	config.integrated_title_button_style = "Gnome"
end

wezterm.on("window-resized", function(window, pane)
	local overrides = window:get_config_overrides() or {}
	local is_fullscreen = window:get_dimensions().is_full_screen

	-- Only apply this logic if we are on macOS
	if wezterm.target_triple:find("apple") ~= nil then
		if is_fullscreen then
			overrides.window_decorations = "RESIZE"
		else
			overrides.window_decorations = "INTEGRATED_BUTTONS|RESIZE"
		end

		window:set_config_overrides(overrides)
	end
end)

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

wezterm.on("window-focus-changed", function(window, _)
	local overrides = window:get_config_overrides() or {}
	if window:is_focused() then
		overrides.colors = nil
		overrides.foreground_text_hsb = nil
	else
		local palette = window:effective_config().resolved_palette
		local current_bg = wezterm.color.parse(palette.background)
		local faded_bg = current_bg:darken(0.4):desaturate(0.4)
		overrides.colors = {
			background = faded_bg,
		}
		overrides.foreground_text_hsb = {
			brightness = 0.6,
			saturation = 0.6,
		}
	end
	window:set_config_overrides(overrides)
end)

-- Tabs
config.enable_tab_bar = true
config.use_fancy_tab_bar = false
config.show_new_tab_button_in_tab_bar = false

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

local function get_tab_title(tab)
	local title = tab.tab_title
	if title and #title > 0 then
		return title
	end

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
	local title = get_tab_title(tab)
	local title_text = wezterm.format({
		{ Background = { Color = background_color } },
		{ Foreground = { Color = MOCHA_TEXT } },
		{ Text = title .. " " },
	})

	local number = tab.tab_index + 1 -- WezTerm uses 0-based indexing
	local number_text = wezterm.format({
		{ Background = { Color = accent_color } },
		{ Foreground = { Color = MOCHA_SURFACE0 } },
		{ Text = " " .. number },
	})

	if tab.is_active then
		return ACTIVE_TAB_LEFT_SEPARATOR .. title_text .. number_text .. ACTIVE_TAB_RIGHT_SEPARATOR
	else
		return INACTIVE_TAB_LEFT_SEPARATOR .. title_text .. number_text .. INACTIVE_TAB_RIGHT_SEPARATOR
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
		key = "e",
		mods = "LEADER|CTRL",
		action = act.PromptInputLine({
			description = "Enter new tab name",
			action = wezterm.action_callback(function(window, pane, line)
				if line then
					window:active_tab():set_title(line)
				end
			end),
		}),
	},
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
		key = "h",
		mods = nav_mod,
		action = act.ActivatePaneDirection("Left"),
	},
	{
		key = "j",
		mods = nav_mod,
		action = act.ActivatePaneDirection("Down"),
	},
	{
		key = "k",
		mods = nav_mod,
		action = act.ActivatePaneDirection("Up"),
	},
	{
		key = "l",
		mods = "CTRL",
		action = act.ActivatePaneDirection("Right"),
	},
	{
		key = "l",
		mods = nav_mod,
		action = act.ActivatePaneDirection("Right"),
	},
	{
		key = "p",
		mods = "LEADER|CTRL",
		action = act.PaneSelect({ mode = "SwapWithActiveKeepFocus" }),
	},
	{
		key = "LeftArrow",
		mods = mod,
		action = act.AdjustPaneSize({ "Left", 1 }),
	},
	{
		key = "RightArrow",
		mods = mod,
		action = act.AdjustPaneSize({ "Right", 1 }),
	},
	{
		key = "UpArrow",
		mods = mod,
		action = act.AdjustPaneSize({ "Up", 1 }),
	},
	{
		key = "DownArrow",
		mods = mod,
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
}

return config
