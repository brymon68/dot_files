local function apply_colorscheme()
	if vim.o.background == "light" then
		vim.cmd.colorscheme("dawnfox")
	else
		vim.cmd.colorscheme("catppuccin")
	end
end

local function apply_transparency()
	if vim.o.background == "light" then return end
	local groups = {
		"Normal",
		"NormalNC",
		"NormalFloat",
		"FloatBorder",
		"SignColumn",
		"StatusLine",
		"StatusLineNC",
		"VertSplit",
		"EndOfBuffer",
		"CursorLine",
	}
	for _, group in ipairs(groups) do
		vim.api.nvim_set_hl(0, group, { bg = "NONE", ctermbg = "NONE" })
	end
end

return {
	"catppuccin/nvim",
	name = "catppuccin",
	lazy = false,
	priority = 1000,
	dependencies = {
		{ "EdenEast/nightfox.nvim" },
		{
			"f-person/auto-dark-mode.nvim",
			opts = {
				update_interval = 1000,
				set_dark_mode = function()
					vim.api.nvim_set_option_value("background", "dark", {})
					apply_colorscheme()
					apply_transparency()
				end,
				set_light_mode = function()
					vim.api.nvim_set_option_value("background", "light", {})
					apply_colorscheme()
					apply_transparency()
				end,
			},
		},
	},
	config = function()
		require("catppuccin").setup({
			background = {
				light = "latte",
				dark = "macchiato",
			},
			transparent_background = true,
		})

		apply_colorscheme()
		require("auto-dark-mode").init()
		apply_transparency()

		vim.api.nvim_create_user_command("DD", function()
			vim.api.nvim_set_option_value("background", "dark", {})
			apply_colorscheme()
			apply_transparency()
		end, {})

		vim.api.nvim_create_user_command("DL", function()
			vim.api.nvim_set_option_value("background", "light", {})
			apply_colorscheme()
			apply_transparency()
		end, {})
	end,
}
