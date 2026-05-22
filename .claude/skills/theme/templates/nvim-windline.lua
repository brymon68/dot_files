return {
	"windwp/windline.nvim",
	config = function()
		require("wlsample.airline")

		-- Override colors_name. When the `theme` skill has themed the active
		-- slot, derive windline colors from the generated base16 palette
		-- (lua/config/theme.lua); otherwise fall back to the catppuccin
		-- (dark) / nightfox (light) palettes. The default windline theme
		-- derives from terminal_color_* / Normal, which breaks under a
		-- transparent bg (Normal bg = NONE).
		local HSL = require("wlanimation.utils")
		_G.WindLine.state.config.colors_name = function(colors)
			local p

			local ok_theme, theme = pcall(require, "config.theme")
			local slot = ok_theme
					and (vim.o.background == "light" and theme.light or theme.dark)
				or nil

			if slot and slot.themed then
				-- Map base16 -> a catppuccin-shaped palette
				local b = slot.base16
				p = {
					crust = b.base00, mantle = b.base01, surface0 = b.base02,
					overlay1 = b.base03, subtext1 = b.base04, text = b.base05,
					red = b.base08, maroon = b.base09, green = b.base0B,
					teal = b.base0C, yellow = b.base0A, peach = b.base09,
					blue = b.base0D, sapphire = b.base0D, mauve = b.base0E,
					pink = b.base0E, sky = b.base0C,
				}
			elseif vim.o.background == "light" then
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

			-- Map palette → windline color keys
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
