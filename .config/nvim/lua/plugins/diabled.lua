return {
	{ "folke/neodev.nvim", enabled = false },
	{ "HakonHarnes/img-clip.nvim", enabled = false },
	{ "echasnovski/mini.ai", enabled = false },
	{
		"LazyVim/LazyVim",
		opts = {
			defaults = {
				-- Disable all default key bindings
				keymaps = false,
			},
		},
	},
}
