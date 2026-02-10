return {
	"windwp/windline.nvim",
	config = function()
		require("wlsample.airline")

		-- Override colors_name to inject catppuccin palette directly.
		-- Default theme derives from terminal_color_* and Normal hl group,
		-- which breaks with transparent bg (Normal bg = NONE).
		local HSL = require("wlanimation.utils")
		_G.WindLine.state.config.colors_name = function(colors)
			local p
			if vim.o.background == "light" then
				local ok, nfpal = pcall(require, "nightfox.palette")
				if not ok then return colors end
				local raw = nfpal.load("dawnfox")
				p = {
					crust = raw.bg0, red = raw.red.base, green = raw.green.base,
					yellow = raw.yellow.base, blue = raw.blue.base, mauve = raw.magenta.base,
					teal = raw.cyan.base, text = raw.fg1, surface0 = raw.bg2,
					maroon = raw.orange.base, peach = raw.orange.bright,
					sapphire = raw.blue.bright, pink = raw.pink.base, sky = raw.cyan.bright,
					subtext1 = raw.fg2, overlay1 = raw.fg3, mantle = raw.bg1,
				}
			else
				local ok, palettes = pcall(require, "catppuccin.palettes")
				if not ok then return colors end
				p = palettes.get_palette()
			end

			-- Map catppuccin palette → windline color keys
			colors.black = p.crust
			colors.red = p.red
			colors.green = p.green
			colors.yellow = p.yellow
			colors.blue = p.blue
			colors.magenta = p.mauve
			colors.cyan = p.teal
			colors.white = p.text
			colors.black_light = p.surface0
			colors.red_light = p.maroon
			colors.green_light = p.teal
			colors.yellow_light = p.peach
			colors.blue_light = p.sapphire
			colors.magenta_light = p.pink
			colors.cyan_light = p.sky
			colors.white_light = p.subtext1

			colors.NormalFg = p.text
			colors.NormalBg = vim.o.background == "light" and p.mantle or "NONE"
			colors.ActiveFg = p.text
			colors.ActiveBg = p.surface0
			colors.InactiveFg = p.overlay1
			colors.InactiveBg = p.mantle

			-- Shade/tint derivation (same as airline default)
			local mod = function(c, value)
				if vim.o.background == "light" then
					return HSL.rgb_to_hsl(c):tint(value):to_rgb()
				end
				return HSL.rgb_to_hsl(c):shade(value):to_rgb()
			end

			colors.magenta_a = colors.magenta
			colors.magenta_b = mod(colors.magenta, 0.5)
			colors.magenta_c = mod(colors.magenta, 0.7)

			colors.yellow_a = colors.yellow
			colors.yellow_b = mod(colors.yellow, 0.5)
			colors.yellow_c = mod(colors.yellow, 0.7)

			colors.blue_a = colors.blue
			colors.blue_b = mod(colors.blue, 0.5)
			colors.blue_c = mod(colors.blue, 0.7)

			colors.green_a = colors.green
			colors.green_b = mod(colors.green, 0.5)
			colors.green_c = mod(colors.green, 0.7)

			colors.red_a = colors.red
			colors.red_b = mod(colors.red, 0.5)
			colors.red_c = mod(colors.red, 0.7)

			return colors
		end

		require("windline").on_colorscheme()
	end,
}
