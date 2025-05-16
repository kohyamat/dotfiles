return {
  "ibhagwan/fzf-lua",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  opts = {},
  config = function()
    local fzf = require("fzf-lua")

    fzf.setup({
      winopts = {
        on_create = function()
          vim.keymap.set("t", "<C-n>", "<Down>", { silent = true, buffer = true })
          vim.keymap.set("t", "<C-p>", "<Up>", { silent = true, buffer = true })
        end,
      },
    })

    -- local config = require("fzf-lua.config")
    -- local actions = require("trouble.sources.fzf").actions
    -- config.defaults.actions.files["ctrl-t"] = actions.open
    vim.keymap.set("n", "<leader>fa", fzf.builtin, { desc = "fzf-lua builtin" })
    vim.keymap.set("n", "<leader>ff", fzf.files, { desc = "fzf-lua find files" })
    vim.keymap.set("n", "<leader>fg", fzf.live_grep, { desc = "fzf-lua live grep" })
    vim.keymap.set("n", "<leader>fr", fzf.resume, { desc = "fzf-lua resume" })
    vim.keymap.set("n", "<leader>fc", fzf.grep_cword, { desc = "fzf-lua grep" })
    vim.keymap.set("n", "<leader>fb", fzf.buffers, { desc = "fzf-lua buffers" })
    vim.keymap.set("n", "<leader>/", fzf.blines, { desc = "fzf-lua search current buffers" })
    vim.keymap.set("n", "<leader>fk", fzf.keymaps, { desc = "fzf-lua keymaps" })
    vim.keymap.set("n", "<leader>gr", fzf.lsp_references, { desc = "fzf-lua find references" })
  end,
}
