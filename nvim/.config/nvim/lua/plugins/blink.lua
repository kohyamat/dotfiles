return {
  "saghen/blink.cmp",
  dependencies = { "L3MON4D3/LuaSnip" },
  version = "1.*",

  ---@module 'blink.cmp'
  ---@type blink.cmp.Config
  opts = {
    keymap = {
      preset = "none",
      ["<CR>"] = { "accept", "fallback" },
      ["<Tab>"] = { "select_next", "snippet_forward", "fallback" },
      ["<S-Tab>"] = { "select_prev", "snippet_backward", "fallback" },
      ["<C-e>"] = { "hide" },
      ["<C-n>"] = { "select_next", "fallback" },
      ["<C-p>"] = { "select_prev", "fallback" },
      ["<Up>"] = { "select_prev", "fallback" },
      ["<Down>"] = { "select_next", "fallback" },
      ["<C-u>"] = { "scroll_documentation_up", "fallback" },
      ["<C-d>"] = { "scroll_documentation_down", "fallback" },
      ["<F5>"] = { "show", "show_documentation", "hide_documentation" },
    },

    appearance = { nerd_font_variant = "mono" },

    completion = {
      list = { selection = { preselect = false, auto_insert = true } },
      documentation = { auto_show = false },
      menu = {
        draw = {
          treesitter = { "lsp" },
          components = {
            kind_icon = {
              text = function(ctx)
                local icon, _, _ = require("mini.icons").get("lsp", ctx.kind)
                if ctx.source_name == "Path" then
                  icon, _, _ = require("mini.icons").get("file", ctx.label)
                end
                return icon .. ctx.icon_gap
              end,
              highlight = function(ctx)
                local _, hl, _ = require("mini.icons").get("lsp", ctx.kind)
                if ctx.source_name == "Path" then
                  _, hl, _ = require("mini.icons").get("file", ctx.label)
                end
                return hl
              end,
            },
          },
        },
      },
    },

    snippets = { preset = "luasnip" },

    sources = {
      -- minuet を削除し、デフォルト構成のみにする
      default = { "lsp", "path", "snippets", "buffer", "cmdline" },
    },

    fuzzy = { implementation = "prefer_rust_with_warning" },
    signature = { enabled = true },
    cmdline = {
      keymap = { preset = "inherit" },
      completion = {
        list = { selection = { preselect = false, auto_insert = true } },
        menu = { auto_show = true },
      },
    },
  },
}
