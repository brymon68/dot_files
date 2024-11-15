return {
	"folke/which-key.nvim",
	event = "VeryLazy",
	init = function()
		vim.o.timeout = true
		vim.o.timeoutlen = 500
	end,
	keys = {
		{ "<leader>w", "<cmd>write!<cr>", desc = "Save file" },
		{ "<leader>W", "<cmd>noautocmd w<cr>", "Save without formatting (noautocmd)" },
	},
}
