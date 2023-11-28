return {
  "nvimtools/none-ls.nvim",
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
  dependencies = { "nvim-lua/plenary.nvim" },
}
