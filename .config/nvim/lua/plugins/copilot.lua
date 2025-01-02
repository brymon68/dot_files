return {
	"github/copilot.vim",
	dependencies = { "catppuccin/nvim" },
	event = "VimEnter",
	init = function()
		vim.g.copilot_workspace_folders = { vim.fn.getcwd() }
	end,
	keys = {},
}
