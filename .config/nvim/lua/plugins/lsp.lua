return {
  {
    "williamboman/mason.nvim",
    config = function()
      require("mason").setup({})
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
          elseif server_name == "pyright" then
            opts.settings = {
              python = {
                analysis = {
                  autoSearchPaths = true,
                  useLibraryCodeForTypes = true,
                  diagnosticMode = "openFilesOnly",
                },
              },
            }
          end
          require("lspconfig")[server_name].setup(opts)
        end,
      }
      require("mason-lspconfig").setup_handlers(handlers)
    end,
    dependencies = {
      "williamboman/mason-lspconfig.nvim",
      "neovim/nvim-lspconfig",
      "hrsh7th/cmp-nvim-lsp",
    },
  },
}
