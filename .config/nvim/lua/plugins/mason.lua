return {
	{
		"williamboman/mason.nvim",
		lazy = false, -- Load immediately to ensure PATH is set
		cmd = "Mason",
		build = ":MasonUpdate",
		opts = {
			ensure_installed = {
				-- LSP servers (matching your vim.lsp.enable() config)
				"pyright",
				"lua-language-server",
				"gopls",
				"typescript-language-server",
				"html-lsp",
				"css-lsp",

				-- Formatters (for conform.nvim and general use)
				"stylua",
				"goimports",
				-- Note: gofmt comes with Go installation, not managed by Mason
				"prettier",
				"black",
				"isort",

				-- Linters and diagnostics
				"eslint_d",
				"flake8",
			},
		},
		config = function(_, opts)
			-- PATH is handled by core.mason-path for consistency
			require("mason").setup(opts)

			-- Auto-install ensure_installed tools with better error handling
			local mr = require("mason-registry")
			local function ensure_installed()
				for _, tool in ipairs(opts.ensure_installed) do
					if mr.has_package(tool) then
						local p = mr.get_package(tool)
						if not p:is_installed() then
							vim.notify("Mason: Installing " .. tool .. "...", vim.log.levels.INFO)
							p:install():once("closed", function()
								if p:is_installed() then
									vim.notify("Mason: Successfully installed " .. tool, vim.log.levels.INFO)
								else
									vim.notify("Mason: Failed to install " .. tool, vim.log.levels.ERROR)
								end
							end)
						end
					else
						vim.notify("Mason: Package '" .. tool .. "' not found", vim.log.levels.WARN)
					end
				end
			end

			if mr.refresh then
				mr.refresh(ensure_installed)
			else
				ensure_installed()
			end
		end,
	},
}
