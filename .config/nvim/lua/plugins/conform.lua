return {
  "stevearc/conform.nvim",
  event = { "BufReadPre", "BufWritePre" },
  config = function()
    local conform = require("conform")
    conform.setup({
      log_level = vim.log.levels.DEBUG,
      notify_on_error = true,
      formatters_by_ft = {
        javascript = { "prettier" },
        typescript = { "prettier" },
        javascriptreact = { "prettier" },
        typescriptreact = { "prettier" },
        go = { "gofmt" },
        css = { "prettier" },
        html = { "prettier" },
        json = { "prettier" },
        yaml = { "prettier" },
        markdown = { "prettier" },
        lua = { "stylua" },
        python = function(bufnr)
          if require("conform").get_formatter_info("ruff_format", bufnr).available then
            return { "ruff_format" }
          else
            return { "black" }
          end
        end,
      },
      format_on_save = {
        lsp_format = "fallback",
        async = false,
        timeout_ms = 3000,
      },
    })
  end,
}
