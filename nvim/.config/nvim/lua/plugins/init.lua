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
          blink_cmp = true,
          treesitter = true,
          flash = true,
          mason = true,
          lsp_trouble = true,
          fzf = true,
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
        },
      })
      vim.cmd("colorscheme catppuccin")
    end,
  },

  -- Oil.nvim (Modern File Explorer)
  {
    "stevearc/oil.nvim",
    opts = {},
    config = function()
      require("oil").setup({
        default_file_explorer = true,
        view_options = {
          show_hidden = true,
        },
      })
      vim.keymap.set("n", "-", "<CMD>Oil<CR>", { desc = "Open parent directory" })
      vim.keymap.set("n", "\\", "<CMD>Oil<CR>", { desc = "Open parent directory" })
    end,
  },

  -- Treesitter
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    config = function()
      require("nvim-treesitter.configs").setup({
        ensure_installed = { "c", "lua", "python", "rust", "r", "vim", "vimdoc", "javascript", "typescript", "html", "markdown", "markdown_inline" },
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

  -- Trouble
  {
    "folke/trouble.nvim",
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

  -- Flash.nvim (Modern Jump)
  {
    "folke/flash.nvim",
    event = "VeryLazy",
    opts = {
      modes = {
        char = {
          enabled = true,
          jump_labels = true,
          multi_line = false,
        },
      },
    },
    keys = {
      { "s", mode = { "n", "x", "o" }, function() require("flash").jump() end, desc = "Flash" },
      { "S", mode = { "n", "x", "o" }, function() require("flash").treesitter() end, desc = "Flash Treesitter" },
      { "r", mode = "o", function() require("flash").remote() end, desc = "Remote Flash" },
      { "R", mode = { "o", "x" }, function() require("flash").treesitter_search() end, desc = "Treesitter Search" },
      { "<c-s>", mode = { "c" }, function() require("flash").toggle() end, desc = "Toggle Flash Search" },
      
      -- Hop-like line jumps (上下移動の加速)
      {
        "<leader>j",
        mode = { "n", "x", "o" },
        function()
          require("flash").jump({
            search = { mode = "search", max_length = 0 },
            label = { after = { 0, 0 } },
            pattern = "^"
          })
        end,
        desc = "Jump to Line (Down)",
      },
      {
        "<leader>k",
        mode = { "n", "x", "o" },
        function()
          require("flash").jump({
            search = { mode = "search", max_length = 0, forward = false },
            label = { after = { 0, 0 } },
            pattern = "^"
          })
        end,
        desc = "Jump to Line (Up)",
      },

      -- Hop-like word jumps in current line (左右移動の加速 - 日本語対応)
      {
        "<leader>l",
        mode = { "n", "x", "o" },
        function()
          require("flash").jump({
            search = { mode = "search", max_length = 0, multi_window = false, wrap = false },
            label = { after = { 0, 0 } },
            -- \<\w (英単語先頭) or [^\x00-\x7f] (マルチバイト文字)
            pattern = [[\<\w\|[^\x00-\x7f]]]
          })
        end,
        desc = "Jump to Word in Line (Forward)",
      },
      {
        "<leader>h",
        mode = { "n", "x", "o" },
        function()
          require("flash").jump({
            search = { mode = "search", max_length = 0, forward = false, multi_window = false, wrap = false },
            label = { after = { 0, 0 } },
            pattern = [[\<\w\|[^\x00-\x7f]]]
          })
        end,
        desc = "Jump to Word in Line (Backward)",
      },
    },
  },

  -- Mini.nvim
  {
    "echasnovski/mini.nvim",
    version = false,
    config = function()
      require("mini.icons").setup({})
      MiniIcons.mock_nvim_web_devicons()
      require("mini.diff").setup({})
      require("mini.pairs").setup({})
      require("mini.comment").setup({})
      require("mini.surround").setup({})
      require("mini.bracketed").setup({})
      require("mini.statusline").setup({ set_vim_settings = true })
    end,
  },

  -- Bullets.vim
  {
    "dkarter/bullets.vim",
    ft = { "markdown", "text", "gitcommit" },
    init = function()
      vim.g.bullets_enabled_file_types = { "markdown", "text", "gitcommit" }
    end,
  },

  -- Dressing.nvim
  {
    "stevearc/dressing.nvim",
    opts = {},
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
}
