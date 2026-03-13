return {
  {
    "williamboman/mason.nvim",
    dependencies = {
      "williamboman/mason-lspconfig.nvim",
      "neovim/nvim-lspconfig",
      "SmiteshP/nvim-navic",
      "saghen/blink.cmp",
    },
    config = function()
      local servers = {
        "lua_ls",
        "ts_ls",
        "pylsp",
        "clangd",
        "r_language_server",
        "rust_analyzer",
        "vue_ls",
      }

      -- Formatters and Linters (Consolidated to Ruff for Python)
      local formatters = {
        "ruff", -- Replaces black, isort, flake8
        "prettier",
        "stylua",
        "shfmt",
      }

      require("mason").setup()
      local mr = require("mason-registry")
      local function ensure_installed()
        for _, tool in ipairs(formatters) do
          local p = mr.get_package(tool)
          if not p:is_installed() then
            p:install()
          end
        end
      end
      mr.refresh(ensure_installed)

      require("mason-lspconfig").setup({
        ensure_installed = servers,
      })

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
        vim.keymap.set("n", "K", function()
          vim.lsp.buf.hover({ border = "rounded" })
        end, bufopts)
      end

      local capabilities = require("blink.cmp").get_lsp_capabilities()

      vim.lsp.config("*", {
        on_attach = on_attach,
        capabilities = capabilities,
      })

      -- enable servers
      for _, server in ipairs(servers) do
        vim.lsp.enable(server)
      end
    end,
  },
}
