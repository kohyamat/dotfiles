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

  -- LSP and completion
  use("neovim/nvim-lspconfig")
  use("williamboman/nvim-lsp-installer")
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
  use("hrsh7th/cmp-omni")
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
    "nvim-neo-tree/neo-tree.nvim",
    branch = "v2.x",
    requires = {
      "nvim-lua/plenary.nvim",
      "kyazdani42/nvim-web-devicons", -- not strictly required, but recommended
      "MunifTanjim/nui.nvim",
      {
        -- only needed if you want to use the "open_window_picker" command
        "s1n7ax/nvim-window-picker",
        tag = "1.*",
        config = function()
          require("window-picker").setup({
            autoselect_one = true,
            include_current = false,
            filter_rules = {
              -- filter using buffer options
              bo = {
                -- if the file type is one of following, the window will be ignored
                filetype = { "neo-tree", "neo-tree-popup", "notify", "quickfix" },

                -- if the buffer type is one of following, the window will be ignored
                buftype = { "terminal" },
              },
            },
            other_win_hl_color = "#e35e4f",
          })
        end,
      },
    },
    config = function()
      -- Unless you are still migrating, remove the deprecated commands from v1.x
      vim.cmd([[ let g:neo_tree_remove_legacy_commands = 1 ]])

      -- If you want icons for diagnostic errors, you'll need to define them somewhere:
      vim.fn.sign_define("DiagnosticSignError", { text = " ", texthl = "DiagnosticSignError" })
      vim.fn.sign_define("DiagnosticSignWarn", { text = " ", texthl = "DiagnosticSignWarn" })
      vim.fn.sign_define("DiagnosticSignInfo", { text = " ", texthl = "DiagnosticSignInfo" })
      vim.fn.sign_define("DiagnosticSignHint", { text = "", texthl = "DiagnosticSignHint" })
      -- NOTE: this is changed from v1.x, which used the old style of highlight groups
      -- in the form "LspDiagnosticsSignWarning"

      require("neo-tree").setup({
        close_if_last_window = false, -- Close Neo-tree if it is the last window left in the tab
        popup_border_style = "rounded",
        enable_git_status = true,
        enable_diagnostics = true,
        default_component_configs = {
          indent = {
            indent_size = 2,
            padding = 1, -- extra padding on left hand side
            -- indent guides
            with_markers = true,
            indent_marker = "│",
            last_indent_marker = "└",
            highlight = "NeoTreeIndentMarker",
            -- expander config, needed for nesting files
            with_expanders = nil, -- if nil and file nesting is enabled, will enable expanders
            expander_collapsed = "",
            expander_expanded = "",
            expander_highlight = "NeoTreeExpander",
          },
          icon = {
            folder_closed = "",
            folder_open = "",
            folder_empty = "ﰊ",
            default = "*",
          },
          modified = {
            symbol = "[+]",
            highlight = "NeoTreeModified",
          },
          name = {
            trailing_slash = false,
            use_git_status_colors = true,
          },
          git_status = {
            symbols = {
              -- Change type
              added = "", -- or "✚", but this is redundant info if you use git_status_colors on the name
              modified = "", -- or "", but this is redundant info if you use git_status_colors on the name
              deleted = "✖", -- this can only be used in the git_status source
              renamed = "", -- this can only be used in the git_status source
              -- Status type
              untracked = "",
              ignored = "",
              unstaged = "",
              staged = "",
              conflict = "",
            },
          },
        },
        window = {
          position = "left",
          width = 40,
          mapping_options = {
            noremap = true,
            nowait = true,
          },
          mappings = {
            ["<space>"] = {
              "toggle_node",
              nowait = false, -- disable `nowait` if you have existing combos starting with this char that you want to use
            },
            ["<2-LeftMouse>"] = "open",
            ["<cr>"] = "open",
            ["S"] = "open_split",
            ["s"] = "open_vsplit",
            ["t"] = "open_tabnew",
            ["w"] = "open_with_window_picker",
            ["C"] = "close_node",
            ["a"] = "add",
            ["A"] = "add_directory",
            ["d"] = "delete",
            ["r"] = "rename",
            ["y"] = "copy_to_clipboard",
            ["x"] = "cut_to_clipboard",
            ["p"] = "paste_from_clipboard",
            ["c"] = "copy", -- takes text input for destination
            ["m"] = "move", -- takes text input for destination
            ["q"] = "close_window",
            ["R"] = "refresh",
          },
        },
        nesting_rules = {},
        filesystem = {
          filtered_items = {
            visible = false, -- when true, they will just be displayed differently than normal items
            hide_dotfiles = true,
            hide_gitignored = true,
            hide_by_name = {
              ".DS_Store",
              "thumbs.db",
              --"node_modules"
            },
            hide_by_pattern = { -- uses glob style patterns
              --"*.meta"
            },
            never_show = { -- remains hidden even if visible is toggled to true
              --".DS_Store",
              --"thumbs.db"
            },
          },
          follow_current_file = true, -- This will find and focus the file in the active buffer every
          -- time the current file is changed while the tree is open.
          hijack_netrw_behavior = "open_default", -- netrw disabled, opening a directory opens neo-tree
          -- in whatever position is specified in window.position
          -- "open_current",  -- netrw disabled, opening a directory opens within the
          -- window like netrw would, regardless of window.position
          -- "disabled",    -- netrw left alone, neo-tree does not handle opening dirs
          use_libuv_file_watcher = false, -- This will use the OS level file watchers to detect changes
          -- instead of relying on nvim autocmd events.
          window = {
            mappings = {
              ["<bs>"] = "navigate_up",
              ["."] = "set_root",
              ["H"] = "toggle_hidden",
              ["/"] = "fuzzy_finder",
              ["f"] = "filter_on_submit",
              ["<c-x>"] = "clear_filter",
            },
          },
        },
        buffers = {
          show_unloaded = true,
          window = {
            mappings = {
              ["bd"] = "buffer_delete",
              ["<bs>"] = "navigate_up",
              ["."] = "set_root",
            },
          },
        },
        git_status = {
          window = {
            position = "float",
            mappings = {
              ["A"] = "git_add_all",
              ["gu"] = "git_unstage_file",
              ["ga"] = "git_add_file",
              ["gr"] = "git_revert_file",
              ["gc"] = "git_commit",
              ["gp"] = "git_push",
              ["gg"] = "git_commit_and_push",
            },
          },
        },
      })

      vim.cmd([[nnoremap \ :Neotree reveal<cr>]])
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
    "michaelb/sniprun",
    run = "bash ./install.sh",
    config = function()
      require("sniprun").setup({
        display = {
          "TempFloatingWindow", --# display results in a floating window
          -- "Classic",                 --# display results in the command-line  area
          -- "VirtualTextOk",           --# display ok results as virtual text (multiline is shortened)
          -- "VirtualTextErr",          --# display error results as virtual text
          -- "LongTempFloatingWindow",  --# same as above, but only long results. To use with VirtualText__
          -- "Terminal",                --# display results in a vertical split
          -- "TerminalWithCode",        --# display results and code history in a vertical split
          -- "NvimNotify",              --# display with the nvim-notify plugin
          -- "Api"                      --# return output to a programming interface
        },
        borders = "single",
      })
      local api = vim.api
      api.nvim_set_keymap("n", "<leader>r", "<Plug>SnipRun<CR>", { silent = true, noremap = true })
      api.nvim_set_keymap("n", "<leader>rf", "<Plug>SnipRunOperator<CR>", { silent = true, noremap = true })
      api.nvim_set_keymap("v", "<leader>r", "<Plug>SnipRun<CR>", { silent = true, noremap = true })
      api.nvim_set_keymap("n", "<leader>rq", "<Plug>SnipClose<CR>", { silent = true, noremap = true })
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
    end,
  })
  use({
    "terrortylor/nvim-comment",
    config = function()
      require("nvim_comment").setup()
    end,
  })
  use({
    "dense-analysis/ale",
    config = function()
      vim.api.nvim_set_keymap("n", "<Leader>f", ":ALEFix<CR>", { silent = true })
      vim.g.ale_linters = { python = { "mypy" } }
      vim.cmd([[
      let g:ale_fixers = {
        \ '*': ['remove_trailing_lines', 'trim_whitespace'],
        \ 'python': ['black', 'isort'],
        \ 'css': ['prettier'],
        \ 'html': ['prettier'],
        \ 'javascript': ['prettier'],
        \ 'typescript': ['prettier'],
        \ 'json': ['prettier'],
        \ 'vue': ['prettier'],
        \ 'markdown': ['prettier'],
        \ 'dart': ['dartfmt'],
        \ 'r': ['styler'],
        \ 'lua': ['stylua'],
        \}
        ]])
      vim.g.ale_python_black_options = "-l 88"
      vim.g.ale_python_isort_options = "-l 88"
      vim.g.ale_python_mypy_options = "--ignore-missing-imports"
      vim.g.ale_python_mypy_options = "--ignore-missing-imports"
      vim.g.ale_lua_stylua_options = "--indent-type 'Spaces' --indent-width 2"
    end,
  })
  use({
    "folke/trouble.nvim",
    requires = "kyazdani42/nvim-web-devicons",
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
    requires = { "kyazdani42/nvim-web-devicons", opt = true },
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
    "anuvyklack/pretty-fold.nvim",
    config = function()
      require("pretty-fold").setup()
      require("pretty-fold.preview").setup()
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
        enable = true, -- boolean: enable transparent
        extra_groups = { -- table/string: additional groups that should be cleared
          -- In particular, when you set it to 'all', that means all available groups
          -- example of akinsho/nvim-bufferline.lua
          "BufferLineTabClose",
          "BufferlineBufferSelected",
          "BufferLineFill",
          "BufferLineBackground",
          "BufferLineSeparator",
          "BufferLineIndicatorSelected",
        },
        exclude = {}, -- table: groups you don't want to clear
      })
    end,
  })

  -- Automatically set up your configuration after cloning packer.nvim
  -- Put this at the end after all plugins
  if packer_bootstrap then
    require("packer").sync()
  end
end)
