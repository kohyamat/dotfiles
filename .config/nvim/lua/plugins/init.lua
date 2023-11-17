return({
  -- Colorscheme
  {
    "folke/tokyonight.nvim",
    lazy = false,    -- make sure we load this during startup if it is your main colorscheme
    priority = 1000, -- make sure to load this before all the other start plugins
    config = function()
      require("tokyonight").setup({
        transparent = true,
        styles = {
          sidebars = "transparent",
          floats = "transparent",
        },
      })
      vim.cmd("colorscheme tokyonight-night")
    end,
  },

  {
    "catppuccin/nvim",
    lazy = true,
    name = "catppuccin",
  },

  -- Status line
  {
    "nvim-lualine/lualine.nvim",
    config = function()
      require("lualine").setup({
        options = {
          theme = "tokyonight",
          globalstatus = true,
        },
      })
    end,
    dependencies = { "nvim-tree/nvim-web-devicons", lazy = true },
  },

  -- Nvim-tree
  {
    "nvim-tree/nvim-tree.lua",
    config = function()
      require("nvim-tree").setup({})
      vim.keymap.set("n", "\\", vim.cmd.NvimTreeFocus)
      vim.keymap.set("n", "|", vim.cmd.NvimTreeToggle)
    end,
    dependencies = {
      "nvim-tree/nvim-web-devicons",
    },
  },

  -- Treesitter
  { "nvim-treesitter/nvim-treesitter", build = ":TSUpdate" },

  -- Gitsigns
  {
    "lewis6991/gitsigns.nvim",
    config = function()
      require("gitsigns").setup()
    end,
  },

  -- Trouble
  {
    "folke/trouble.nvim",
    dependencies = {
      "nvim-tree/nvim-web-devicons",
    },
  },

  -- Markdown preview
  {
    "iamcco/markdown-preview.nvim",
    cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
    build = "cd app && yarn install",
    init = function()
      vim.g.mkdp_filetypes = { "markdown" }
    end,
    ft = { "markdown" },
  },

  -- Hop
  {
    "phaazon/hop.nvim",
    branch = "v2",
    config = function()
      require("hop").setup()
      local hop = require("hop")
      local directions = require("hop.hint").HintDirection

      vim.keymap.set("n", "<leader>l", function()
        hop.hint_words({ direction = directions.AFTER_CURSOR, current_line_only = true })
      end, {})
      vim.keymap.set("n", "<leader>h", function()
        hop.hint_words({ direction = directions.BEFORE_CURSOR, current_line_only = true })
      end, {})
      vim.keymap.set("n", "<leader>j", function()
        hop.hint_vertical({ direction = directions.AFTER_CURSOR })
      end, {})
      vim.keymap.set("n", "<leader>k", function()
        hop.hint_vertical({ direction = directions.BEFORE_CURSOR })
      end, {})
    end,
  },

  -- Autopairs
  {
    "windwp/nvim-autopairs",
    config = function()
      require("nvim-autopairs").setup()
      local cmp = require("cmp")
      local cmp_autopairs = require("nvim-autopairs.completion.cmp")
      cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done())
    end,
    dependencies = { "hrsh7th/nvim-cmp" },
  },

  -- Comment
  {
    "numToStr/Comment.nvim",
    config = function()
      require("Comment").setup()
    end,
  },

  -- Vimcmdline
  {
    "jalvesaq/vimcmdline",
    config = function()
      vim.keymap.set("v", "<localleader><Space>", vim.cmd.RDSendSelection)
      vim.keymap.set("n", "<localleader><Space>", vim.cmd.RDSendLine)
      vim.cmd([[
      " vimcmdline mappings
      let cmdline_map_start          = '<LocalLeader>s'
      let cmdline_map_send           = '<Space>'
      let cmdline_map_send_and_stay  = '<LocalLeader><Space>'
      let cmdline_map_source_fun     = '<LocalLeader>f'
      let cmdline_map_send_paragraph = '<LocalLeader>p'
      let cmdline_map_send_block     = '<LocalLeader>b'
      let cmdline_map_send_motion    = '<LocalLeader>m'
      let cmdline_map_quit           = '<LocalLeader>q'
      let cmdline_vsplit = 1
      let cmdline_term_width = 80

      if has('gui_running') || &termguicolors
        let cmdline_color_input    = '#c6c8d1'
        let cmdline_color_normal   = '#84a0c6'
        let cmdline_color_number   = '#89b8c2'
        let cmdline_color_integer  = '#89b8c2'
        let cmdline_color_float    = '#89b8c2'
        let cmdline_color_complex  = '#89b8c2'
        let cmdline_color_negnum   = '#a093c7'
        let cmdline_color_negfloat = '#a093c7'
        let cmdline_color_date     = '#b4be82'
        let cmdline_color_true     = '#b4be82'
        let cmdline_color_false    = '#e27878'
        let cmdline_color_inf      = '#89b8c2'
        let cmdline_color_constant = '#84a0c6'
        let cmdline_color_string   = '#89b8c2'
        let cmdline_color_stderr   = '#84a0c6'
        let cmdline_color_error    = '#e27878'
        let cmdline_color_warn     = '#e2a478'
        let cmdline_color_index    = '#b4be82'
      elseif &t_Co == 256
        let cmdline_color_input    = 252
        let cmdline_color_normal   = 110
        let cmdline_color_number   = 109
        let cmdline_color_integer  = 109
        let cmdline_color_float    = 109
        let cmdline_color_complex  = 109
        let cmdline_color_negnum   = 140
        let cmdline_color_negfloat = 140
        let cmdline_color_date     = 150
        let cmdline_color_true     = 150
        let cmdline_color_false    = 203
        let cmdline_color_inf      = 109
        let cmdline_color_constant = 110
        let cmdline_color_string   = 109
        let cmdline_color_stderr   = 110
        let cmdline_color_error    = 203
        let cmdline_color_warn     = 216
        let cmdline_color_index    = 150
      endif
      ]])
    end,
  },

  -- Nvim-R
  {
    "jalvesaq/Nvim-R",
    config = function()
      vim.keymap.set("v", "<localleader><Space>", vim.cmd.RDSendSelection)
      vim.keymap.set("n", "<localleader><Space>", vim.cmd.RDSendLine)
      vim.cmd([[
      let R_assign = 0
      " let R_vsplit = 1
      " let R_rconsole_height = 25
      let R_objbr_place = "console,above"
      let R_nvimpager = 'tab'
      let R_show_args_help = 0
      let R_wait_reply = 1
      let R_csv_delim = ','
      ]])
    end,
  },
})
