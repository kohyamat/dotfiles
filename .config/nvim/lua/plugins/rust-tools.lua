return {
  "mrcjkb/rustaceanvim",
  lazy = false,
  dependencies = { "neovim/nvim-lspconfig" },
  config = function()
    local mason_registry = require("mason-registry")
    local codelldb_root = mason_registry.get_package("codelldb"):get_install_path() .. "/extension/"
    local codelldb_path = codelldb_root .. "adapter/codelldb"
    local liblldb_path = codelldb_root .. "lldb/lib/liblldb.so"

    local cfg = require("rustaceanvim.config")
    vim.g.rustaceanvim = {
      tools = {
        hover_actions = {
          auto_focus = true,
        },
      },
      server = {
        on_attach = function(client, bufnr)
        end,
        ["rust-analyzer"] = {
        },
      },
      dap = {
        adapter = cfg.get_codelldb_adapter(codelldb_path, liblldb_path),
      },
    }
  end,
}
