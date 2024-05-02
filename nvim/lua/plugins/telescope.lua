return {
  "nvim-telescope/telescope.nvim",
  cmd = "Telescope",
  lazy = true,
  config = function()
    local telescope = require("telescope")
    telescope.setup({
      defaults = {
        path_display = {
          "filename_first",
        },
      },
    })
  end,
  keys = {
    -- disable the keymap to grep files
    { "<leader>/", false },
    -- change a keymap
    { "<leader>ff", "<cmd>Telescope find_files<cr>", desc = "Find Files" },
  },
}
