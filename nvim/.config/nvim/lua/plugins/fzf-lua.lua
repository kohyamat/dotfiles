return {
  "ibhagwan/fzf-lua",
  dependencies = { "folke/trouble.nvim" },
  opts = {},
  config = function()
    local fzf = require("fzf-lua")
    local config = require("fzf-lua.config")
    local actions = require("trouble.sources.fzf").actions

    -- 検索結果のデフォルトアクションに Trouble を追加
    config.defaults.actions.files["ctrl-t"] = actions.open

    fzf.setup({
      -- 基本的な検索動作の設定
      keymap = {
        builtin = {
          ["<C-g>"] = "toggle-preview",
          ["<F1>"]  = "help",
        },
        fzf = {
          -- 移動
          ["ctrl-n"] = "down",
          ["ctrl-p"] = "up",
          ["ctrl-j"] = "down",
          ["ctrl-k"] = "up",
          -- プレビュー
          ["ctrl-u"] = "preview-page-up",
          ["ctrl-d"] = "preview-page-down",
          -- 選択と決定 (明示的に設定)
          ["enter"]  = "accept",
          ["tab"]    = "toggle-dt-sign", -- 複数選択の切り替え
          ["ctrl-a"] = "select-all",
        },
      },
      winopts = {
        height = 0.85,
        width = 0.80,
        preview = {
          layout = "vertical",
          vertical = "up:45%",
        },
      },
    })

    -- キーマップ
    vim.keymap.set("n", "<leader>fa", fzf.builtin, { desc = "fzf-lua builtin" })
    vim.keymap.set("n", "<leader>ff", fzf.files, { desc = "find files" })
    vim.keymap.set("n", "<leader>fg", fzf.live_grep, { desc = "live grep" })
    vim.keymap.set("n", "<leader>fb", fzf.buffers, { desc = "buffers" })
    vim.keymap.set("n", "<leader>fr", fzf.resume, { desc = "resume last search" })

    -- LSP
    vim.keymap.set("n", "<leader>fd", fzf.lsp_document_diagnostics, { desc = "diagnostics (current file)" })
    vim.keymap.set("n", "<leader>fD", fzf.lsp_workspace_diagnostics, { desc = "diagnostics (workspace)" })
    vim.keymap.set("n", "<leader>fs", fzf.lsp_document_symbols, { desc = "document symbols" })
    vim.keymap.set("n", "<leader>gr", fzf.lsp_references, { desc = "find references" })
    vim.keymap.set("n", "gd", fzf.lsp_definitions, { desc = "go to definition" })
  end,
}
