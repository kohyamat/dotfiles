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
  use("hrsh7th/vim-vsnip")
  use("hrsh7th/cmp-buffer")
  use("hrsh7th/cmp-path")
  use("hrsh7th/cmp-nvim-lsp-signature-help")

  -- Fuzzy finder
  use({
    "nvim-telescope/telescope.nvim",
    requires = { { "nvim-lua/plenary.nvim" } },
  })
  use({ "nvim-telescope/telescope-fzf-native.nvim", run = "make" })

  -- Colorscheme
  use({
    "cocopon/iceberg.vim",
    -- opt = true,
    config = function()
      vim.cmd("colorscheme iceberg")
      vim.cmd("hi Normal ctermbg=None guibg=None")
      vim.cmd("hi EndOfBuffer ctermbg=None guibg=None")
      vim.cmd("hi NonText ctermbg=None guibg=None")
      vim.cmd("hi Pmenu ctermbg=235 ctermfg=245 guibg=#1e2132 guifg=#686f9a")
    end,
  })

  -- Utility
  use({
    "phaazon/hop.nvim",
    branch = "v1",
    config = function()
      require("hop").setup()
    end,
  })
  use({ "nvim-treesitter/nvim-treesitter", run = ":TSUpdate" })
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
    "kassio/neoterm",
    config = function()
      vim.g.neoterm_autoinsert = 1
      vim.g.neoterm_autoscroll = 1
      vim.g.neoterm_default_mod = "botright"
      vim.g.neoterm_size = 16
      vim.api.nvim_set_keymap("v", "<LocalLeader><Space>", ":TREPLSendSelection<CR>", { silent = true, noremap = true })
      vim.api.nvim_set_keymap("n", "<LocalLeader><Space>", ":TREPLSendLine<CR>", { silent = true, noremap = true })
      vim.api.nvim_set_keymap("n", "<LocalLeader>q", ":Tclose!<CR>", { silent = true, noremap = true })
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
    end,
  })
  use({
    "folke/trouble.nvim",
    requires = "kyazdani42/nvim-web-devicons",
    config = function()
      require("trouble").setup({})
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
          icons_enabled = false,
          section_separators = "",
          component_separators = "",
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

  -- Automatically set up your configuration after cloning packer.nvim
  -- Put this at the end after all plugins
  if packer_bootstrap then
    require("packer").sync()
  end
end)
