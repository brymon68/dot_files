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
local act = wezterm.action
local k = require("keys")
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
		left = 10,
		right = 0,
		top = 10,
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
		inactive_titlebar_bg = colors.base,
	},
	keys = {
		-- k.cmd_key("[", act.SendKey({ mods = "CTRL", key = "o" })),
		-- k.cmd_key("]", act.SendKey({ mods = "CTRL", key = "i" })),
		-- k.cmd_key("f", k.multiple_actions(":Grep")),
		-- k.cmd_key("H", act.SendKey({ mods = "CTRL", key = "h" })),
		-- k.cmd_key("J", act.SendKey({ mods = "CTRL", key = "j" })),
		-- k.cmd_key("K", act.SendKey({ mods = "CTRL", key = "k" })),
		-- k.cmd_key("L", act.SendKey({ mods = "CTRL", key = "l" })),
		--bryce stuff
		k.cmd_key(
			"s",
			act.Multiple({
				act.SendKey({ mods = "CTRL", key = "b" }),
				act.SendKey({ key = "s" }),
			})
		),
		k.cmd_key(
			"r",
			act.Multiple({
				act.SendKey({ mods = "CTRL", key = "b" }),
				act.SendKey({ key = "$" }),
			})
		),
		k.cmd_key(
			",",
			act.Multiple({
				act.SendKey({ mods = "CTRL", key = "b" }),
				act.SendKey({ key = "," }),
			})
		),

		-- end bryce stuff
		k.cmd_to_tmux_prefix("1", "1"),
		k.cmd_to_tmux_prefix("2", "2"),
		k.cmd_to_tmux_prefix("3", "3"),
		k.cmd_to_tmux_prefix("4", "4"),
		k.cmd_to_tmux_prefix("5", "5"),
		k.cmd_to_tmux_prefix("6", "6"),
		k.cmd_to_tmux_prefix("7", "7"),
		k.cmd_to_tmux_prefix("8", "8"),
		k.cmd_to_tmux_prefix("9", "9"),
		k.cmd_to_tmux_prefix("`", "n"),
		k.cmd_to_tmux_prefix("b", "B"),
		k.cmd_to_tmux_prefix("C", "C"),
		k.cmd_to_tmux_prefix("d", "D"),
		k.cmd_to_tmux_prefix("G", "G"),
		k.cmd_to_tmux_prefix("g", "g"),
		k.cmd_to_tmux_prefix("k", "T"),
		k.cmd_to_tmux_prefix("l", "L"),
		k.cmd_to_tmux_prefix("n", '"'),
		k.cmd_to_tmux_prefix("N", "%"),
		k.cmd_to_tmux_prefix("o", "u"),
		k.cmd_to_tmux_prefix("T", "!"),
		k.cmd_to_tmux_prefix("t", "c"),
		k.cmd_to_tmux_prefix("w", "x"),
		k.cmd_to_tmux_prefix("z", "z"),

		k.cmd_key(
			"R",
			act.Multiple({
				act.SendKey({ key = "\x1b" }), -- escape
				k.multiple_actions(":source %"),
			})
		),

		{
			key = "m",
			mods = "CMD",
			action = wezterm.action.DisableDefaultAssignment,
		},
		{ key = "{", mods = "CMD|SHIFT", action = act({ SendString = "\x02p" }) },
		{ key = "}", mods = "CMD|SHIFT", action = act({ SendString = "\x02n" }) },
		{
			mods = "CTRL",
			key = "Tab",
			action = act.Multiple({
				act.SendKey({ mods = "CTRL", key = "b" }),
				act.SendKey({ key = "n" }),
			}),
		},

		{
			key = "z",
			mods = "CMD",
			action = act({
				SendString = "nvim $(find ~/workplace -type f | grep -vE '/(node_modules|.venv)/' | fzf)\n",
			}),
		},
		{
			mods = "CTRL|SHIFT",
			key = "Tab",
			action = act.Multiple({
				act.SendKey({ mods = "CTRL", key = "b" }),
				act.SendKey({ key = "n" }),
			}),
		},

		{
			mods = "CMD",
			key = "~",
			action = act.Multiple({
				act.SendKey({ mods = "CTRL", key = "b" }),
				act.SendKey({ key = "p" }),
			}),
		},
	},
}

tab.setup(config)
theme.setup(config)
return config
