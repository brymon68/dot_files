-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
-- Add any additional autocmds here
--
local api = vim.api

-- don't auto comment new line
api.nvim_create_autocmd("BufEnter", { command = [[set formatoptions-=cro]] })

vim.api.nvim_create_user_command("CopilotToggle", function()
	vim.g.copilot_enabled = not vim.g.copilot_enabled
	if vim.g.copilot_enabled then
		vim.cmd("Copilot disable")
		print("Copilot OFF")
	else
		vim.cmd("Copilot enable")
		print("Copilot ON")
	end
end, { nargs = 0 })
vim.keymap.set("", "<leader>ct", ":CopilotToggle<CR>", { noremap = true, silent = true })
