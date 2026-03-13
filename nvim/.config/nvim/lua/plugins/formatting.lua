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
      python = { "isort", "black" },
      rust = { "rustfmt", lsp_format = "fallback" },
      javascript = { "prettierd", "prettier", stop_after_first = true },
      typescript = { "prettierd", "prettier", stop_after_first = true },
      vue = { "prettierd", "prettier", stop_after_first = true },
      r = { "styler" },
      ["_"] = { "trim_whitespace" },
    },
    default_format_opts = {
      lsp_format = "fallback",
    },
    formatters = {
      shfmt = { prepend_args = { "-i", "2" } },
      stylua = { prepend_args = { "--indent-type", "Spaces", "--indent-width", "2" } },
      black = { prepend_args = { "-l", "120" } },
      isort = { prepend_args = { "-l", "120" } },
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
