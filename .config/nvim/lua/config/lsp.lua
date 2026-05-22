-- LSP servers are defined in lsp/<name>.lua and installed via Mason.
-- Run :checkhealth vim.lsp to inspect attached clients and capabilities.

-- Apply blink.cmp completion capabilities to every server.
vim.lsp.config("*", {
  capabilities = require("blink.cmp").get_lsp_capabilities(),
})

vim.lsp.enable({
  "pyright",
  "lua-ls",
  "gopls",
  "ts-ls",
})

vim.diagnostic.config({
  virtual_text = true,
  underline = true,
  update_in_insert = false,
  severity_sort = true,
  float = {
    border = "rounded",
    source = true,
  },
  signs = {
    text = {
      [vim.diagnostic.severity.ERROR] = "󰅚 ",
      [vim.diagnostic.severity.WARN] = "󰀪 ",
      [vim.diagnostic.severity.INFO] = "󰋽 ",
      [vim.diagnostic.severity.HINT] = "󰌶 ",
    },
    numhl = {
      [vim.diagnostic.severity.ERROR] = "ErrorMsg",
      [vim.diagnostic.severity.WARN] = "WarningMsg",
    },
  },
})

-- Restart LSP clients attached to the current buffer.
vim.api.nvim_create_user_command("LspRestart", function()
  for _, client in ipairs(vim.lsp.get_clients({ bufnr = 0 })) do
    vim.lsp.stop_client(client.id)
  end
  vim.defer_fn(function()
    vim.cmd("edit")
  end, 100)
end, { desc = "Restart LSP clients for current buffer" })
