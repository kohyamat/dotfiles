return {
  "Vigemus/iron.nvim",
  config = function()
    local iron = require("iron.core")
    local view = require("iron.view")
    local core = require("iron.core")
    iron.setup({
      config = {
        -- Whether a repl should be discarded or not
        scratch_repl = true,
        -- Your repl definitions come here
        repl_definition = {
          sh = require("iron.fts.sh").zsh,
          python = require("iron.fts.python").ipython,
          r = require("iron.fts.r").R,
          lua = require("iron.fts.lua").lua,
        },
        repl_open_cmd = view.split.vertical.botright(80),
      },
      -- Iron doesn't set keymaps by default anymore.
      -- You can set them here or manually add keymaps to the functions in iron.core
      keymaps = {
        -- send_motion = "<space>sc",
        -- visual_send = "<space>sc",
        -- send_file = "<space>sf",
        -- send_line = "<space>sl",
        -- send_until_cursor = "<space>su",
        -- send_mark = "<space>sm",
        -- mark_motion = "<space>mc",
        -- mark_visual = "<space>mc",
        -- remove_mark = "<space>md",
        -- cr = "<space>s<cr>",
        -- interrupt = "<space>s<space>",
        -- exit = "<space>sq",
        -- clear = "<space>cl",
      },
      -- If the highlight is on, you can change how it looks
      -- For the available options, check nvim_set_hl
      -- highlight = {
      --   italic = true
      -- },
      ignore_blank_lines = true, -- ignore blank lines when sending visual select lines
    })

    -- iron also has a list of commands, see :h iron-commands for all available commands
    vim.keymap.set("n", "<localleader>rs", "<cmd>IronRepl<cr>")
    vim.keymap.set("n", "<localleader>rr", "<cmd>IronRestart<cr>")
    vim.keymap.set("n", "<localleader>rf", "<cmd>IronFocus<cr>")
    vim.keymap.set("n", "<localleader>rh", "<cmd>IronHide<cr>")
    -- exit
    vim.keymap.set("n", "<localleader>rq", function()
      core.close_repl()
    end)
    -- clear
    vim.keymap.set("n", "<localleader>rk", function()
      core.send(nil, string.char(12))
    end)
    -- CR
    vim.keymap.set("n", "<localleader>r<space>", function()
      core.send(nil, string.char(13))
    end)
    -- interrupt 
    vim.keymap.set("n", "<localleader>ri", function()
      core.send(nil, string.char(03))
    end)
    -- send line
    vim.keymap.set("n", "<localleader><space>", function()
      core.send_line()
    end)
    -- send visual block 
    vim.keymap.set("v", "<localleader><space>", function()
      core.visual_send()
    end)
  end,
}
