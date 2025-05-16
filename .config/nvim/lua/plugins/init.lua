return {
  -- Colorscheme
  {
    "bluz71/vim-nightfly-guicolors",
    name = "nightfly",
    lazy = true,
    priority = 1000,
    config = function()
      -- vim.g.nightflyNormalFloat = true
      -- vim.g.nightflyTransparent = true
      -- vim.cmd("colorscheme nightfly")
    end,
  },

  {
    "folke/tokyonight.nvim",
    lazy = true,
    priority = 1000,
    config = function()
      -- require("tokyonight").setup({
      --   transparent = true,
      --   styles = {
      --     sidebars = "transparent",
      --     floats = "transparent",
      --   },
      -- })
      -- vim.cmd("colorscheme tokyonight-night")
    end,
  },

  {
    "catppuccin/nvim",
    lazy = false,
    priority = 1000,
    name = "catppuccin",
    config = function()
      require("catppuccin").setup({
        transparent_background = true,
        integrations = {
          cmp = true,
          gitsigns = true,
          neotree = true,
          treesitter = true,
          notify = false,
          fidget = true,
          hop = true,
          mason = true,
          lsp_trouble = true,
          navic = {
            enabled = true,
            custom_bg = "NONE", -- "lualine" will set background to mantle
          },
        },
      })
      vim.cmd("colorscheme catppuccin")
    end,
  },

  -- Status line
  {
    "nvim-lualine/lualine.nvim",
    config = function()
      require("lualine").setup({
        options = {
          theme = "catppuccin",
          globalstatus = true,
        },
        tabline = {
          lualine_a = { "buffers" },
          lualine_c = { "navic" },
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
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    config = function()
      require("nvim-treesitter.configs").setup({
        ensured_installed = {
          "bash",
          "comment",
          "css",
          "html",
          "javascript",
          "jsdoc",
          "jsonc",
          "lua",
          "markdown",
          "python",
          "r",
          "regex",
          "scss",
          "toml",
          "typescript",
          "yaml",
        },
      })
    end,
  },

  {
    "nvim-treesitter/nvim-treesitter-context",
    event = { "BufNewFile", "BufReadPre" },
    config = function()
      require("treesitter-context").setup({
        enable = true,
        multiwindow = false,
        max_lines = 0,
        min_window_height = 0,
        line_numbers = true,
        multiline_threshold = 20,
        trim_scope = "outer",
        mode = "cursor",
        separator = nil,
        zindex = 20,
        on_attach = nil,
      })
    end,
  },

  {
    "MeanderingProgrammer/render-markdown.nvim",
    -- dependencies = { 'nvim-treesitter/nvim-treesitter', 'echasnovski/mini.nvim' }, -- if you use the mini.nvim suite
    -- dependencies = { 'nvim-treesitter/nvim-treesitter', 'echasnovski/mini.icons' }, -- if you use standalone mini plugins
    dependencies = { "nvim-treesitter/nvim-treesitter", "nvim-tree/nvim-web-devicons" }, -- if you prefer nvim-web-devicons
    ---@module 'render-markdown'
    ---@type render.md.UserConfig
    opts = {},
  },

  -- Gitsigns
  {
    "lewis6991/gitsigns.nvim",
    config = function()
      require("gitsigns").setup({
        signcolumn = false,
        numhl = true,
      })
    end,
  },

  -- Trouble
  {
    "folke/trouble.nvim",
    dependencies = {
      "nvim-tree/nvim-web-devicons",
    },
    opts = {}, -- for default options, refer to the configuration section for custom setup.
    cmd = "Trouble",
    keys = {
      {
        "<leader>xx",
        "<cmd>Trouble diagnostics toggle<cr>",
        desc = "Diagnostics (Trouble)",
      },
      {
        "<leader>xX",
        "<cmd>Trouble diagnostics toggle filter.buf=0<cr>",
        desc = "Buffer Diagnostics (Trouble)",
      },
      {
        "<leader>cs",
        "<cmd>Trouble symbols toggle focus=false<cr>",
        desc = "Symbols (Trouble)",
      },
      {
        "<leader>cl",
        "<cmd>Trouble lsp toggle focus=false win.position=right<cr>",
        desc = "LSP Definitions / references / ... (Trouble)",
      },
      {
        "<leader>xL",
        "<cmd>Trouble loclist toggle<cr>",
        desc = "Location List (Trouble)",
      },
      {
        "<leader>xQ",
        "<cmd>Trouble qflist toggle<cr>",
        desc = "Quickfix List (Trouble)",
      },
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

  -- neoscroll
  {
    "karb94/neoscroll.nvim",
    config = function()
      require("neoscroll").setup()
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

  -- Indent-blankline
  -- {
  --   "lukas-reineke/indent-blankline.nvim",
  --   main = "ibl",
  --   opts = {},
  -- },

  -- nvim-navic
  {
    "SmiteshP/nvim-navic",
    dependencies = { "neovim/nvim-lspconfig" },
    config = function()
      require("nvim-navic").setup({
        highlight = true,
      })
    end,
  },

  -- fidget.nvim
  {
    "j-hui/fidget.nvim",
    opts = {
      notification = {
        window = {
          winblend = 0,
        },
      },
    },
  },

  {
    "shellRaining/hlchunk.nvim",
    event = { "BufReadPre", "BufNewFile" },
    config = function()
      require("hlchunk").setup({
        chunk = {
          enabled = true,
          chars = {
            horizontal_line = "─",
            vertical_line = "│",
            left_top = "╭",
            left_bottom = "╰",
            right_arrow = ">",
          },
          style = "#806d9c",
        },
        indent = {
          enabled = true,
        },
      })
    end,
  },
}
