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
})
