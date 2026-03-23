return {
  "ibhagwan/fzf-lua",
  dependencies = { "folke/trouble.nvim" },
  opts = {
    -- UI を rounded に統一
    winopts = {
      height = 0.85,
      width = 0.80,
      row = 0.35,
      col = 0.50,
      border = "rounded",
      preview = {
        layout = "vertical",
        vertical = "down:45%",
      },
    },
    -- 標準的な fzf の動作 (Ctrl-j/k での移動、Ctrl-q で Quickfix 等)
    keymap = {
      builtin = {
        ["<C-d>"] = "preview-page-down",
        ["<C-u>"] = "preview-page-up",
      },
      fzf = {
        ["CTRL-Q"] = "select-all+accept", -- すべて選択して Quickfix 等へ
      },
    },
    fzf_opts = {
      ["--ansi"] = "",
      ["--info"] = "inline",
      ["--height"] = "100%",
      ["--layout"] = "reverse",
      ["--border"] = "none",
    },
  },
  config = function(_, opts)
    local fzf = require("fzf-lua")
    local actions = require("trouble.sources.fzf").actions
    
    -- Trouble との統合キーマップ
    opts.keymap.builtin["<C-t>"] = actions.open
    fzf.setup(opts)

    -- 1. ファイル検索 (標準的)
    vim.keymap.set("n", "<leader>ff", fzf.files, { desc = "Find Files" })
    vim.keymap.set("n", "<leader>fb", fzf.buffers, { desc = "Find Buffers" })
    vim.keymap.set("n", "<leader>fo", fzf.oldfiles, { desc = "Find Old Files" })
    vim.keymap.set("n", "<C-p>", fzf.files, { desc = "Find Files (Shortcut)" })

    -- 2. 文字列検索 (標準的)
    vim.keymap.set("n", "<leader>sg", fzf.live_grep, { desc = "Search Live Grep" })
    vim.keymap.set("n", "<leader>sw", fzf.grep_cword, { desc = "Search Word under cursor" })
    vim.keymap.set("n", "<leader>s/", fzf.blines, { desc = "Search in Current Buffer" })
    vim.keymap.set("n", "<leader>sh", fzf.help_tags, { desc = "Search Help" })
    vim.keymap.set("n", "<leader>sr", fzf.resume, { desc = "Search Resume" })

    -- 3. LSP 統合 (標準の gd, gr を強化)
    vim.keymap.set("n", "gd", fzf.lsp_definitions, { desc = "LSP Definitions (Fzf)" })
    vim.keymap.set("n", "gr", fzf.lsp_references, { desc = "LSP References (Fzf)" })
    vim.keymap.set("n", "gi", fzf.lsp_implementations, { desc = "LSP Implementations (Fzf)" })
    vim.keymap.set("n", "<leader>sd", fzf.lsp_document_symbols, { desc = "LSP Document Symbols" })
    vim.keymap.set("n", "<leader>sD", fzf.lsp_workspace_symbols, { desc = "LSP Workspace Symbols" })
    vim.keymap.set("n", "<leader>xw", fzf.lsp_workspace_diagnostics, { desc = "LSP Workspace Diagnostics" })

    -- 4. スペルチェック (標準の z= を強化)
    vim.keymap.set("n", "z=", fzf.spell_suggest, { desc = "Spell Suggestions (Fzf)" })
  end,
}
