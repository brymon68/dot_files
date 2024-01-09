-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here
--

local opts = { noremap = true, silent = true }
local map = vim.keymap.set
-- Fast saving
--
map("n", "<Leader>w", ":write!<CR>", opts)
map("n", "<Leader>c", ":bw<CR>", opts)

-- Panes resizing
map("n", "+", ":vertical resize +5<CR>")
map("n", "_", ":vertical resize -5<CR>")
map("n", "=", ":resize +5<CR>")
map("n", "-", ":resize -5<CR>")

-- Map enter to ciw in normal mode
map("n", "<CR>", "ciw", opts)
map("n", "<BS>", "ci", opts)

-- select all
map("n", "<C-a>", "ggVG", opts)

-- write file in current directory
-- :w %:h/<new-file-name>
map("n", "<C-n>", ":w %:h/", opts)
