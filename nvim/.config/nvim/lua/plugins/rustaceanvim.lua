return {
  "mrcjkb/rustaceanvim",
  version = "^5", -- 推奨されるメジャーバージョン指定
  lazy = false,
  ft = { "rust" },
  config = function()
    local codelldb_root = vim.fn.stdpath("data") .. "/mason/packages/codelldb/extension/"
    local codelldb_path = codelldb_root .. "adapter/codelldb"
    local liblldb_path = codelldb_root .. "lldb/lib/liblldb.dylib" -- Darwin (Mac) の場合は .dylib

    -- OS判定（Linuxの場合は .so）
    if vim.loop.os_uname().sysname ~= "Darwin" then
      liblldb_path = codelldb_root .. "lldb/lib/liblldb.so"
    end

    local cfg = require("rustaceanvim.config")

    vim.g.rustaceanvim = {
      tools = {
        hover_actions = {
          border = "rounded",
          auto_focus = false,
        },
      },
      server = {
        -- LSPの設定は lspconfig の流儀に合わせる
        on_attach = function(client, bufnr)
          -- 標準的なLSPキーバインド (lsp.luaと同じもの)
          local bufopts = { silent = true, buffer = bufnr }
          vim.keymap.set("n", "gd", vim.lsp.buf.definition, bufopts)
          vim.keymap.set("n", "gr", vim.lsp.buf.references, bufopts)
          vim.keymap.set("n", "K", vim.lsp.buf.hover, bufopts)
          vim.keymap.set("n", "<leader>ca", function() vim.cmd.RustLsp("codeAction") end, { desc = "Rust Code Action", buffer = bufnr })

          -- Rust固有のデバッグ支援
          vim.keymap.set("n", "<leader>dr", function() vim.cmd.RustLsp("debuggables") end, { desc = "Rust Debuggables", buffer = bufnr })
        end,
        default_settings = {
          ["rust-analyzer"] = {
            checkOnSave = {
              command = "clippy",
            },
          },
        },
      },
      dap = {
        adapter = cfg.get_codelldb_adapter(codelldb_path, liblldb_path),
      },
    }
  end,
}
