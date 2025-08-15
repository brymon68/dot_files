local blink = require("blink.cmp")

local function get_python_path()
  local cwd = vim.fn.getcwd()
  local venv_path = cwd .. "/.venv"
  if vim.fn.isdirectory(venv_path) == 1 then
    return venv_path .. "/bin/python"
  end
  
  local handle = io.popen("poetry env info --path 2>/dev/null")
  if handle then
    local result = handle:read("*a")
    handle:close()
    if result and result ~= "" then
      local poetry_venv = result:gsub("%s+", "")
      return poetry_venv .. "/bin/python"
    end
  end
  
  return vim.fn.exepath("python")
end

return {
  cmd = { 'pyright-langserver', '--stdio' },
  filetypes = { 'python' },
  root_markers = { 'pyproject.toml', 'setup.py', '.git' },
  settings = {
    python = {
      pythonPath = get_python_path(),
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
