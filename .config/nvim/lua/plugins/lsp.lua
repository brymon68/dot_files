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
        lua_ls = {
          settings = {
            Lua = {
              diagnostics = {
                globals = { "vim" },
              },
            },
          },
        },
        gopls = {},
        cssls = {},
        ts_ls = {},
        pyright = {},
      },
    },
    config = function(_, opts)
      -- 1. helper that adds cmp-capabilities
      local function with_cmp_capabilities(cfg)
        cfg = cfg or {}
        cfg.capabilities =
            require("blink.cmp").get_lsp_capabilities(cfg.capabilities)
        return cfg
      end

      ---------------------------------------------------------------------------
      -- 2. mason
      ---------------------------------------------------------------------------
      require("mason").setup()

      require("mason-lspconfig").setup({
        ensure_installed = {
          "cssls",
          "gopls",
          "lua_ls",
          "ts_ls",
          "pyright",
        },
      })

      -- 3. let mason-lspconfig do *all* the setup for us
      --    (this replaces your manual `for server in pairs()` loop!)
      require("mason-lspconfig").setup({
        -- default handler – runs for every installed server
        function(server_name)
          local cfg = vim.tbl_deep_extend(
            "force",
            {},                              -- start with an empty table
            opts.servers[server_name] or {}, -- user-config if any
            with_cmp_capabilities({})        -- cmp capabilities
          )
          require("lspconfig")[server_name].setup(cfg)
        end,
      })

      ---------------------------------------------------------------------------
      -- 4. misc keymap for diagnostics (unchanged)
      ---------------------------------------------------------------------------
      local function show_and_copy_diagnostic()
        local line = vim.fn.line(".") - 1
        local diagnostics = vim.diagnostic.get(0, { lnum = line })
        vim.diagnostic.open_float()
        if #diagnostics > 0 then
          local msgs = {}
          for _, d in ipairs(diagnostics) do
            table.insert(msgs, d.message)
          end
          vim.fn.setreg("+", table.concat(msgs, "\n"))
        end
      end

      vim.api.nvim_create_autocmd("LspAttach", {
        callback = function(ev)
          vim.keymap.set("n", "gl", show_and_copy_diagnostic, { buffer = ev.buf })
        end,
      })
    end
  },
  {
    'saghen/blink.cmp',
    -- optional: provides snippets for the snippet source
    dependencies = { 'rafamadriz/friendly-snippets', 'Kaiser-Yang/blink-cmp-avante', },

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
        default = { 'avante', 'lsp', 'path', 'snippets', 'buffer' },
        providers = {
          avante = {
            module = 'blink-cmp-avante',
            name = 'Avante',
            opts = {}
          }
        },
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
