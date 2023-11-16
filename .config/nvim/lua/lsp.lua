require("mason").setup()
local mason_lspconfig = require("mason-lspconfig")
local lspconfig = require("lspconfig")
local capabilities = require("cmp_nvim_lsp").default_capabilities()

mason_lspconfig.setup({
  ensure_installed = { "lua_ls", "pyright", "r_language_server", "tsserver" },
})
mason_lspconfig.setup_handlers({
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
    opts.capabilities = capabilities
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
        single_file_support = true,
        settings = {
          pyright = {
            disableLanguageServices = false,
            disableOrganizeImports = false,
          },
          python = {
            analysis = {
              autoImportCompletions = true,
              autoSearchPaths = true,
              diagnosticMode = "workspace", -- openFilesOnly, workspace
              typeCheckingMode = "basic", -- off, basic, strict
              useLibraryCodeForTypes = true,
            },
          },
        },
      }
    end
    lspconfig[server_name].setup(opts)
  end,
})

local null_ls = require("null-ls")
null_ls.setup({
  -- debug = true,
  sources = {
    null_ls.builtins.formatting.stylua.with({
      -- prefer_local = "~/.cargo/bin",
      extra_args = { "--indent-type", "Spaces", "--indent-width", "2" },
    }),
    -- null_ls.builtins.formatting.prettier,
    null_ls.builtins.formatting.prettier.with({
      -- prefer_local = "~/.node_modules/bin",
      filetypes = {
        "javascript",
        "typescript",
        "css",
        "scss",
        "html",
        "vue",
        "json",
        "yaml",
        "markdown",
        "graphql",
        "md",
        "txt",
      },
    }),
    null_ls.builtins.diagnostics.eslint,
    null_ls.builtins.formatting.black.with({
      -- prefer_local = "~/.pyenv/shims",
      extra_args = { "-l", "88" },
    }),
    null_ls.builtins.formatting.isort.with({
      -- prefer_local = "~/.pyenv/shims",
      extra_args = { "-l", "88" },
    }),
    null_ls.builtins.formatting.styler,
    null_ls.builtins.formatting.beautysh,
  },
})
