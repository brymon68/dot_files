return {
	"folke/which-key.nvim",
	event = "VeryLazy",
	init = function()
		vim.o.timeout = true
		vim.o.timeoutlen = 500
	end,
	keys = {
		{ "<leader>w", "<cmd>write!<cr>", desc = "Save file" },
		{ "<leader>ff", require("config.utils").telescope_git_or_file, desc = "Find Files (root)" },
		{ "<leader>W", "<cmd>noautocmd w<cr>", "Save without formatting (noautocmd)" },
	},
}
