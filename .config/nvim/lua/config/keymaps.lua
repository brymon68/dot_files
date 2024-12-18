-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here
--
vim.g.mapleader = " "

local function map(mode, lhs, rhs)
	vim.keymap.set(mode, lhs, rhs, { silent = true })
end

-- delete default
map({ "n", "s" }, "<leader>w", ":write!<CR>")
map("n", "<leader>c", ":bd<cr>")

-- Panes resizing
map("n", "+", ":vertical resize +5<CR>")
map("n", "_", ":vertical resize -5<CR>")
map("n", "=", ":resize +5<CR>")
map("n", "-", ":resize -5<CR>")

-- Map enter to ciw in normal mode
map("n", "<CR>", "ciw")
map("n", "<BS>", "ci")

-- select all
map("n", "<C-a>", "ggVG")

-- write file in current directory
-- :w %:h/<new-file-name>
map("n", "<C-n>", ":w %:h/")

-- New Windows
map("n", "<leader>sv", "<CMD>vsplit<CR>")
map("n", "<leader>sh", "<CMD>split<CR>")

-- Close split pane
map("n", "<leader>sx", ":close<CR>")

-- greatest remap ever --theprimeagen
map("x", "<leader>p", [["_dP]])

-- Run pytest in toggleterm on current file
map("v", "J", ":m '>+1<CR>gv=gv")
map("v", "K", ":m '<-2<CR>gv=gv")
map("n", "<leader>tt", function()
	local file_path = vim.fn.expand("%:p")
	-- Create a new terminal and run pytest
	require("toggleterm").exec("poetry run pytest -s " .. file_path)
end)
