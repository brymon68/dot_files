return {
  mode = { "n", "v" },
  w = { ":w!<CR>", "Save" },
  h = { ":nohlsearch<CR>", "No Highlight" },
  p = { require("telescope.builtin").lsp_document_symbols, "Document Symbols" },
  f = { require("config.utils").telescope_git_or_file, "Find Files (Root)" },
  W = { "<cmd>noautocmd w<cr>", "Save without formatting (noautocmd)" },
  l = {
    name = "+LSP",
    a = { vim.lsp.buf.code_action, "Code Action" },
    A = { vim.lsp.buf.range_code_action, "Range Code Actions" },
    s = { vim.lsp.buf.signature_help, "Display Signature Information" },
    r = { vim.lsp.buf.rename, "Rename all references" },
    f = { vim.lsp.buf.format, "Format" },
    i = { require("telescope.builtin").lsp_implementations, "Implementation" },
    l = { "<cmd>TroubleToggle document_diagnostics<cr>", "Document Diagnostics (Trouble)" },
    L = { "<cmd>TroubleToggle workspace_diagnostics<cr>", "Workspace Diagnostics (Trouble)" },
    w = { require("telescope.builtin").diagnostics, "Diagnostics" },
    -- t = { require("telescope").extensions.refactoring.refactors, "Refactor" },
    c = { require("config.utils").copyFilePathAndLineNumber, "Copy File Path and Line Number" },
  },
}
