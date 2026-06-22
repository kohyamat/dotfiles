
return {
  "ibhagwan/fzf-lua",
  dependencies = { "folke/trouble.nvim" },
  opts = {},
  config = function()
    local fzf = require("fzf-lua")

    fzf.setup({
      -- エラー回避のため fzf 側の高度なキー生成を無効化
      keymap = {
        fzf = false,
      },
      winopts = {
        -- Neovim側で確実にキー入力を矢印キーに変換する
        on_create = function()
          vim.keymap.set("t", "<C-n>", "<Down>", { silent = true, buffer = true })
          vim.keymap.set("t", "<C-p>", "<Up>", { silent = true, buffer = true })
          vim.keymap.set("t", "<C-j>", "<Down>", { silent = true, buffer = true })
          vim.keymap.set("t", "<C-k>", "<Up>", { silent = true, buffer = true })
        end,
      },
    })

    -- 既存のノーマルモード起動用キーマップ
    vim.keymap.set("n", "<leader>fa", fzf.builtin, { desc = "fzf-lua builtin" })
    vim.keymap.set("n", "<leader>ff", fzf.files, { desc = "find files" })
    vim.keymap.set("n", "<leader>fg", fzf.live_grep, { desc = "live grep" })
    vim.keymap.set("n", "<leader>fb", fzf.buffers, { desc = "buffers" })
    vim.keymap.set("n", "<leader>fr", fzf.resume, { desc = "resume last search" })

    -- 既存の LSP / 診断関連
    vim.keymap.set("n", "<leader>fd", fzf.lsp_document_diagnostics, { desc = "diagnostics (current file)" })
    vim.keymap.set("n", "<leader>fD", fzf.lsp_workspace_diagnostics, { desc = "diagnostics (workspace)" })
    vim.keymap.set("n", "<leader>fs", fzf.lsp_document_symbols, { desc = "document symbols" })
    vim.keymap.set("n", "<leader>gr", fzf.lsp_references, { desc = "find references" })
    vim.keymap.set("n", "gd", fzf.lsp_definitions, { desc = "go to definition" })

    -- ~/.ssh/config を読み込んで oil-ssh を起動する設定
    local function open_oil_ssh_with_fzf()
      local hosts = {}
      local file = io.open(os.getenv("HOME") .. "/.ssh/config", "r")
      if file then
        for line in file:lines() do
          -- Host 行からホスト名を抽出 (ワイルドカードは除外)
          local host = line:match("^Host%s+(%S+)")
          if host and host ~= "*" then
            table.insert(hosts, host)
          end
        end
        file:close()
      end

      if #hosts == 0 then
        print("SSH config にホストが見つかりませんでした")
        return
      end

      -- fzf-lua のカスタムリスト実行機能を使う
      fzf.fzf_exec(hosts, {
        prompt = "Oil SSH> ",
        actions = {
          ["default"] = function(selected)
            if selected and #selected > 0 then
              -- 選択されたホストのルート(またはホーム)を Oil で開く
              require("oil").open("oil-ssh://" .. selected[1] .. "/$HOME")
            end
          end
        }
      })
    end

    vim.keymap.set("n", "<leader>fo", open_oil_ssh_with_fzf, { desc = "oil ssh hosts" })
  end,
}
