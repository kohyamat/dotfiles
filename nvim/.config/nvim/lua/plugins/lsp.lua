return {
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      "williamboman/mason.nvim",
      "williamboman/mason-lspconfig.nvim",
      "saghen/blink.cmp",
    },
    config = function()
      -- Modern, fast server list optimized for uv
      local servers = {
        "lua_ls",
        "ts_ls",
        "clangd",
        "rust_analyzer",
        "r_language_server",
        "basedpyright", -- Better than pylsp for uv
        "ruff",         -- LSP version of ruff
        "vue_ls",
      }

      -- External tools
      local tools = { "prettier", "stylua", "shfmt" }

      require("mason").setup()
      local mr = require("mason-registry")
      mr.refresh(function()
        for _, tool in ipairs(tools) do
          local p = mr.get_package(tool)
          if not p:is_installed() then
            p:install()
          end
        end
      end)

      -- Helper to find Python path in uv/venv environments
      local function get_python_path(workspace)
        local util = require("lspconfig/util")
        local path = util.path
        local venv = path.join(workspace, ".venv")
        if path.is_dir(venv) then
          if vim.fn.has("win32") == 1 then
            return path.join(venv, "Scripts", "python.exe")
          end
          return path.join(venv, "bin", "python")
        end
        return vim.fn.exepath("python3") or vim.fn.exepath("python") or "python"
      end

      -- Common on_attach
      local on_attach = function(client, bufnr)
        local bufopts = { silent = true, buffer = bufnr }
        vim.keymap.set("n", "gi", vim.lsp.buf.implementation, bufopts)
        vim.keymap.set("n", "gD", vim.lsp.buf.declaration, bufopts)
        vim.keymap.set("n", "gd", vim.lsp.buf.definition, bufopts)
        vim.keymap.set("n", "gr", vim.lsp.buf.references, bufopts)
        vim.keymap.set("n", "K", function()
          vim.lsp.buf.hover({ border = "rounded" })
        end, bufopts)
        vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, bufopts)
        vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, bufopts)
      end

      local capabilities = require("blink.cmp").get_lsp_capabilities()

      require("mason-lspconfig").setup({
        ensure_installed = servers,
        handlers = {
          function(server_name)
            require("lspconfig")[server_name].setup({
              on_attach = on_attach,
              capabilities = capabilities,
            })
          end,
          ["basedpyright"] = function()
            require("lspconfig").basedpyright.setup({
              on_attach = on_attach,
              capabilities = capabilities,
              before_init = function(_, config)
                config.settings.python.pythonPath = get_python_path(config.root_dir)
              end,
              settings = {
                basedpyright = {
                  analysis = {
                    autoSearchPaths = true,
                    useLibraryCodeForTypes = true,
                    diagnosticMode = "openFilesOnly",
                    typeCheckingMode = "basic",
                  },
                },
              },
            })
          end,
          ["ruff"] = function()
            require("lspconfig").ruff.setup({
              on_attach = function(client, bufnr)
                -- Disable hover in favor of Pyright
                client.server_capabilities.hoverProvider = false
                on_attach(client, bufnr)
              end,
              capabilities = capabilities,
            })
          end,
          ["lua_ls"] = function()
            require("lspconfig").lua_ls.setup({
              on_attach = on_attach,
              capabilities = capabilities,
              settings = {
                Lua = {
                  diagnostics = { globals = { "vim" } },
                },
              },
            })
          end,
        },
      })

      vim.diagnostic.config({
        virtual_text = { prefix = "●" },
        signs = true,
        underline = true,
        severity_sort = true,
        float = {
          border = "rounded",
          source = "always",
        },
      })
    end,
  },
}
