local blink = require("blink.cmp")
return {
  cmd = { 'pyright-langserver', '--stdio' },
  filetypes = { 'python' },
  root_markers = { 'pyproject.toml', 'setup.py', '.git' },
  settings = {
    python = {
      analysis = {
        typeCheckingMode = 'basic',
        autoSearchPaths = true,
        useLibraryCodeForTypes = true,
        diagnosticMode = 'workspace',
        diagnosticSeverityOverrides = {
          reportMissingImports = 'warning',
          reportMissingModuleSource = 'warning',
          reportImportCycles = 'warning',
          reportUnusedImport = 'warning',
          reportUnusedVariable = 'warning',
          reportUnusedClass = 'warning',
          reportUnusedFunction = 'warning',
          reportUnusedPrivateClass = 'warning',
          reportUnusedPrivateFunction = 'warning',
        },
      },
    },
  },
  capabilities = vim.tbl_deep_extend(
    "force",
    {},
    vim.lsp.protocol.make_client_capabilities(),
    blink.get_lsp_capabilities()
  ),
}
