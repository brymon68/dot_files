-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
-- Add any additional autocmds here
--
local api = vim.api

-- don't auto comment new line
api.nvim_create_autocmd("BufEnter", { command = [[set formatoptions-=cro]] })

-- Function to open a hover window to the right of the cursor
function open_hover_window()
  local opts = {
    relative = "cursor", -- Position relative to the cursor
    row = 0, -- Keep the same row as cursor
    col = 1, -- Move right by one column (to the right of cursor)
    width = 80, -- Width of the hover window
    height = 10, -- Height of the hover window
    style = "minimal", -- Minimal border and no title
  }
  local buf = vim.api.nvim_create_buf(false, true)
  local win = vim.api.nvim_open_win(buf, true, opts)
  -- You can customize the window content here
end

-- Set up autocmd to trigger the hover window
vim.api.nvim_command("autocmd FileType lsp_hover lua open_hover_window()")
