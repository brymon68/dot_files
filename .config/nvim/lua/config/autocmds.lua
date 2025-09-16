-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
-- Add any additional autocmds here
--
local api = vim.api

-- don't auto comment new line
api.nvim_create_autocmd("BufEnter", { command = [[set formatoptions-=cro]] })
vim.keymap.set("", "<leader>ct", ":Copilot toggle<CR>", { noremap = true, silent = true })

-- Auto-reload files when they change externally (like from tmux/other terminal)
api.nvim_create_autocmd({ "BufEnter", "FocusGained", "CursorHold", "CursorHoldI" }, {
	pattern = "*",
	command = "checktime",
})

-- Notify when file changes externally
api.nvim_create_autocmd("FileChangedShellPost", {
	pattern = "*",
	command = "echohl WarningMsg | echo 'File changed on disk. Buffer reloaded.' | echohl None",
})

vim.api.nvim_create_autocmd("LspAttach", {
	group = vim.api.nvim_create_augroup("lsp-attach", { clear = true }),
	callback = function(event)
		-- map utils.copyFilePathAndLineNumber to lg
		local utils = require("config.utils")
		vim.keymap.set("n", "<leader>lg", function()
			utils.copyFilePathAndLineNumber()
		end, { noremap = true, silent = true, buffer = event.buf })
		vim.keymap.set("n", "gl", function()
			utils.show_and_copy_diagnostic()
		end, { noremap = true, silent = true, buffer = event.buf })
	end,
})

-- Toggle linting
local linting_enabled = true
local map = vim.keymap.set
map("n", "<leader>lt", function()
	linting_enabled = not linting_enabled
	if linting_enabled then
		-- Re-enable linting by recreating the autocmds
		local lint_augroup = vim.api.nvim_create_augroup("lint", { clear = true })
		vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost", "InsertLeave" }, {
			group = lint_augroup,
			callback = function()
				local lint = require("lint")
				local linters = lint.linters_by_ft[vim.bo.filetype]
				if linters and #linters > 0 then
					lint.try_lint()
				end
			end,
		})
		vim.notify("Linting enabled", vim.log.levels.INFO, { title = "nvim-lint" })
	else
		-- Disable linting by clearing the augroup and diagnostics
		vim.api.nvim_create_augroup("lint", { clear = true })
		vim.diagnostic.reset()
		vim.notify("Linting disabled", vim.log.levels.INFO, { title = "nvim-lint" })
	end
end)

-- Toggle windline
local windline_enabled = true
map("n", "<leader>wt", function()
	windline_enabled = not windline_enabled
	if windline_enabled then
		vim.o.laststatus = 2
		vim.notify("Windline enabled", vim.log.levels.INFO, { title = "Windline" })
	else
		vim.o.laststatus = 0
		vim.notify("Windline disabled", vim.log.levels.INFO, { title = "Windline" })
	end
end, { desc = "Toggle windline" })

-- Toggle zen mode - disable linting, windline, bufferline, and copilot
local zen_mode_enabled = false
map("n", "<leader>z", function()
	zen_mode_enabled = not zen_mode_enabled
	if zen_mode_enabled then
		-- Disable linting
		linting_enabled = false
		vim.api.nvim_create_augroup("lint", { clear = true })
		vim.diagnostic.reset()

		-- Disable windline
		windline_enabled = false
		vim.o.laststatus = 0

		-- Disable bufferline
		vim.o.showtabline = 0

		-- Disable copilot
		vim.cmd("Copilot disable")

		vim.notify("Zen mode enabled", vim.log.levels.INFO, { title = "Zen Mode" })
	else
		-- Re-enable linting
		linting_enabled = true
		local lint_augroup = vim.api.nvim_create_augroup("lint", { clear = true })
		vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost", "InsertLeave" }, {
			group = lint_augroup,
			callback = function()
				local lint = require("lint")
				local linters = lint.linters_by_ft[vim.bo.filetype]
				if linters and #linters > 0 then
					lint.try_lint()
				end
			end,
		})

		-- Re-enable windline
		windline_enabled = true
		vim.o.laststatus = 2

		-- Re-enable bufferline
		vim.o.showtabline = 2

		-- Re-enable copilot
		vim.cmd("Copilot enable")

		vim.notify("Zen mode disabled", vim.log.levels.INFO, { title = "Zen Mode" })
	end
end, { desc = "Toggle zen mode" })
