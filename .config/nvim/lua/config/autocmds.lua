-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
-- Add any additional autocmds here
--
local api = vim.api

-- don't auto comment new line
api.nvim_create_autocmd("BufEnter", { command = [[set formatoptions-=cro]] })
vim.keymap.set("", "<leader>ct", ":Copilot toggle<CR>", { noremap = true, silent = true })

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
