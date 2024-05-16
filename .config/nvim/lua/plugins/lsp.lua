return {
  {
    "williamboman/mason.nvim",
    dependencies = {
      "williamboman/mason-lspconfig.nvim",
      "neovim/nvim-lspconfig",
      "hrsh7th/cmp-nvim-lsp",
      "SmiteshP/nvim-navic",

      -- { "simrat39/rust-tools.nvim", ft = "rust" },
    },
    config = function()
      require("mason").setup()
      require("mason-lspconfig").setup({
        ensure_installed = { "tsserver", "lua_ls", "pylsp", "clangd", "r_language_server", "rust_analyzer" },
      })

      local lspconfig = require("lspconfig")
      local navic = require("nvim-navic")
      local on_attach = function(client, bufnr)
        if client.server_capabilities.documentSymbolProvider then
          navic.attach(client, bufnr)
        end
        local bufopts = { silent = true, buffer = bufnr }
        vim.keymap.set("n", "gi", vim.lsp.buf.implementation, bufopts)
        vim.keymap.set("n", "gD", vim.lsp.buf.declaration, bufopts)
        vim.keymap.set("n", "gd", vim.lsp.buf.definition, bufopts)
        vim.keymap.set("n", "gr", vim.lsp.buf.references, bufopts)
        vim.keymap.set("n", "gh", vim.lsp.buf.signature_help, bufopts)
        vim.keymap.set("n", "gk", vim.lsp.buf.signature_help, bufopts)
        vim.keymap.set("n", "<leader>f", function()
          vim.lsp.buf.format({ async = true })
        end, bufopts)
      end
      local capabilities = require("cmp_nvim_lsp").default_capabilities()

      lspconfig.lua_ls.setup({
        on_attach = on_attach,
        capabilities = capabilities,
        settings = {
          Lua = {
            diagnostics = {
              globals = { "vim", "use" },
            },
          },
        },
      })

      lspconfig.pylsp.setup({
        on_attach = on_attach,
        capabilities = capabilities,
        settings = {
          pylsp = {
            configurationSources = { "flake8" },
            plugins = {
              flake8 = {
                enabled = true,
                maxLineLength = 120,
                -- extendIgnore = { "E203" },
              },
              pycodestyle = {
                enabled = false,
              },
              mccabe = {
                enabled = false,
              },
              pyflakes = {
                enabled = false,
              },
              yapf = {
                enabled = false,
              },
              autopep8 = {
                enabled = false,
              },
              pylsp_mypy = {
                enabled = true,
              },
              ruff = {
                enabled = false,
                -- extendSelect = { "I" },
              },
            },
          },
        },
      })

      lspconfig.tsserver.setup({
        on_attach = on_attach,
        capabilities = capabilities,
        settings = {
          init_options = {
            plugins = {
              {
                name = "@vue/typescript-plugin",
                location = "/usr/local/lib/node_modules/@vue/typescript-plugin",
                languages = { "javascript", "typescript", "vue" },
              },
            },
          },
          filetypes = {
            "javascript",
            "typescript",
            "vue",
          },
        },
      })

      lspconfig.clangd.setup({
        on_attach = on_attach,
        capabilities = capabilities,
      })

      lspconfig.r_language_server.setup({
        on_attach = on_attach,
        capabilities = capabilities,
      })

      local handlers = {
        function(server_name)
          local opts = {}
          opts.on_attach = function(_, bufnr)
            local bufopts = { silent = true, buffer = bufnr }
            vim.keymap.set("n", "gi", vim.lsp.buf.implementation, bufopts)
            vim.keymap.set("n", "gD", vim.lsp.buf.declaration, bufopts)
            vim.keymap.set("n", "gd", vim.lsp.buf.definition, bufopts)
            vim.keymap.set("n", "gr", vim.lsp.buf.references, bufopts)
            vim.keymap.set("n", "gh", vim.lsp.buf.signature_help, bufopts)
            vim.keymap.set("n", "gk", vim.lsp.buf.signature_help, bufopts)
            vim.keymap.set("n", "<leader>f", function()
              vim.lsp.buf.format({ async = true })
            end, bufopts)
          end
          opts.capabilities = require("cmp_nvim_lsp").default_capabilities()
          if server_name == "lua_ls" then
            opts.settings = {
              Lua = {
                diagnostics = {
                  globals = { "vim" },
                },
              },
            }
          elseif server_name == "pylsp" then
            opts.settings = {
              pylsp = {
                configurationSources = { "flake8" },
                plugins = {
                  flake8 = {
                    enabled = true,
                    maxLineLength = 120,
                    -- extendIgnore = { "E203" },
                  },
                  pycodestyle = {
                    enabled = false,
                  },
                  mccabe = {
                    enabled = false,
                  },
                  pyflakes = {
                    enabled = false,
                  },
                  yapf = {
                    enabled = false,
                  },
                  autopep8 = {
                    enabled = false,
                  },
                  pylsp_mypy = {
                    enabled = true,
                  },
                  ruff = {
                    enabled = false,
                    -- extendSelect = { "I" },
                  },
                },
              },
            }
          elseif server_name == "tsserver" then
            opts.settings = {
              init_options = {
                plugins = {
                  {
                    name = "@vue/typescript-plugin",
                    location = "/usr/local/lib/node_modules/@vue/typescript-plugin",
                    languages = { "javascript", "typescript", "vue" },
                  },
                },
              },
              filetypes = {
                "javascript",
                "typescript",
                "vue",
              },
            }
          end
          require("lspconfig")[server_name].setup(opts)
        end,

        -- ["rust_analyzer"] = function()
        --   local rt = require("rust-tools")
        --
        --   rt.setup({
        --     server = {
        --       on_attach = function(_, bufnr)
        --         -- Hover actions
        --         vim.keymap.set("n", "<localleader><space>", rt.hover_actions.hover_actions, { buffer = bufnr })
        --         -- Code action groups
        --         vim.keymap.set("n", "<leader>a", rt.code_action_group.code_action_group, { buffer = bufnr })
        --       end,
        --     },
        --   })
        -- end,
      }
      -- require("mason-lspconfig").setup_handlers(handlers)
    end,
  },
}
