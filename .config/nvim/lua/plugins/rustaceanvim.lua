return {
  "mrcjkb/rustaceanvim",
  lazy = false,
  dependencies = { "neovim/nvim-lspconfig" },
  config = function()
    -- local mason_registry = require("mason-registry")
    -- mason_registry.get_package("codelldb"):get_install_path() .. "/extension/"
    local codelldb_root = vim.fn.stdpath("data") .. "/mason/packages/codelldb/extension/"
    local codelldb_path = codelldb_root .. "adapter/codelldb"
    local liblldb_path = codelldb_root .. "lldb/lib/liblldb.so"

    local cfg = require("rustaceanvim.config")
    local navic = require("nvim-navic")
    local rlsp = vim.cmd.RustLsp
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
      vim.keymap.set("n", "<leader>f", function()
        vim.lsp.buf.format({ async = true })
      end, bufopts)

      -- keymaps for rustaceanvim
      vim.keymap.set("n", "<leader>ca", function()
        rlsp("codeAction")
      end, { desc = "Code Action", buffer = bufnr })
      vim.keymap.set("n", "<leader>dr", function()
        rlsp("debuggables")
      end, { desc = "Rust Debuggables", buffer = bufnr })
      vim.keymap.set("n", "<leader>d", function()
        rlsp("debug")
      end, { desc = "Rust Debug", buffer = bufnr })
    end
    vim.g.rustaceanvim = {
      tools = {
        hover_actions = {
          border = {
            { "╭", "FloatBorder" },
            { "─", "FloatBorder" },
            { "╮", "FloatBorder" },
            { "│", "FloatBorder" },
            { "╯", "FloatBorder" },
            { "─", "FloatBorder" },
            { "╰", "FloatBorder" },
            { "│", "FloatBorder" },
          },
          auto_focus = false,
        },
      },
      server = {
        on_attach = on_attach,
        ["rust-analyzer"] = {
          checkOnSave = {
            command = "clippy",
          },
        },
      },
      dap = {
        adapter = cfg.get_codelldb_adapter(codelldb_path, liblldb_path),
      },
    }
  end,
}
