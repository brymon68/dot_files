local blink = require("blink.cmp")

---@type vim.lsp.Config
return {
  cmd = function(dispatchers, config)
    local cmd = 'tsgo'
    local local_cmd = (config or {}).root_dir and config.root_dir .. '/node_modules/.bin/tsgo'
    if local_cmd and vim.fn.executable(local_cmd) == 1 then
      cmd = local_cmd
    end
    return vim.lsp.rpc.start({ cmd, '--lsp', '--stdio' }, dispatchers)
  end,
  filetypes = {
    'javascript',
    'javascriptreact',
    'typescript',
    'typescriptreact',
  },
  root_dir = function(bufnr, on_dir)
    local root_markers = { 'package-lock.json', 'pnpm-lock.yaml', 'bun.lockb', 'bun.lock' }
    root_markers = vim.fn.has('nvim-0.11.3') == 1 and { root_markers, { '.git' } }
      or vim.list_extend(root_markers, { '.git' })

    local project_root = vim.fs.root(bufnr, root_markers)
    on_dir(project_root or vim.fn.getcwd())
  end,
  settings = {
    typescript = {
      inlayHints = {
        parameterNames = {
          enabled = 'literals',
          suppressWhenArgumentMatchesName = true,
        },
        parameterTypes = { enabled = true },
        variableTypes = { enabled = true },
        propertyDeclarationTypes = { enabled = true },
        functionLikeReturnTypes = { enabled = true },
        enumMemberValues = { enabled = true },
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
