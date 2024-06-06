local Theme = {}

Theme.colors = {
	rosewater = "#f4dbd6",
	flamingo = "#f0c6c6",
	pink = "#f5bde6",
	mauve = "#c6a0f6",
	red = "#ed8796",
	maroon = "#ee99a0",
	peach = "#f5a97f",
	yellow = "#eed49f",
	green = "#a6da95",
	teal = "#8bd5ca",
	sky = "#91d7e3",
	sapphire = "#7dc4e4",
	blue = "#8aadf4",
	lavender = "#b7bdf8",
	text = "#cad3f5",
	subtext1 = "#b8c0e0",
	subtext0 = "#a5adcb",
	overlay2 = "#939ab7",
	overlay1 = "#8087a2",
	overlay0 = "#6e738d",
	surface2 = "#5b6078",
	surface1 = "#494d64",
	surface0 = "#363a4f",
	base = "#24273a",
	mantle = "#1e2030",
	crust = "#181926",
}

function Theme.setup(config)
	local colors = Theme.colors

	config.colors = {
		split = colors.surface0,
		foreground = colors.text,
		background = colors.base,
		cursor_bg = colors.subtext0,
		cursor_border = colors.overlay2,
		cursor_fg = colors.base,
		selection_bg = colors.surface2,
		visual_bell = colors.surface0,
		indexed = {
			[16] = colors.peach,
			[17] = colors.rosewater,
		},
		scrollbar_thumb = colors.surface2,
		compose_cursor = colors.flamingo,
		ansi = {
			colors.surface0,
			colors.red,
			colors.green,
			colors.yellow,
			colors.blue,
			colors.mauve,
			colors.teal,
			colors.text,
		},
		brights = {
			colors.surface2,
			colors.red,
			colors.green,
			colors.yellow,
			colors.blue,
			colors.mauve,
			colors.teal,
			colors.surface2,
		},
		tab_bar = {
			background = colors.green,
			active_tab = {
				bg_color = colors.surface0,
				fg_color = colors.teal,
				intensity = "Bold",
				underline = "None",
				italic = false,
				strikethrough = false,
			},
			inactive_tab = {
				bg_color = colors.base,
				fg_color = colors.surface2,
			},
			inactive_tab_hover = {
				bg_color = colors.base,
				fg_color = colors.subtext0,
			},
			new_tab = {
				bg_color = colors.base,
				fg_color = colors.subtext0,
			},
			new_tab_hover = {
				bg_color = colors.base,
				fg_color = colors.surface2,
			},
		},
	}
end

return Theme
