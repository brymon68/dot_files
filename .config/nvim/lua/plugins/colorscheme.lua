return {
	"folke/tokyonight.nvim",
	lazy = false,
	priority = 1000,
	dependencies = {
		{
			"f-person/auto-dark-mode.nvim",
			opts = {
				update_interval = 1000,
				set_dark_mode = function()
					vim.api.nvim_set_option_value("background", "dark", {})
					vim.cmd("colorscheme tokyonight-night")
				end,
				set_light_mode = function()
					vim.api.nvim_set_option_value("background", "light", {})
					vim.cmd("colorscheme tokyonight-day")
				end,
			},
		},
	},
	background = {
		light = "day",
		dark = "night",
	},
	config = function()
		require("auto-dark-mode").init()

		vim.cmd.colorscheme("tokyonight-night")

		vim.api.nvim_create_user_command("DD", function()
			vim.cmd.colorscheme("tokyonight-night")
		end, {})

		vim.api.nvim_create_user_command("DL", function()
			vim.cmd.colorscheme("tokyonight-day")
		end, {})
	end,
}
