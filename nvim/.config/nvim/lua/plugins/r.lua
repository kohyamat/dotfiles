return {
  "R-nvim/R.nvim",
  -- R, RMarkdown, Quarto ファイルを開いた時だけロード
  ft = { "r", "rmd", "quarto" },
  config = function()
    -- R.nvim の基本設定
    local opts = {
      R_args = { "--quiet", "--no-save" },
      -- ターミナルの割り振り設定
      hook = {
        on_filetype = function()
          -- 1. _ キーを <- に変換 (挿入モード)
          -- もし本物のアンダースコアを打ちたい場合は、2回連続で _ を叩く
          vim.api.nvim_buf_set_keymap(0, "i", "_", " <- ", { noremap = true })
          
          -- 2. ToggleTerm と共存するためのキーマップ整理
          local bopts = { buffer = true, silent = true }
          -- Rコンソールの起動/終了
          vim.keymap.set("n", "<Leader>rf", "<Plug>RStart", { desc = "Start R Console" })
          vim.keymap.set("n", "<Leader>rq", "<Plug>RClose", { desc = "Quit R Console" })
          -- コードの送信 (行 / 選択範囲)
          vim.keymap.set("n", "<Leader>rl", "<Plug>RSendLine", { desc = "Send Line to R" })
          vim.keymap.set("v", "<Leader>rl", "<Plug>RSendSelection", { desc = "Send Selection to R" })
        end,
      },
      -- 見た目の調整
      min_editor_width = 72,
      rconsole_width = 40,
      rconsole_orientation = "v", -- 縦分割
      disable_cmds = { "RAction" }, -- 不要なコマンドを無効化
    }
    require("r").setup(opts)
  end,
}
