return {
  {
    "williamboman/mason.nvim",
    dependencies = {
      "williamboman/mason-lspconfig.nvim",
      "neovim/nvim-lspconfig",
      "hrsh7th/cmp-nvim-lsp",
      "SmiteshP/nvim-navic",
      "saghen/blink.cmp"
    },
    config = function()
      local enable_servers = {
        "lua_ls",
        "ts_ls",
        "pylsp",
        "clangd",
        "r_language_server",
        "rust_analyzer",
        "vue_ls",
      }

      require("mason").setup()
      require("mason-lspconfig").setup({
        ensure_installed = enable_servers,
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
        vim.keymap.set("n", "K", vim.lsp.buf.hover, bufopts)
        -- vim.keymap.set("n", "<leader>f", function()
        --   vim.lsp.buf.format({ async = true })
        -- end, bufopts)
      end
      -- local capabilities = require("cmp_nvim_lsp").default_capabilities()
      local capabilities = require("blink.cmp").get_lsp_capabilities()

      vim.lsp.config("*", {
        on_attach = on_attach,
        capabilities = capabilities,
      })

      -- enable servers
      vim.lsp.enable("lua_ls")
      vim.lsp.enable("ts_ls")
      vim.lsp.enable("pylsp")
      vim.lsp.enable("clangd")
      vim.lsp.enable("r_language_server")
      vim.lsp.enable("rust_analyzer")
      vim.lsp.enable("vue_ls")

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
