return {
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      "saghen/blink.cmp",
      "williamboman/mason.nvim",
      "williamboman/mason-lspconfig.nvim",
    },

    opts = {
      servers = {
        lua_ls = {},
        gopls = {},
        cssls = {},
        ts_ls = {},
        pyright = {},
      },
    },
    config = function(_, opts)
      -- Function to show diagnostics and copy to clipboard
      local function show_and_copy_diagnostic()
        -- Get diagnostics at current cursor position
        local line = vim.fn.line(".") - 1
        local diagnostics = vim.diagnostic.get(0, { lnum = line })

        -- Show the floating diagnostic window
        vim.diagnostic.open_float()

        -- If diagnostics exist, copy them to clipboard
        if #diagnostics > 0 then
          local diagnostic_messages = {}
          for _, diagnostic in ipairs(diagnostics) do
            table.insert(diagnostic_messages, diagnostic.message)
          end
          -- Join all diagnostic messages with newlines
          local clipboard_text = table.concat(diagnostic_messages, "\n")
          -- Copy to system clipboard
          vim.fn.setreg("+", clipboard_text)
        end
      end
      local lspconfig = require("lspconfig")
      for server, config in pairs(opts.servers) do
        -- passing config.capabilities to blink.cmp merges with the capabilities in your
        -- `opts[server].capabilities, if you've defined it
        config.capabilities = require("blink.cmp").get_lsp_capabilities(config.capabilities)
        lspconfig[server].setup(config)
      end

      vim.api.nvim_create_autocmd("LspAttach", {
        desc = "LSP actions",
        callback = function(event)
          local opts = { buffer = event.buf }

          vim.keymap.set("n", "K", "<cmd>lua vim.lsp.buf.hover()<cr>", opts)
          vim.keymap.set("n", "gl", show_and_copy_diagnostic, opts)
        end,
      })

      require("mason").setup()
      require("mason-lspconfig").setup({
        automatic_installation = true,
        ensure_installed = {
          "cssls",
          "gopls",
          "lua_ls",
          "ts_ls",
          "pyright",
        },
      })
      require("mason-lspconfig").setup_handlers({
        function(server_name) -- default handler (optional)
          require("lspconfig")[server_name].setup({})
        end,
        ["lua_ls"] = function()
          require("lspconfig").lua_ls.setup({
            settings = {
              Lua = {
                diagnostics = {
                  globals = { "vim" },
                },
              },
            },
            capabilities = require("blink.cmp").get_lsp_capabilities(),
          })
        end,
      })
    end,
  },
  {
    'saghen/blink.cmp',
    -- optional: provides snippets for the snippet source
    dependencies = { 'rafamadriz/friendly-snippets' },

    -- use a release tag to download pre-built binaries
    version = '1.*',
    -- AND/OR build from source, requires nightly: https://rust-lang.github.io/rustup/concepts/channels.html#working-with-nightly-rust
    -- build = 'cargo build --release',
    -- If you use nix, you can build from source using latest nightly rust with:
    -- build = 'nix run .#build-plugin',

    ---@module 'blink.cmp'
    ---@type blink.cmp.Config
    opts = {
      -- 'default' (recommended) for mappings similar to built-in completions (C-y to accept)
      -- 'super-tab' for mappings similar to vscode (tab to accept)
      -- 'enter' for enter to accept
      -- 'none' for no mappings
      --
      -- All presets have the following mappings:
      -- C-space: Open menu or open docs if already open
      -- C-n/C-p or Up/Down: Select next/previous item
      -- C-e: Hide menu
      -- C-k: Toggle signature help (if signature.enabled = true)
      --
      -- See :h blink-cmp-config-keymap for defining your own keymap
      keymap = { preset = 'default' },

      appearance = {
        -- 'mono' (default) for 'Nerd Font Mono' or 'normal' for 'Nerd Font'
        -- Adjusts spacing to ensure icons are aligned
        nerd_font_variant = 'mono'
      },

      -- (Default) Only show the documentation popup when manually triggered
      completion = {
        menu = { border = 'single' },
        documentation = {
          auto_show = true,
          window = { border = 'single' }
        }
      },

      -- Default list of enabled providers defined so that you can extend it
      -- elsewhere in your config, without redefining it, due to `opts_extend`
      sources = {
        default = { 'lsp', 'path', 'snippets', 'buffer' },
      },

      -- (Default) Rust fuzzy matcher for typo resistance and significantly better performance
      -- You may use a lua implementation instead by using `implementation = "lua"` or fallback to the lua implementation,
      -- when the Rust fuzzy matcher is not available, by using `implementation = "prefer_rust"`
      --
      -- See the fuzzy documentation for more information
      fuzzy = {
        implementation = "prefer_rust_with_warning",
        sorts = {
          function(a, _)
            if a.label:sub(1, 1) == "_" ~= a.label:sub(1, 1) == "_" then
              -- return true to sort `a` after `b`, and vice versa
              return not a.label:sub(1, 1) == "_"
            end
            -- nothing returned, fallback to the next sort
          end,
          -- default sorts
          'score',
          'label',
          'sort_text',
        }
      }
    },
    opts_extend = { "sources.default" }
  }
}
