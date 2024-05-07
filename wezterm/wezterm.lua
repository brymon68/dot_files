--
-- ██╗    ██╗███████╗███████╗████████╗███████╗██████╗ ███╗   ███╗
-- ██║    ██║██╔════╝╚══███╔╝╚══██╔══╝██╔════╝██╔══██╗████╗ ████║
-- ██║ █╗ ██║█████╗    ███╔╝    ██║   █████╗  ██████╔╝██╔████╔██║
-- ██║███╗██║██╔══╝   ███╔╝     ██║   ██╔══╝  ██╔══██╗██║╚██╔╝██║
-- ╚███╔███╔╝███████╗███████╗   ██║   ███████╗██║  ██║██║ ╚═╝ ██║
--  ╚══╝╚══╝ ╚══════╝╚══════╝   ╚═╝   ╚══════╝╚═╝  ╚═╝╚═╝     ╚═╝
-- A GPU-accelerated cross-platform terminal emulator
-- https://wezfurlong.org/wezterm/

local wezterm = require("wezterm")
local tab = require("tab")
local theme = require("theme")
local colors = require("theme").colors
local config = {

	font_size = 14,
	font = wezterm.font("FiraCode Nerd Font Mono"),
	color_scheme = "Catppuccin Macchiato",
	enable_wayland = false,
	pane_focus_follows_mouse = false,
	warn_about_missing_glyphs = false,
	show_update_window = false,
	check_for_updates = false,
	window_close_confirmation = "NeverPrompt",
	window_padding = {
		left = 0,
		right = 0,
		top = 0,
		bottom = 0,
	},
	inactive_pane_hsb = {
		saturation = 0.9,
		brightness = 0.20,
	},
	enable_scroll_bar = false,
	window_decorations = "RESIZE",
	window_background_opacity = 40.0,
	window_frame = {
		font_size = 16,
		active_titlebar_bg = colors.base,
	},
}

wezterm.on("window-resized", function()
	return wezterm.format({
		{ Foreground = { Color = colors.base } },
		{ Background = { Color = colors.base } },
	})
end)
tab.setup(config)
theme.setup(config)
return config
