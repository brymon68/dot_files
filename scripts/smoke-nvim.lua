-- Integration check: isolated fixtures, real LSP initialization, and formatting.
-- DOTFILES_BOOTSTRAP=1 nvim --headless '+luafile scripts/smoke-nvim.lua'
local root = vim.fn.tempname()
local function run()
  vim.fn.mkdir(root, "p")
  vim.fn.writefile({ '[project]', 'name = "nvim-smoke"', 'version = "0.0.0"' }, root .. "/pyproject.toml")
  vim.fn.writefile({ '{}' }, root .. "/.luarc.json")
  vim.fn.writefile({ '{}' }, root .. "/tsconfig.json")
  vim.fn.writefile({ 'module example.com/nvim-smoke', '', 'go 1.22' }, root .. "/go.mod")
  local cases = {
    { "main.py", "pyright", { "value=1", "print(value)" } },
    { "main.lua", "lua-ls", { "local value=1", "print(value)" } },
    { "main.ts", "ts-ls", { "const value:number=1;", "console.log(value);" } },
    { "main.go", "gopls", { "package main", "func main(){println(1)}" } },
  }
  vim.cmd.cd(vim.fn.fnameescape(root))
  for _, case in ipairs(cases) do
    local path = root .. "/" .. case[1]
    vim.fn.writefile(case[3], path)
    vim.cmd.edit(vim.fn.fnameescape(path))
    local bufnr = vim.api.nvim_get_current_buf()
    assert(vim.wait(90000, function()
      for _, client in ipairs(vim.lsp.get_clients({ bufnr = bufnr })) do
        if client.name == case[2] and client.initialized then return true end
      end
      return false
    end, 100), "LSP did not initialize: " .. case[2])
    assert(vim.treesitter.highlighter.active[bufnr], "Highlighting missing: " .. case[1])
    local before = table.concat(vim.api.nvim_buf_get_lines(bufnr, 0, -1, false), "\n")
    local format_error
    require("conform").format({ bufnr = bufnr, async = false, timeout_ms = 10000, lsp_format = "never" }, function(err)
      format_error = err
    end)
    assert(not format_error, tostring(format_error))
    local after = table.concat(vim.api.nvim_buf_get_lines(bufnr, 0, -1, false), "\n")
    assert(before ~= after, "Formatter did not change unformatted fixture: " .. case[1])
    print("PASS " .. case[1] .. ": LSP, syntax highlighting, formatting")
    vim.bo.modified = false
  end
end
local ok, err = xpcall(run, debug.traceback)
for _, client in ipairs(vim.lsp.get_clients()) do client:stop(true) end
vim.fn.delete(root, "rf")
if not ok then
  io.stderr:write(err .. "\n")
  vim.cmd("cquit 1")
end
vim.cmd("qa!")
