return {
	"nvim-telescope/telescope.nvim",
	cmd = "Telescope",
	lazy = true,
	config = function()
		local telescope = require("telescope")
		telescope.setup({
			defaults = {
				path_display = {
					"filename_first",
				},
			},
			pickers = {
				find_files = {
					hidden = true,
					find_command = { "rg", "--files", "--hidden", "--glob", "!**/.git/*" },
				},
			},
		})
	end,
	keys = {
		{
			"<leader>ff",
			function()
				require("telescope.builtin").find_files(require("telescope.themes").get_ivy({}))
			end,
			desc = "Find Files",
		},
		{
			"<leader>fs",
			"<cmd>Telescope live_grep<cr>",
			desc = "Find string in cwd",
		},
		{
			"<leader>fc",
			"<cmd>Telescope grep_string<cr>",
			desc = "Find string under cursor in cwd",
		},
	},
}
