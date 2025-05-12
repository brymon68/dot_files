return {
  "github/copilot.vim",
  lazy = false,
  event = "VimEnter",
  init = function()
    vim.g.copilot_workspace_folders = { vim.fn.getcwd() }
  end,
  keys = {},
}
