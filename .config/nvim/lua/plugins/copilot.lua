return {
  "github/copilot.vim",
  enable = false,
  event = "VimEnter",
  init = function()
    vim.g.copilot_enabled = 0
    vim.g.copilot_workspace_folders = { vim.fn.getcwd() }
  end,
  keys = {},
}
