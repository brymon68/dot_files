-- Add any additional autocmds here.
local api = vim.api

-- Don't auto-comment new lines.
api.nvim_create_autocmd("BufEnter", { command = [[set formatoptions-=cro]] })

-- Reload files changed outside vim (e.g. from tmux / another terminal).
api.nvim_create_autocmd({ "BufEnter", "FocusGained", "CursorHold", "CursorHoldI" }, {
	pattern = "*",
	command = "checktime",
})

-- Notify when a file changes on disk.
api.nvim_create_autocmd("FileChangedShellPost", {
	pattern = "*",
	command = "echohl WarningMsg | echo 'File changed on disk. Buffer reloaded.' | echohl None",
})

-- Buffer-local LSP keymaps.
api.nvim_create_autocmd("LspAttach", {
	group = api.nvim_create_augroup("lsp-attach", { clear = true }),
	callback = function(event)
		local utils = require("config.utils")
		local opts = { noremap = true, silent = true, buffer = event.buf }
		vim.keymap.set("n", "<leader>lg", function()
			utils.copyFilePathAndLineNumber()
		end, opts)
		vim.keymap.set("v", "<leader>lg", function()
			utils.copyFilePathAndLineNumber(true)
		end, opts)
		vim.keymap.set("n", "gl", function()
			utils.show_and_copy_diagnostic()
		end, opts)
	end,
})
