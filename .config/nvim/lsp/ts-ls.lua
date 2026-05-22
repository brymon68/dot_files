return {
  cmd = { "typescript-language-server", "--stdio" },
  filetypes = {
    "javascript",
    "javascriptreact",
    "typescript",
    "typescriptreact",
    "typescript.tsx",
  },
  root_markers = { "tsconfig.json", "jsconfig.json", "package.json", ".git" },
  settings = {
    typescript = {
      -- Remove tsdk setting to allow auto-detection
      tsserver = {
        useSyntaxServer = false,
      },
      inlayHints = {
        includeInlayParameterNameHints = 'none',
        includeInlayParameterNameHintsWhenArgumentMatchesName = false,
        includeInlayFunctionParameterTypeHints = false,
        includeInlayVariableTypeHints = false,
        includeInlayVariableTypeHintsWhenTypeMatchesName = false,
        includeInlayPropertyDeclarationTypeHints = false,
        includeInlayFunctionLikeReturnTypeHints = false,
        includeInlayEnumMemberValueHints = false,
      },
    },
    javascript = {
      -- Remove tsdk setting to allow auto-detection
    },
  },
}
