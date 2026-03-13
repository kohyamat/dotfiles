return {
  -- Colorscheme
  {
    "bluz71/vim-nightfly-guicolors",
    name = "nightfly",
    lazy = true,
    priority = 1000,
  },

  {
    "folke/tokyonight.nvim",
    lazy = true,
    priority = 1000,
  },

  {
    "catppuccin/nvim",
    lazy = false,
    priority = 1000,
    name = "catppuccin",
    config = function()
      require("catppuccin").setup({
        flavour = "mocha",
        transparent_background = true,
        integrations = {
          cmp = true,
          gitsigns = true,
          treesitter = true,
          fidget = true,
          hop = true,
          mason = true,
          lsp_trouble = true,
          fzf = true,
          dap = true,
          native_lsp = {
            enabled = true,
            virtual_text = {
              errors = { "italic" },
              hints = { "italic" },
              warnings = { "italic" },
              information = { "italic" },
              ok = { "italic" },
            },
          },
          navic = {
            enabled = true,
            custom_bg = "NONE",
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
    dependencies = { "nvim-tree/nvim-web-devicons" },
  },

  -- Oil.nvim (Modern File Explorer)
  {
    "stevearc/oil.nvim",
    opts = {},
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      require("oil").setup({
        default_file_explorer = true,
        view_options = {
          show_hidden = true,
        },
      })
      vim.keymap.set("n", "-", "<CMD>Oil<CR>", { desc = "Open parent directory" })
      -- Also keep nvim-tree like mappings if you prefer
      vim.keymap.set("n", "\\", "<CMD>Oil<CR>", { desc = "Open parent directory" })
    end,
  },

  -- Treesitter
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    config = function()
      require("nvim-treesitter.configs").setup({
        ensure_installed = { "c", "lua", "python", "rust", "r", "vim", "vimdoc", "javascript", "typescript", "html" },
        sync_install = false,
        highlight = {
          enable = true,
          additional_vim_regex_highlighting = false,
        },
        indent = { enable = true },
      })

      local parser_config = require("nvim-treesitter.parsers").get_parser_configs()
      parser_config.stan = {
        install_info = {
          url = "https://github.com/WardBrian/tree-sitter-stan",
          files = { "src/parser.c" },
          branch = "main",
        },
      }

      vim.filetype.add({
        extension = { stan = "stan" },
      })
    end,
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
    dependencies = { "nvim-tree/nvim-web-devicons" },
    opts = {
      auto_preview = true,
      auto_jump = { "lsp_definitions" },
      modes = {
        diagnostics = {
          auto_open = false,
          auto_close = true,
        },
      },
    },
    cmd = "Trouble",
    keys = {
      { "<leader>xx", "<cmd>Trouble diagnostics toggle<cr>", desc = "Diagnostics (Trouble)" },
      { "<leader>xX", "<cmd>Trouble diagnostics toggle filter.buf=0<cr>", desc = "Buffer Diagnostics (Trouble)" },
      { "<leader>cs", "<cmd>Trouble symbols toggle focus=false<cr>", desc = "Symbols (Trouble)" },
      { "<leader>cl", "<cmd>Trouble lsp toggle focus=false win.position=right<cr>", desc = "LSP Definitions / references / ... (Trouble)" },
      {
        "[x",
        function()
          if require("trouble").is_open() then
            require("trouble").prev({ skip_groups = true, jump = true })
          else
            vim.diagnostic.goto_prev()
          end
        end,
        desc = "Previous Trouble/Diagnostic Item",
      },
      {
        "]x",
        function()
          if require("trouble").is_open() then
            require("trouble").next({ skip_groups = true, jump = true })
          else
            vim.diagnostic.goto_next()
          end
        end,
        desc = "Next Trouble/Diagnostic Item",
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
    event = "InsertEnter",
    config = true,
  },

  -- Comment
  {
    "numToStr/Comment.nvim",
    config = function()
      require("Comment").setup()
    end,
  },

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
}
