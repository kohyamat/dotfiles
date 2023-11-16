local ensure_packer = function()
  local fn = vim.fn
  local install_path = fn.stdpath("data") .. "/site/pack/packer/start/packer.nvim"
  if fn.empty(fn.glob(install_path)) > 0 then
    fn.system({ "git", "clone", "--depth", "1", "https://github.com/wbthomason/packer.nvim", install_path })
    vim.cmd([[packadd packer.nvim]])
    return true
  end
  return false
end

local packer_bootstrap = ensure_packer()

return require("packer").startup(function(use)
  use("wbthomason/packer.nvim")

  -- LSP
  use("williamboman/mason.nvim")
  use("williamboman/mason-lspconfig.nvim")
  use("neovim/nvim-lspconfig")
  use({
    "nvimtools/none-ls.nvim",
    requires = { "nvim-lua/plenary.nvim" },
  })

  -- Completion
  use("hrsh7th/cmp-nvim-lsp")
  use("hrsh7th/cmp-buffer")
  use("hrsh7th/cmp-path")
  use("hrsh7th/cmp-cmdline")
  use("hrsh7th/nvim-cmp")
  use("L3MON4D3/LuaSnip")
  use("saadparwaiz1/cmp_luasnip")

  -- Filer
  use({
    "nvim-tree/nvim-tree.lua",
    requires = {
      "nvim-tree/nvim-web-devicons",
    },
    config = function()
      require("nvim-tree").setup({})
      vim.keymap.set("n", "\\", vim.cmd.NvimTreeFocus, {})
      vim.keymap.set("n", "|", vim.cmd.NvimTreeToggle, {})
    end,
  })

  use({
    "nvim-telescope/telescope.nvim",
    tag = "0.1.4",
    requires = { { "nvim-lua/plenary.nvim" } },
  })

  -- Colorscheme
  use({
    "folke/tokyonight.nvim",
    config = function()
      vim.cmd("colorscheme tokyonight")
    end,
  })

  -- Status line
  use({
    "nvim-lualine/lualine.nvim",
    requires = { "nvim-tree/nvim-web-devicons", opt = true },
    config = function()
      require("lualine").setup({
        options = {
          theme = "tokyonight",
        },
      })
    end,
  })

  -- Markdown preview
  use({
    "iamcco/markdown-preview.nvim",
    config = { "vim.cmd[[doautocmd BufEnter]]", "vim.cmd[[MarkdownPreview]]" },
    run = "cd app && yarn install",
    cmd = "MarkdownPreview",
  })

  -- Utility
  use({ "nvim-treesitter/nvim-treesitter", run = ":TSUpdate" })

  use({
    "folke/trouble.nvim",
    requires = {
      "nvim-tree/nvim-web-devicons",
    },
  })

  use({
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
        hop.hint_lines({ direction = directions.AFTER_CURSOR })
      end, {})
      vim.keymap.set("n", "<leader>k", function()
        hop.hint_lines({ direction = directions.BEFORE_CURSOR })
      end, {})
    end,
  })

  use({
    "windwp/nvim-autopairs",
    config = function()
      require("nvim-autopairs").setup({})
    end,
  })

  use({
    "numToStr/Comment.nvim",
    config = function()
      require("Comment").setup()
    end,
  })

  use({
    "jalvesaq/vimcmdline",
    config = function()
      vim.keymap.set("v", "<localleader><Space>", vim.cmd.RDSendSelection, { silent = true })
      vim.keymap.set("n", "<localleader><Space>", vim.cmd.RDSendLine, { silent = true })
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
  })

  use({
    "jalvesaq/Nvim-R",
    config = function()
      vim.keymap.set("v", "<localleader><Space>", vim.cmd.RDSendSelection, { silent = true })
      vim.keymap.set("n", "<localleader><Space>", vim.cmd.RDSendLine, { silent = true })
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
  })
  if packer_bootstrap then
    require("packer").sync()
  end
end)
