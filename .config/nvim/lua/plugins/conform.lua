return {
	"stevearc/conform.nvim",
	event = { "BufReadPre", "BufNewFile" },
	opts = {
		formatters_by_ft = {
			python = { "isort", "black" },
			lua = { "stylua" },
			javascript = { "prettierd" },
			typescript = { "prettierd" },
			json = { "prettierd" },
			yaml = { "prettierd" },
			markdown = { "prettierd" },
			html = { "prettierd" },
		},
		format_on_save = {
			timeout_ms = 8000,
			lsp_fallback = true,
			async = false,
		},
	},
}
