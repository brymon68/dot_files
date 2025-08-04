vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1
local opt = vim.opt

opt.number = true
opt.numberwidth = 1

opt.tabstop = 2
opt.shiftwidth = 2 -- 2 spaces for indent width
opt.expandtab = true -- expand tab to spaces
opt.autoindent = true -- copy indent from current line

opt.wrap = false
opt.ignorecase = true -- ignore case when searching
opt.smartcase = true -- if you incldue mixedcase in search, assumes you want case-sensitive

opt.cursorline = true

opt.termguicolors = true
opt.signcolumn = "yes"

opt.backspace = "indent,eol,start" -- allow backspace on indent, end of line or insert mode start position
opt.clipboard = "unnamedplus" --use system keyboard as default register

opt.splitright = true -- split veritical window to right
opt.splitbelow = true -- split horizontal windwo to bottom
opt.ttimeoutlen = 0 -- The time in milliseconds that is waited for a key code or mapped key sequence to complete.

-- turn off swapfile
opt.swapfile = false

-- undo
opt.undodir = vim.fn.stdpath("cache") .. "/undo"
opt.undofile = true -- enable persistent undo

-- auto-reload files when changed outside vim
opt.autoread = true

opt.winborder = "rounded"
