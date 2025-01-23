return {
  {
    "williamboman/mason.nvim",
    dependencies = {
      "williamboman/mason-lspconfig.nvim",
      "neovim/nvim-lspconfig",
      "hrsh7th/cmp-nvim-lsp",
      "SmiteshP/nvim-navic",
    },
    config = function()
      require("mason").setup()
      require("mason-lspconfig").setup({
        ensure_installed = {
          "ts_ls",
          "lua_ls",
          "pylsp",
          "clangd",
          "r_language_server",
          "rust_analyzer",
          "volar",
        },
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
        vim.keymap.set("n", "K", vim.lsp.buf.hover, bufopts)
        -- vim.keymap.set("n", "<leader>f", function()
        --   vim.lsp.buf.format({ async = true })
        -- end, bufopts)
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

      lspconfig.ts_ls.setup({
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

      lspconfig.volar.setup({
        on_attach = on_attach,
        capabilities = capabilities,
      })

      vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, {
        border = "single",
      })
      vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signatureHelp, {
        border = "single",
      })
      vim.diagnostic.config({ float = { border = "single" } })
    end,
  },
}
