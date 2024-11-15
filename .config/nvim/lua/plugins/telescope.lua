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
		})
		-- set keymaps
		local keymap = vim.keymap -- for conciseness

		keymap.set("n", "<leader>fs", "<cmd>Telescope live_grep<cr>", { desc = "Find string in cwd" })
		keymap.set("n", "<leader>fc", "<cmd>Telescope grep_string<cr>", { desc = "Find string under cursor in cwd" })
	end,
	keys = {
		-- disable the keymap to grep files
		{ "<leader>/", false },
		-- change a keymap
		{ "<leader>ff", ':lua require"telescope.builtin".find_files({ hidden = true })<CR>', desc = "Find Files" },
	},
}
