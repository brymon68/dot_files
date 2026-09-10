-- Run with nvim --headless -l after Lazy restore. Fail on incomplete setup.
local function run()
  -- Neovim's -l script mode disables plugins unless explicitly re-enabled.
  vim.go.loadplugins = true
  dofile(vim.env.DOTFILES_REPO .. "/.config/nvim/init.lua")
  local config = require("lazy.core.config")
  local lock = vim.json.decode(table.concat(vim.fn.readfile(config.options.lockfile), "\n"))
  for name, plugin in pairs(config.plugins) do
    if plugin.url then
      local head = vim.fn.system({ "git", "-C", plugin.dir, "rev-parse", "HEAD" }):gsub("%s+$", "")
      assert(vim.v.shell_error == 0, "Plugin missing: " .. name)
      assert(lock[name] and head == lock[name].commit, "Plugin differs from lockfile: " .. name)
    end
  end
  local registry = require("mason-registry")
  local refreshed, refresh_ok = false, false
  registry.refresh(function(ok) refresh_ok, refreshed = ok, true end)
  assert(vim.wait(120000, function() return refreshed end, 100), "Mason registry refresh timed out")
  assert(refresh_ok, "Mason registry refresh failed")
  local spec = require("plugins.mason")[1]
  local pending, failed = 0, {}
  for _, name in ipairs(spec.opts.ensure_installed) do
    local package = registry.get_package(name)
    if not package:is_installed() then
      pending = pending + 1
      package:install():once("closed", vim.schedule_wrap(function()
        if not package:is_installed() then table.insert(failed, name) end
        pending = pending - 1
      end))
    end
  end
  assert(vim.wait(900000, function() return pending == 0 end, 200), "Mason installs timed out; see :MasonLog")
  assert(#failed == 0, "Mason installs failed: " .. table.concat(failed, ", ") .. "; see :MasonLog")
  local languages = require("config.treesitter-languages")
  require("nvim-treesitter").install(languages):wait(300000)
  for _, lang in ipairs(languages) do
    assert(vim.treesitter.language.add(lang), "Missing parser: " .. lang)
  end
  for _, bin in ipairs({ "rg", "fd", "tree-sitter", "node", "npm", "gofmt", "pyright-langserver", "lua-language-server", "gopls", "typescript-language-server", "stylua", "ruff", "oxfmt", "oxlint", "isort", "goimports" }) do
    assert(vim.fn.executable(bin) == 1, "Missing executable: " .. bin)
  end
  print("Verified locked plugins, all configured parsers, and Mason tools.")
end
local ok, err = xpcall(run, debug.traceback)
if not ok then
  io.stderr:write(err .. "\n")
  vim.cmd("cquit 1")
end
vim.cmd("qa!")
