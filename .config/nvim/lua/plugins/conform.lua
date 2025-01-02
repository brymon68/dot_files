return {
	"stevearc/conform.nvim",
	opts = {
		formatters_by_ft = {
			python = { "black", "isort" },
			lua = { "stylua" },
			javascript = { "prettierd" },
			typescript = { "prettierd" },
			json = { "prettierd" },
			yaml = { "prettierd" },
			markdown = { "prettierd" },
			html = { "prettierd" },
		},
		format_on_save = {
			timeout_ms = 2000,
			lsp_format = "fallback",
		},
	},
}
