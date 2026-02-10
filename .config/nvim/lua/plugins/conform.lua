return {
	"stevearc/conform.nvim",
	cmd = "ConformFormat",
	config = function()
		local conform = require("conform")
		conform.setup({
			log_level = vim.log.levels.DEBUG,
			notify_on_error = true,
			formatters_by_ft = {
				javascript = { "oxfmt" },
				typescript = { "oxfmt" },
				javascriptreact = { "oxfmt" },
				typescriptreact = { "oxfmt" },
				go = { "gofmt" },
				css = { "oxfmt" },
				html = { "oxfmt" },
				json = { "oxfmt" },
				yaml = { "oxfmt" },
				markdown = { "oxfmt" },
				groovy = { "npm-groovy-lint" },
				lua = { "stylua" },
				python = { "ruff" },
			},
		})

		-- Manual format command
		vim.api.nvim_create_user_command("ConformFormat", function()
			conform.format({ async = false, timeout_ms = 1000 })
		end, { desc = "Format current buffer" })
	end,
}
