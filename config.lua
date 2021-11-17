-- THESE ARE EXAMPLj CONFIGS FEEL  FREE TO CHANGE TO WHATEVER YOU WANT
-- general
lvim.log.level = "warn"
lvim.format_on_save = true
lvim.colorscheme = "tokyonight"
lvim.transparent_window = false
-- general
vim.opt.pumheight = 12
vim.opt.wrap = false
vim.opt.smartindent  = true
vim.opt.modifiable = true

-- keymappings [view all the defaults by pressing <leader>Lk]
lvim.leader = "space"
lvim.keys.normal_mode = {
  ["<C-h>"] = ":wincmd h <cr>",
  ["<C-l>"] = ":wincmd l <cr>",
  ["U"] = "<C-r><cr>",
  ["<c-s>"] = ":w<cr>",
  ["<leader>U"] = ":UndotreeShow<Cr>"
}

vim.cmd("nnoremap <Down> <C-d>")
vim.cmd("nnoremap <silent> <Leader>+ :vertical resize +5<CR>")
vim.cmd("nnoremap <silent> <Leader>- :vertical resize -5<CR>")


-- telescope
lvim.builtin.telescope.defaults.path_display = { "smart" }
lvim.builtin.telescope.defaults.file_ignore_patterns = { file_ignore_patterns = {"node_modules", "build", "/Library"} }
lvim.builtin.telescope.defaults.hidden = true
lvim.keys.normal_mode = {
   -- empowered searches
    ['<leader>sT'] = "<cmd>Telescope current_buffer_fuzzy_find<CR>",
    ['<leader>sF'] = ':lua require("telescope.builtin").find_files({hidden=true, no_ignore=true, find_command=rg})<cr>',

}

require("user.which_key").config()
-- lvim.builtin.which_key.mappings["r"] = {
--   name = "Replace",
--   r = { "<cmd>lua require('spectre').open()<cr>", "Replace" },
--   w = { "<cmd>lua require('spectre').open_visual({select_word=true}) --multiline<cr>", "Replace Word" },
--   f = { "<cmd>lua require('spectre').open_file_search()<cr>", "Replace Buffer" },
-- }
-- lvim.builtin.which_key.mappings["v"] = {
--   "<cmd>vsp<cr>", "Vertical split"
-- }


-- TODO: User Config for predefined plugins
-- After changing plugin config exit and reopen LunarVim, Run :PackerInstall :PackerCompile
lvim.builtin.dashboard.active = true
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
  "yaml",
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
    {"folke/tokyonight.nvim"},
    {"mbbill/undotree"},
    {"jremmen/vim-ripgrep"},
    {"junegunn/fzf.vim"},
    {"windwp/nvim-spectre"},
    {
      "folke/trouble.nvim",
      cmd = "TroubleToggle",
    },

}
