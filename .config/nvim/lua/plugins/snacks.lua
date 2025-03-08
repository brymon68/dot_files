return {
  "folke/snacks.nvim",
  priority = 1000,
  lazy = false,
  ---@type snacks.Config
  opts = {
    -- your configuration comes here
    -- or leave it empty to use the default settings
    -- refer to the configuration section below
    bigfile = { enabled = true },
    explorer = { enabled = true },
    quickfile = { enabled = true },
    scroll = { enabled = true },
  },
  keys = {
    { "<leader>ff", function() Snacks.picker.files() end,   desc = "Find Files" },
    { "<leader>fs", function() Snacks.picker.grep() end,    desc = "Grep" },
    { "<leader>fh", function() Snacks.picker.help() end,    desc = "Help Pages" },
    { "<leader>fk", function() Snacks.picker.keymaps() end, desc = "Keymaps" },
    { "<leader>e",  function() Snacks.explorer() end,       desc = "File Explorer" },
  }

}
