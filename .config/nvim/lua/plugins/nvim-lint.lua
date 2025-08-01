return {
	"mfussenegger/nvim-lint",
	event = { "BufReadPre", "BufNewFile" },
	config = function()
		local lint = require("lint")

		-- Configure custom linters using Mason-managed tools
		local mason_bin_dir = vim.fn.stdpath("data") .. "/mason/bin"

		-- Configure linters by filetype (using Mason-managed tools)
		lint.linters_by_ft = {
			-- Go
			go = { "golangcilint" },

			-- JavaScript/TypeScript
			javascript = { "eslint_d" },
			typescript = { "eslint_d" },
			javascriptreact = { "eslint_d" },
			typescriptreact = { "eslint_d" },

			-- Lua (commented out until luacheck is installed)
			-- lua = { "luacheck" },

			-- Shell
			sh = { "shellcheck" },
			bash = { "shellcheck" },
			zsh = { "shellcheck" },

			-- You can add more linters here as needed
			python = { "flake8", "mypy" },
		}

		-- Auto-lint on save and text changes
		local lint_augroup = vim.api.nvim_create_augroup("lint", { clear = true })

		vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost", "InsertLeave" }, {
			group = lint_augroup,
			callback = function()
				-- Only lint if linters are available for this filetype
				local linters = lint.linters_by_ft[vim.bo.filetype]
				if linters and #linters > 0 then
					lint.try_lint()
				end
			end,
		})

		-- Clear diagnostics on text changes
		vim.api.nvim_create_autocmd({ "TextChanged", "TextChangedI" }, {
			group = lint_augroup,
			callback = function()
				-- Clear all diagnostics for the current buffer
				vim.diagnostic.reset(nil, 0)
			end,
		})

		-- Manual linting command
		vim.keymap.set("n", "<leader>ll", function()
			lint.try_lint()
			vim.notify("Linting...", vim.log.levels.INFO, { title = "nvim-lint" })
		end, { desc = "Trigger linting for current file" })

		-- Show linter status
		vim.keymap.set("n", "<leader>li", function()
			local linters = lint.linters_by_ft[vim.bo.filetype] or {}
			if #linters == 0 then
				print("No linters configured for filetype: " .. vim.bo.filetype)
			else
				print("Linters for " .. vim.bo.filetype .. ": " .. table.concat(linters, ", "))
			end
		end, { desc = "Show available linters for current filetype" })
	end,
}
