return {
  "akinsho/toggleterm.nvim",
  version = "*",
  config = function()
    require("toggleterm").setup({
      size = function(term)
        if term.direction == "horizontal" then
          return 15
        elseif term.direction == "vertical" then
          return vim.o.columns * 0.4
        end
      end,
      open_mapping = [[<leader>rs]], -- ターミナルの開閉
      hide_numbers = true,
      shade_terminals = false,
      start_in_insert = true,
      insert_mappings = true,
      terminal_mappings = true,
      persist_size = true,
      direction = "vertical", -- デフォルトを縦割りに設定
      close_on_exit = true,
      shell = vim.o.shell,
      auto_scroll = true,
    })

    -- 便利な関数
    local trim_spaces = true
    vim.keymap.set("v", "<leader>rl", function()
      require("toggleterm").send_lines_to_terminal("visual", trim_spaces, { args = vim.v.count })
    end, { desc = "Send visual selection to terminal" })

    -- 行（またはカウントした行数）を送信
    vim.keymap.set("n", "<leader>rl", function()
      require("toggleterm").send_lines_to_terminal("single_line", trim_spaces, { args = vim.v.count })
    end, { desc = "Send current line to terminal" })

    -- ファイル全体を送信
    vim.keymap.set("n", "<leader>rf", function()
      local filename = vim.api.nvim_buf_get_name(0)
      local filetype = vim.bo.filetype
      local cmd = ""

      if filetype == "python" then
        cmd = "python3 " .. filename
      elseif filetype == "r" then
        cmd = "Rscript " .. filename
      elseif filetype == "sh" or filetype == "zsh" then
        cmd = "bash " .. filename
      elseif filetype == "lua" then
        cmd = "lua " .. filename
      else
        print("No run command for filetype: " .. filetype)
        return
      end

      require("toggleterm").exec(cmd)
    end, { desc = "Send whole file to terminal" })

    -- ターミナル内での移動を楽にする
    function _G.set_terminal_keymaps()
      local opts = { buffer = 0 }
      vim.keymap.set("t", "<esc>", [[<C-\><C-n>]], opts)
      vim.keymap.set("t", "jk", [[<C-\><C-n>]], opts)
      vim.keymap.set("t", "<C-h>", [[<Cmd>wincmd h<CR>]], opts)
      vim.keymap.set("t", "<C-j>", [[<Cmd>wincmd j<CR>]], opts)
      vim.keymap.set("t", "<C-k>", [[<Cmd>wincmd k<CR>]], opts)
      vim.keymap.set("t", "<C-l>", [[<Cmd>wincmd l<CR>]], opts)
      vim.keymap.set("t", "<C-w>", [[<C-\><C-n><C-w>]], opts)
    end

    -- ターミナルが開いた時だけキーマップを有効化
    vim.cmd("autocmd! TermOpen term://* lua set_terminal_keymaps()")
  end,
}
