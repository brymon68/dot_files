return {
	"folke/noice.nvim",
	event = "VeryLazy",
	opts = {
		cmdline = {
			enabled = true,
			view = "cmdline",
		},
		popupmenu = {
			enabled = false,
		},
		-- add any options here
	},
	dependencies = {
		-- if you lazy-load any plugin below, make sure to add proper `module="..."` entries
		"MunifTanjim/nui.nvim",
		-- OPTIONAL:
		--   `nvim-notify` is only needed, if you want to use the notification view.
		--   If not available, we use `mini` as the fallback
		"rcarriga/nvim-notify",
	},
	config = function()
		vim.keymap.set("n", "<leader>nd", "<cmd>Noice dismiss<CR>", { noremap = true, silent = true })
		vim.keymap.set(
			"n",
			"<leader>nl",
			"<cmd>Telescope notify<cr>",
			{ noremap = true, silent = true, desc = "List notifications" }
		)
	end,
}
