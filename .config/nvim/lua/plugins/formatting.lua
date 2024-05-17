return {
  "jay-babu/mason-null-ls.nvim",
  event = { "BufReadPre", "BufNewFile" },
  dependencies = {
    "williamboman/mason.nvim",
    "nvimtools/none-ls.nvim",
    "nvim-lua/plenary.nvim",
  },
  config = function()
    require("mason-null-ls").setup({
      ensure_installed = {
        "stylua",
        "clang_format",
        "prettier",
        "black",
        "isort",
        "styler",
        "shfmt",
      },
      handlers = {},
    })

    local null_ls = require("null-ls")
    null_ls.setup({
      sources = {
        null_ls.builtins.formatting.stylua.with({
          extra_args = { "--indent-type", "Spaces", "--indent-width", "2" },
        }),
        null_ls.builtins.formatting.black.with({
          extra_args = { "-l", "120" },
        }),
        null_ls.builtins.formatting.isort.with({
          extra_args = { "-l", "120" },
        }),
      },
    })
  end,
}
