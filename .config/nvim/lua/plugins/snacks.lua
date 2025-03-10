return {
  "folke/snacks.nvim",
  priority = 1000,
  lazy = false,
  ---@type snacks.Config
  opts = {
    bigfile = { enabled = true },
    explorer = {
      enabled = true,
    },
    quickfile = { enabled = true },
    scroll = { enabled = true },
    picker = {
      sources = {
        explorer = {
          layout = {
            layout = {
              position = "right",
            },
          },
        }
      }
    }
  },
  keys = {
    { "<leader>ff", function() Snacks.picker.files() end,   desc = "Find Files" },
    { "<leader>fs", function() Snacks.picker.grep() end,    desc = "Grep" },
    { "<leader>fh", function() Snacks.picker.help() end,    desc = "Help Pages" },
    { "<leader>fk", function() Snacks.picker.keymaps() end, desc = "Keymaps" },
    {
      "<leader>e",
      function()
        Snacks.explorer({
          git_status = true,
          hidden     = true,
          layout     = {
            position = "right",
          }
        })
      end,
      desc = "File Explorer"
    },
  }

}
