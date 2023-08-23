--[[
lvim is the global options object

Linters should be
filled in as strings with either
a global executable or a path to
an executable
]]
-- THESE ARE EXAMPLE CONFIGS FEEL FREE TO CHANGE TO WHATEVER YOU WANT

-- general
lvim.log.level = "warn"
lvim.format_on_save.enabled = true
lvim.colorscheme = "onedark"
vim.o.timeoutlen = 300
-- to disable icons and use a minimalist setup, uncomment the following
-- lvim.use_icons = false
lvim.transparent_window = true

-- keymappings [view all the defaults by pressing <leader>Lk]
lvim.leader = "space"
-- add your own keymapping
lvim.keys.normal_mode["<S-h>"] = false
lvim.keys.normal_mode["<S-l>"] = false
lvim.keys.normal_mode["gp"] = ":lua require('goto-preview').goto_preview_type_definition()<cr>"
lvim.keys.normal_mode["gw"] = ":lua require('goto-preview').close_all_win()<cr>"
lvim.keys.normal_mode["<leader>-"] = ":vertical resize -5<cr>"
lvim.keys.normal_mode["<leader>="] = ":vertical resize +5<cr>"
lvim.keys.normal_mode["<S-l>"] = ":bnext<cr>"
lvim.keys.normal_mode["<S-h>"] = ":bprevious<cr>"
lvim.keys.term_mode["<ESC>"] = "<C-\\><C-N><CR>"


-- telescope
lvim.builtin.telescope.pickers.find_files = nil
lvim.builtin.telescope.pickers.live_grep = nil
lvim.builtin.telescope.defaults.file_ignore_patterns = {
  ".git/",
  "target/",
  "docs/",
  "__pycache__/*",
  "node_modules/*",
  ".github/",
  "build/",
  "env/",
  "node_modules/",
}
-- lvim.builtin.telescope.defaults.layout_config.width = .95
-- lvim.builtin.telescope.defaults.layout_config.height = .60
lvim.builtin.telescope.defaults.layout_config = {
  width = 0.9,
  height = 0.8,
  preview_height = 0.78,
  horizontal = {
    prompt_position = "top",
    preview_width = .6
  }
}
lvim.builtin.telescope.defaults.layout_strategy = "horizontal"
lvim.builtin.telescope.defaults.layout_config.preview_cutoff = 120



