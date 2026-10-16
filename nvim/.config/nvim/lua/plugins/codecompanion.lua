return {
  "olimorris/codecompanion.nvim",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-treesitter/nvim-treesitter",
  },
  -- ローカルLLM (vLLM) が起動しているかチェック。落ちている場合はプラグインを読み込まない
  cond = function()
    local cmd = "curl -s -o /dev/null -w '%{http_code}' --max-time 1 http://llm-server.incus:8000/v1/models"
    local handle = io.popen(cmd)
    if handle then
      local result = handle:read("*a")
      handle:close()
      return result == "200"
    end
    return false
  end,
  config = function()
    require("codecompanion").setup({
      -- v19以降の新しい記法: adapters.http にネストする
      adapters = {
        http = {
          vllm = function()
            return require("codecompanion.adapters").extend("openai_compatible", {
              env = {
                url = "http://llm-server.incus:8000", -- vLLMサーバーのアドレス
                api_key = "TERM", -- ダミーキー (確実に存在する環境変数TERMを利用してエラー回避)
                chat_url = "/v1/chat/completions", -- OpenAI互換のチャットエンドポイント
              },
              schema = {
                model = {
                  default = "google/gemma-4-26b-a4b-it",
                },
              },
            })
          end,
        },
      },
      -- v19以降の新しい記法: strategies ではなく interactions
      interactions = {
        chat = { adapter = "vllm" },
        inline = { adapter = "vllm" },
        cmd = { adapter = "vllm" },
      },
    })

    -- キーバインド設定
    vim.keymap.set({ "n", "v" }, "<leader>cc", "<cmd>CodeCompanionChat Toggle<cr>", { desc = "Toggle CodeCompanion Chat" })
    vim.keymap.set({ "n", "v" }, "<leader>ca", "<cmd>CodeCompanionActions<cr>", { desc = "CodeCompanion Actions" })
    vim.keymap.set("v", "<leader>ce", "<cmd>CodeCompanion<cr>", { desc = "CodeCompanion Inline Edit" })
  end,
}
