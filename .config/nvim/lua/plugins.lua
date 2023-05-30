local fn = vim.fn
local install_path = fn.stdpath("data") .. "/site/pack/packer/start/packer.nvim"
if fn.empty(fn.glob(install_path)) > 0 then
  packer_bootstrap = fn.system({
    "git",
    "clone",
    "--depth",
    "1",
    "https://github.com/wbthomason/packer.nvim",
    install_path,
  })
end

return require("packer").startup(function(use)
  use("wbthomason/packer.nvim")

  -- LSP and completio
  use("neovim/nvim-lspconfig")
  use("williamboman/mason.nvim")
  use("williamboman/mason-lspconfig.nvim")
  use({
    "jayp0521/mason-null-ls.nvim",
    config = function()
      require("mason-null-ls").setup()
    end,
  })
  use("hrsh7th/nvim-cmp")
  use("hrsh7th/cmp-nvim-lsp")
  use("hrsh7th/cmp-vsnip")
  use({
    "hrsh7th/vim-vsnip",
    config = function()
      local api = vim.api
      api.nvim_set_keymap("i", "<C-n>", "vsnip#jumpable(1) ? '<Plug>(vsnip-jump-next)' : '<Tab>'", { expr = true })
      api.nvim_set_keymap("s", "<C-n>", "vsnip#jumpable(1) ? '<Plug>(vsnip-jump-next)' : '<Tab>'", { expr = true })
      api.nvim_set_keymap("i", "<C-p>", "vsnip#jumpable(1) ? '<Plug>(vsnip-jump-prev)' : '<S-Tab>'", { expr = true })
      api.nvim_set_keymap("s", "<C-p>", "vsnip#jumpable(1) ? '<Plug>(vsnip-jump-prev)' : '<S-Tab>'", { expr = true })
    end,
  })
  use("hrsh7th/cmp-buffer")
  use("hrsh7th/cmp-path")
  use("hrsh7th/cmp-cmdline")
  use("hrsh7th/cmp-nvim-lsp-signature-help")
  use("hrsh7th/cmp-nvim-lsp-document-symbol")
  -- use("hrsh7th/cmp-omni")
  use("onsails/lspkind-nvim")
  use("ray-x/cmp-treesitter")
  use("folke/lsp-colors.nvim")

  -- Fuzzy finder
  use({
    "nvim-telescope/telescope.nvim",
    requires = { { "nvim-lua/plenary.nvim" } },
    config = function()
      require("telescope").setup({
        pickers = {
          find_files = {
            theme = "dropdown",
          },
        },
        extensions = {
          fzf = {
            fuzzy = true, -- false will only do exact matching
            override_generic_sorter = true, -- override the generic sorter
            override_file_sorter = true, -- override the file sorter
            case_mode = "smart_case", -- or "ignore_case" or "respect_case"
            -- the default case_mode is "smart_case"
          },
        },
      })
      local api = vim.api
      api.nvim_set_keymap("n", "<leader>ff", "<cmd>Telescope find_files<CR>", { noremap = true })
      api.nvim_set_keymap("n", "<localleader>ff", "<cmd>Telescope find_files hidden=true<CR>", { noremap = true })
      api.nvim_set_keymap("n", "<leader>fg", "<cmd>Telescope live_grep<CR>", { noremap = true })
      api.nvim_set_keymap("n", "<leader>fb", "<cmd>Telescope buffers<CR>", { noremap = true })
      api.nvim_set_keymap("n", "<leader>fh", "<cmd>Telescope help_tags<CR>", { noremap = true })
    end,
  })
  use({
    "nvim-telescope/telescope-fzf-native.nvim",
    run = "make",
    config = function()
      require("telescope").load_extension("fzf")
    end,
  })
  use({
    "nvim-telescope/telescope-frecency.nvim",
    config = function()
      require("telescope").load_extension("frecency")
      vim.api.nvim_set_keymap(
        "n",
        "<leader><leader>",
        "<Cmd>lua require('telescope').extensions.frecency.frecency()<CR>",
        { noremap = true, silent = true }
      )
    end,
    requires = { "tami5/sqlite.lua" },
  })

  -- Filer
  use({
    "nvim-tree/nvim-tree.lua",
    requires = {
      "nvim-tree/nvim-web-devicons", -- optional
    },
    config = function()
      require("nvim-tree").setup({})
      local api = vim.api
      api.nvim_set_keymap("n", "\\", "<cmd>NvimTreeFocus<CR>", { noremap = true })
      api.nvim_set_keymap("n", "|", "<cmd>NvimTreeToggle<CR>", { noremap = true })
    end,
  })

  -- Colorscheme
  use({
    "cocopon/iceberg.vim",
    opt = false,
    config = function()
      vim.cmd("colorscheme iceberg")
      -- vim.cmd("hi Normal ctermbg=None guibg=None")
      -- vim.cmd("hi EndOfBuffer ctermbg=None guibg=None")
      -- vim.cmd("hi NonText ctermbg=None guibg=None")
      -- vim.cmd("hi Pmenu ctermbg=235 ctermfg=245 guibg=#1e2132 guifg=#686f9a")
    end,
  })

  -- Code runner
  use({
    "jalvesaq/vimcmdline",
    config = function()
      local api = vim.api
      api.nvim_set_keymap("v", "<localleader><Space>", "<Plug>RDSendSelection", { silent = true })
      api.nvim_set_keymap("n", "<localleader><Space>", "<Plug>RDSendLine", { silent = true })
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

  -- Utility
  use({ "nvim-treesitter/nvim-treesitter", run = ":TSUpdate" })
  use({
    "phaazon/hop.nvim",
    branch = "v1",
    config = function()
      require("hop").setup()
      local api = vim.api
      api.nvim_set_keymap(
        "n",
        "<leader>l",
        '<cmd>lua require"hop".hint_words({ direction = require"hop.hint".HintDirection.AFTER_CURSOR, current_line_only = true })<cr>',
        {}
      )
      api.nvim_set_keymap(
        "n",
        "<leader>h",
        '<cmd>lua require"hop".hint_words({ direction = require"hop.hint".HintDirection.BEFORE_CURSOR, current_line_only = true })<cr>',
        {}
      )
      api.nvim_set_keymap(
        "n",
        "<leader>j",
        '<cmd>lua require"hop".hint_lines({ direction = require"hop.hint".HintDirection.AFTER_CURSOR })<cr>',
        {}
      )
      api.nvim_set_keymap(
        "n",
        "<leader>k",
        '<cmd>lua require"hop".hint_lines({ direction = require"hop.hint".HintDirection.BEFORE_CURSOR })<cr>',
        {}
      )
    end,
  })
  use({
    "windwp/nvim-autopairs",
    config = function()
      require("nvim-autopairs").setup({})
      local cmp_autopairs = require("nvim-autopairs.completion.cmp")
      local cmp = require("cmp")
      cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done())
    end,
  })
  use({
    "numToStr/Comment.nvim",
    config = function()
      require("Comment").setup()
    end,
  })
  use({
    "jose-elias-alvarez/null-ls.nvim",
    requires = { "nvim-lua/plenary.nvim" },
    config = function()
      local null_ls = require("null-ls")
      null_ls.setup({
        -- debug = true,
        sources = {
          null_ls.builtins.formatting.stylua.with({
            -- prefer_local = "~/.cargo/bin",
            extra_args = { "--indent-type", "Spaces", "--indent-width", "2" },
          }),
          -- null_ls.builtins.formatting.prettier,
          null_ls.builtins.formatting.prettier.with({
            -- prefer_local = "~/.node_modules/bin",
            filetypes = {
              "javascript",
              "typescript",
              "css",
              "scss",
              "html",
              "vue",
              "json",
              "yaml",
              "markdown",
              "graphql",
              "md",
              "txt",
            },
          }),
          null_ls.builtins.diagnostics.eslint,
          null_ls.builtins.formatting.black.with({
            -- prefer_local = "~/.pyenv/shims",
            extra_args = { "-l", "88" },
          }),
          null_ls.builtins.formatting.isort.with({
            -- prefer_local = "~/.pyenv/shims",
            extra_args = { "-l", "88" },
          }),
          null_ls.builtins.formatting.styler,
          null_ls.builtins.formatting.beautysh,
        },
      })
    end,
  })
  use({
    "folke/trouble.nvim",
    requires = "nvim-tree/nvim-web-devicons",
    config = function()
      require("trouble").setup({})
      local api = vim.api
      api.nvim_set_keymap("n", "<leader>xx", "<cmd>Trouble<cr>", { silent = true, noremap = true })
      api.nvim_set_keymap(
        "n",
        "<leader>xw",
        "<cmd>Trouble workspace_diagnostics<cr>",
        { silent = true, noremap = true }
      )
      api.nvim_set_keymap("n", "<leader>xd", "<cmd>Trouble document_diagnostics<cr>", { silent = true, noremap = true })
      api.nvim_set_keymap("n", "<leader>xl", "<cmd>Trouble loclist<cr>", { silent = true, noremap = true })
      api.nvim_set_keymap("n", "<leader>xq", "<cmd>Trouble quickfix<cr>", { silent = true, noremap = true })
      api.nvim_set_keymap("n", "gR", "<cmd>Trouble lsp_references<cr>", { silent = true, noremap = true })
    end,
  })
  use({
    "norcalli/nvim-colorizer.lua",
    config = function()
      require("colorizer").setup()
    end,
  })
  use({
    "nvim-lualine/lualine.nvim",
    requires = { "nvim-tree/nvim-web-devicons", opt = true },
    config = function()
      require("lualine").setup({
        options = {
          theme = "iceberg_dark",
          -- If not use Nerd Fonts
          -- icons_enabled = false,
          -- section_separators = "",
          -- component_separators = "",
        },
      })
    end,
  })
  use({
    "tami5/lspsaga.nvim",
    config = function()
      require("lspsaga").setup({
        debug = false,
        use_saga_diagnostic_sign = true,
        -- diagnostic sign
        error_sign = "",
        warn_sign = "",
        hint_sign = "",
        infor_sign = "",
        diagnostic_header_icon = "   ",
        -- code action title icon
        code_action_icon = " ",
        code_action_prompt = {
          enable = true,
          sign = true,
          sign_priority = 40,
          virtual_text = true,
        },
        finder_definition_icon = "  ",
        finder_reference_icon = "  ",
        max_preview_lines = 10,
        finder_action_keys = {
          open = "o",
          vsplit = "s",
          split = "i",
          quit = "q",
          scroll_down = "<C-f>",
          scroll_up = "<C-b>",
        },
        code_action_keys = {
          quit = "q",
          exec = "<CR>",
        },
        rename_action_keys = {
          quit = "<C-c>",
          exec = "<CR>",
        },
        definition_preview_icon = "  ",
        border_style = "single",
        rename_prompt_prefix = "➤",
        rename_output_qflist = {
          enable = false,
          auto_open_qflist = false,
        },
        server_filetype_map = {},
        diagnostic_prefix_format = "%d. ",
        diagnostic_message_format = "%m %c",
        highlight_prefix = false,
      })
    end,
  })
  use({
    "iamcco/markdown-preview.nvim",
    config = { "vim.cmd[[doautocmd BufEnter]]", "vim.cmd[[MarkdownPreview]]" },
    run = "cd app && yarn install",
    cmd = "MarkdownPreview",
  })
  use({
    "xiyaowong/nvim-transparent",
    config = function()
      require("transparent").setup({
        groups = { -- table: default groups
          "Normal",
          "NormalNC",
          "Comment",
          "Constant",
          "Special",
          "Identifier",
          "Statement",
          "PreProc",
          "Type",
          "Underlined",
          "Todo",
          "String",
          "Function",
          "Conditional",
          "Repeat",
          "Operator",
          "Structure",
          "LineNr",
          "NonText",
          "SignColumn",
          "CursorLineNr",
          "EndOfBuffer",
        },
        extra_groups = { -- table: additional groups that should be cleared
          -- "NormalFloat",
        },
        exclude_groups = {}, -- table: groups you don't want to clear
      })
    end,
  })
  use({
    "jalvesaq/Nvim-R",
    config = function()
      local api = vim.api
      api.nvim_set_keymap("v", "<localleader><Space>", "<Plug>RDSendSelection", { silent = true })
      api.nvim_set_keymap("n", "<localleader><Space>", "<Plug>RDSendLine", { silent = true })
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
  use({ "jalvesaq/cmp-nvim-r" })

  -- Automatically set up your configuration after cloning packer.nvim
  -- Put this at the end after all plugins
  if packer_bootstrap then
    require("packer").sync()
  end
end)