--alpha
lvim.builtin.alpha.dashboard.section.header.val = {
  [[                              __ __       __     ]],
  [[         __                  _\ \\ \__   /' \    ]],
  [[ __  __ /\_\    ___ ___     /\__  _  _\ /\_, \   ]],
  [[/\ \/\ \\/\ \ /' __` __`\   \/_L\ \\ \L \/_/\ \  ]],
  [[\ \ \_/ |\ \ \/\ \/\ \/\ \    /\_   _  \   \ \ \ ]],
  [[ \ \___/  \ \_\ \_\ \_\ \_\   \/_/\_\\_/    \ \_\]],
  [[  \/__/    \/_/\/_/\/_/\/_/      \/_//_/     \/_/]],
}
lvim.builtin.alpha.dashboard.section.buttons.entries = {
  { "p", "  Recent projects",                "<cmd>lua require('telescope').extensions.projects.projects()<CR>" },
  { "n", lvim.icons.ui.NewFile .. "  New File", "<CMD>ene!<CR>" },
  { "f", lvim.icons.ui.FindFile .. "  Find File",
    '<cmd>lua require("telescope.builtin").find_files { find_command = { "rg", "--color=never", "--files" }, }<CR>' },
  { "t", "  Search text",              ":Telescope live_grep <CR>" },
  { "e", "  Edit Configuration",       "<CMD>edit " .. require("lvim.config"):get_user_config_path() .. " <CR>" },
  { "q", lvim.icons.ui.Close .. "  Quit", ":qa<CR>" }
}


-- Use which-key to add extra bindings with the leader-key prefix
lvim.builtin.which_key.mappings["t"] = {
  name = "+Trouble",
  r = { "<cmd>Trouble lsp_references<cr>", "References" },
  f = { "<cmd>Trouble lsp_definitions<cr>", "Definitions" },
  d = { "<cmd>Trouble document_diagnostics<cr>", "Diagnostics" },
  q = { "<cmd>Trouble quickfix<cr>", "QuickFix" },
  l = { "<cmd>Trouble loclist<cr>", "LocationList" },
  w = { "<cmd>Trouble workspace_diagnostics<cr>", "Workspace Diagnostics" },
}
lvim.builtin.which_key.mappings['f'] = {}
lvim.builtin.which_key.mappings['W'] = ":set warp!<cr>"
lvim.builtin.which_key.mappings['f'] = {
  name = "Find",
  b = { "<cmd>Telescope current_buffer_fuzzy_find<cr>", "Buffer fuzzyfind" },
  c = { "<cmd>Telescope colorscheme<cr>", "Colorscheme" },
  d = { "<cmd>Telescope diagnostics bufnr=0<cr>", "Diganostics" },
  f = {
    '<cmd>lua require("telescope.builtin").find_files { find_command = { "rg", "--color=never", "--files", "--hidden" }, }<cr>',
    "Find files",
  },
  g = { "<cmd>Telescope live_grep<cr>", "Find Text" },
  h = { "<cmd>Telescope help_tags<cr>", "Help" },
  l = { "<cmd>Telescope resume<cr>", "Last Search" },
  M = { "<cmd>Telescope man_pages<cr>", "Man Pages" },
  r = { "<cmd>Telescope oldfiles<cr>", "Recent File" },
  R = { "<cmd>Telescope registers<cr>", "Registers" },
  k = { "<cmd>Telescope keymaps<cr>", "Keymaps" },
  C = { "<cmd>Telescope commands<cr>", "Commands" },
}



-- After changing plugin config exit and reopen LunarVim, Run :PackerInstall :PackerCompile
-- TODO: User Config for predefined plugins
lvim.builtin.alpha.active = true
lvim.builtin.alpha.mode = "dashboard"
lvim.builtin.nvimtree.setup.view.side = "left"
lvim.builtin.nvimtree.setup.filters.custom = { ".git", "build", ".vscode", ".hypothesis", ".pytest_cache" }
lvim.builtin.nvimtree.setup.filters.exclude = { ".gitignore" }
lvim.builtin.nvimtree.setup.git.enable = true
lvim.builtin.terminal.active = true
lvim.builtin.nvimtree.setup.renderer.icons.show.git = false

-- if you don't want all the parsers change this to a table of the ones you want
lvim.builtin.treesitter.ensure_installed = {
  "bash",
  "javascript",
  "json",
  "lua",
  "python",
  "typescript",
  "tsx",
  "css",
  "rust",
  "yaml",
}

lvim.builtin.treesitter.ignore_install = { "haskell" }
lvim.builtin.treesitter.highlight.enable = true

--toggle term
lvim.builtin.terminal.open_mapping = "<c-t>"

-- generic LSP settings

-- -- make sure server will always be installed even if the server is in skipped_servers list
-- lvim.lsp.installer.setup.ensure_installed = {
--     "sumneko_lua",
--     "jsonls",
-- }
-- -- change UI setting of `LspInstallInfo`
-- -- see <https://github.com/williamboman/nvim-lsp-installer#default-configuration>
-- lvim.lsp.installer.setup.ui.check_outdated_servers_on_open = false
-- lvim.lsp.installer.setup.ui.border = "rounded"
-- lvim.lsp.installer.setup.ui.keymaps = {
--     uninstall_server = "d",
--     toggle_server_expand = "o",
-- }

-- ---@usage disable automatic installation of servers
-- lvim.lsp.installer.setup.automatic_installation = false

-- ---configure a server manually. !!Requires `:LvimCacheReset` to take effect!!
-- ---see the full default list `:lua print(vim.inspect(lvim.lsp.automatic_configuration.skipped_servers))`
-- vim.list_extend(lvim.lsp.automatic_configuration.skipped_servers, { "pyright" })
-- local opts = {} -- check the lspconfig documentation for a list of all possible options
-- require("lvim.lsp.manager").setup("pyright", opts)

-- ---remove a server from the skipped list, e.g. eslint, or emmet_ls. !!Requires `:LvimCacheReset` to take effect!!
-- ---`:LvimInfo` lists which server(s) are skipped for the current filetype
-- lvim.lsp.automatic_configuration.skipped_servers = vim.tbl_filter(function(server)
--   return server ~= "emmet_ls"
-- end, lvim.lsp.automatic_configuration.skipped_servers)

-- -- you can set a custom on_attach function that will be used for all the language servers
-- -- See <https://github.com/neovim/nvim-lspconfig#keybindings-and-completion>
-- lvim.lsp.on_attach_callback = function(client, bufnr)
--   local function buf_set_option(...)
--     vim.api.nvim_buf_set_option(bufnr, ...)
--   end
--   --Enable completion triggered by <c-x><c-o>
--   buf_set_option("omnifunc", "v:lua.vim.lsp.omnifunc")
-- end

-- -- set a formatter, this will override the language server formatting capabilities (if it exists)
local formatters = require "lvim.lsp.null-ls.formatters"
formatters.setup {
  { command = "black", filetypes = { "python" }, extra_args = { "--line-length", "60" } },
  -- { command = "isort", filetypes = { "python" } },
  {
    command = "prettier",
    filetypes = { "typescript", "javascript", "javascriptreact", "typescriptreact", "json" },
    args = { "--print-width", "100" }
  },
  {
    -- each formatter accepts a list of options identical to https://github.com/jose-elias-alvarez/null-ls.nvim/blob/main/doc/BUILTINS.md#Configuration
    command = "eslint",
    filetypes = { "typescript, typescriptreact" }
    ---@usage arguments to pass to the formatter
    -- these cannot contain whitespaces, options such as `--line-width 80` become either `{'--line-width', '80'}` or `{'--line-width=80'}`
    -- extra_args = { "--print-with", "100" },
    ---@usage specify which filetypes to enable. By default a providers will attach to all the filetypes it supports.
    -- filetypes = { "typescript", "typescriptreact" },
  },
}

-- -- set additional linters
-- local linters = require "lvim.lsp.null-ls.linters"
-- linters.setup {
--   { command = "flake8", filetypes = { "python" } },
--   {
--     -- each linter accepts a list of options identical to https://github.com/jose-elias-alvarez/null-ls.nvim/blob/main/doc/BUILTINS.md#Configuration
--     command = "shellcheck",
--     ---@usage arguments to pass to the formatter
--     -- these cannot contain whitespaces, options such as `--line-width 80` become either `{'--line-width', '80'}` or `{'--line-width=80'}`
--     extra_args = { "--severity", "warning" },
--   },
--   {
--     command = "codespell",
--     ---@usage specify which filetypes to enable. By default a providers will attach to all the filetypes it supports.
--     filetypes = { "javascript", "python" },
--   },
-- }

-- Additional Plugins
lvim.plugins = {
  {
    "brymon68/onedark.nvim",
  },
  {
    "folke/todo-comments.nvim",
    event = "BufRead",
    config = function()
      require("todo-comments").setup()
    end,
  },
  {
    "tpope/vim-surround",

    -- make sure to change the value of `timeoutlen` if it's not triggering correctly, see https://github.com/tpope/vim-surround/issues/117
    -- setup = function()
    --  vim.o.timeoutlen = 500
    -- end
  },
  {
    'rmagatti/goto-preview',
    config = function()
      require('goto-preview').setup {}
    end
  }

}

-- Autocommands (https://neovim.io/doc/user/autocmd.html)
-- vim.api.nvim_create_autocmd("BufEnter", {
--   pattern = { "*.json", "*.jsonc" },
--   -- enable wrap mode for json files only
--   command = "setlocal wrap",
-- })
-- vim.api.nvim_create_autocmd("FileType", {
--   pattern = "zsh",
--   callback = function()
--     -- let treesitter use bash highlight for zsh files as well
--     require("nvim-treesitter.highlight").attach(0, "bash")
-- })
--   end,
