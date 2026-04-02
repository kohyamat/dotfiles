return {
  "ibhagwan/fzf-lua",
  dependencies = { "folke/trouble.nvim" },
  opts = {},
  config = function()
    local fzf = require("fzf-lua")
    local actions = require("trouble.sources.fzf").actions

    fzf.setup({
      -- 推奨キーマップの設定
      keymap = {
        builtin = {
          -- fzf-lua本体の操作
          ["<C-t>"] = actions.open,      -- 検索結果を Trouble に送る
          ["<C-g>"] = "toggle-preview",  -- プレビューの表示/非表示
          ["<F1>"]  = "help",            -- ヘルプの表示
        },
        fzf = {
          -- fzfプロセス側の操作 (入力中)
          ["ctrl-n"] = "down",           -- 次の候補
          ["ctrl-p"] = "up",             -- 前の候補
          ["ctrl-j"] = "down",           -- 次の候補 (Vimスタイル)
          ["ctrl-k"] = "up",             -- 前の候補 (Vimスタイル)
          ["ctrl-u"] = "preview-page-up",   -- プレビューを上にスクロール
          ["ctrl-d"] = "preview-page-down", -- プレビューを下にスクロール
          ["ctrl-a"] = "select-all",     -- 全選択
        },
      },
      -- 見た目とレイアウトの最適化
      winopts = {
        height = 0.85,
        width = 0.80,
        preview = {
          layout = "vertical", -- 画面に応じて縦横を自動切替
          vertical = "up:45%", -- 縦表示の時は上にプレビュー
        },
      },
    })

    -- 基本操作のキーマップ
    vim.keymap.set("n", "<leader>fa", fzf.builtin, { desc = "fzf-lua builtin" })
    vim.keymap.set("n", "<leader>ff", fzf.files, { desc = "find files" })
    vim.keymap.set("n", "<leader>fg", fzf.live_grep, { desc = "live grep" })
    vim.keymap.set("n", "<leader>fb", fzf.buffers, { desc = "buffers" })
    vim.keymap.set("n", "<leader>fr", fzf.resume, { desc = "resume last search" })

    -- LSP / 診断関連
    vim.keymap.set("n", "<leader>fd", fzf.lsp_document_diagnostics, { desc = "diagnostics (current file)" })
    vim.keymap.set("n", "<leader>fD", fzf.lsp_workspace_diagnostics, { desc = "diagnostics (workspace)" })
    vim.keymap.set("n", "<leader>fs", fzf.lsp_document_symbols, { desc = "document symbols" })
    vim.keymap.set("n", "<leader>gr", fzf.lsp_references, { desc = "find references" })
    vim.keymap.set("n", "gd", fzf.lsp_definitions, { desc = "go to definition" })
  end,
}
