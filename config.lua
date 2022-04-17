-- THESE ARE EXAMPLj CONFIGS FEEL  FREE TO CHANGE TO WHATEVER YOU WANT
-- general
lvim.log.level          = "warn"
lvim.format_on_save     = true
lvim.colorscheme        = "tokyonight"
lvim.transparent_window = false
-- general
vim.opt.pumheight       = 12
vim.opt.wrap            = false
vim.opt.smartindent     = true
vim.opt.modifiable      = true


-- keymappings [view all the defaults by pressing <leader>Lk]
lvim.leader = "space"
lvim.keys.normal_mode = {
  ["<C-h>"] = ":wincmd h <cr>",
  ["<C-l>"] = ":wincmd l <cr>",
  ["U"] = "<C-r><cr>",
  ["<c-s>"] = ":w<cr>",
  ["<leader>U"] = ":UndotreeShow<Cr>",
  ["C-="] = ":NvimTreeResize +5<Cr>",
  ["C--"] = ":NvimTreeResize -5<Cr>",
}

vim.cmd("nnoremap <Down> <C-d>")
vim.cmd("nnoremap <Up> <C-u>")
vim.cmd("nnoremap <silent> <Leader>+ :vertical resize +5<CR>")
vim.cmd("nnoremap <silent> <Leader>- :vertical resize -5<CR>")


lvim.keys.normal_mode = {
  -- empowered searches
  ['<leader>sT'] = "<cmd>Telescope current_buffer_fuzzy_find<CR>",
  ['<leader>sF'] = ':lua require("telescope.builtin").find_files({hidden=true, file_ignore_patterns = {"node_modules", "build", ".git"},  no_ignore=true, find_command=rg})<cr>',
  ['<leader>='] = "<cmd>NvimTreeResize +5<CR>",
  ['<leader>-'] = "<cmd>NvimTreeResize -5<CR>",
}

-- visual remaps that dont work?
lvim.keys.visual_mode = {
  ["<C-j>"] = ":m .+1<CR>gv-gv",
  ["<C-k>"] = ":m .-2<CR>gv-gv"
}


-- telescope
lvim.builtin.telescope.defaults.path_display = { "smart" }
lvim.builtin.telescope.defaults.file_ignore_patterns = { file_ignore_patterns = { "node_modules", "build", "/Library" } }
lvim.builtin.telescope.defaults.hidden = true



--require("user.which_key").config()


-- TODO: User Config for predefined plugins
-- After changing plugin config exit and reopen LunarVim, Run :PackerInstall :PackerCompile
-- lvim.builtin.dashboard.active = true
lvim.builtin.terminal.active = true
lvim.builtin.nvimtree.setup.view.side = "left"
lvim.builtin.nvimtree.show_icons.git = 1


-- if you don't want all the parsers change this to a table of the ones you want
lvim.builtin.treesitter.ensure_installed = {
  "bash",
  "javascript",
  "json",
  "lua",
  "python",
  "typescript",
  "css",
  "rust",
  "java",
}

lvim.builtin.treesitter.ignore_install = { "haskell" }
lvim.builtin.treesitter.highlight.enabled = true
lvim.builtin.treesitter.rainbow.enable = true

-- -- set a formatter, this will override the language server formatting capabilities (if it exists)
local formatters = require "lvim.lsp.null-ls.formatters"
formatters.setup {
  { exe = "black" },
  {
    exe = "prettier",
    args = { "--print-width", "120" },
    ---@usage specify which filetypes to enable. By default a providers will attach to all the filetypes it supports.
    filetypes = {
      "javascriptreact",
      "javascript",
      "typescriptreact",
      "typescript",
      "json",
      "markdown",
    },
  },
}

-- -- set additional linters
-- local linters = require "lvim.lsp.null-ls.linters"
--linters.setup {
--  { exe = "black" },
-- {
--    exe = "eslint_d",
--   ---@usage specify which filetypes to enable. By default a providers will attach to all the filetypes it supports.
--    filetypes = { "javascript", "javascriptreact", "typescript", "typescriptreact" },
--  },
--}

-- Additional Plugins
lvim.plugins = {
  { "folke/tokyonight.nvim" },
}
