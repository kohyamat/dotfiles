return {
  "stevearc/conform.nvim",
  event = { "BufWritePre" },
  cmd = { "ConformInfo" },
  keys = {
    {
      "<leader>f",
      function()
        require("conform").format({ async = true })
      end,
      mode = "",
      desc = "Format buffer",
    },
  },
  opts = {
    formatters_by_ft = {
      sh = { "shfmt" },
      lua = { "stylua" },
      -- Ruff (extremely fast and combines isort + black)
      python = { "ruff_organize_imports", "ruff_format" },
      rust = { "rustfmt", lsp_format = "fallback" },
      javascript = { "prettierd", "prettier", stop_after_first = true },
      typescript = { "prettierd", "prettier", stop_after_first = true },
      vue = { "prettierd", "prettier", stop_after_first = true },
      ["_"] = { "trim_whitespace" },
    },
    default_format_opts = {
      lsp_format = "fallback",
    },
    formatters = {
      shfmt = { prepend_args = { "-i", "2" } },
      stylua = { prepend_args = { "--indent-type", "Spaces", "--indent-width", "2" } },
      styler = {
        args = { "-s", "-e", "styler::style_file(commandArgs(TRUE))", "--args", "$FILENAME" },
        stdin = false,
      },
    },
  },
  init = function()
    vim.o.formatexpr = "v:lua.require'conform'.formatexpr()"
  end,
}
