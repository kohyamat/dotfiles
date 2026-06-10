return {
  "saghen/blink.cmp",
  dependencies = {
    "L3MON4D3/LuaSnip",
    "fang2hou/blink-copilot",
    {
      "milanglacier/minuet-ai.nvim",
      dependencies = { "nvim-lua/plenary.nvim" },
      config = function()
        -- 公式のQwen設定例をベースに、外部サーバーのURLだけを適用
        require("minuet").setup({
          provider = "openai_fim_compatible",
          n_completions = 1,
          context_window = 512,
          provider_options = {
            openai_fim_compatible = {
              api_key = os.getenv("MINUET_API_KEY") or "TERM",
              name = "Ollama",
              -- セキュリティのため、エンドポイントとAPIキーは環境変数から取得するように変更
              end_point = os.getenv("MINUET_API_ENDPOINT") or "http://localhost:11434/v1/completions",
              model = "qwen2.5-coder:7b",
              optional = {
                max_tokens = 56,
                top_p = 0.9,
              },
              -- ★ template や stop などの余計な上書きはすべて削除し、minuetの自動判定に任せる
            },
          },
          autotrigger = {
            enable = true,
          },
        })
      end,
    },
  },
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

    appearance = {
      nerd_font_variant = "mono",
    },

    completion = {
      list = { selection = { preselect = false, auto_insert = true } },
      documentation = { auto_show = false },
      menu = {
        draw = {
          treesitter = { "lsp" },
          components = {
            kind_icon = {
              text = function(ctx)
                -- Copilot の特別対応
                if ctx.source_name == "copilot" then
                  return "" .. ctx.icon_gap
                end
                -- minuet対応
                if ctx.source_name == "minuet" then
                  return "💃" .. ctx.icon_gap
                end
                -- mini.icons を使用してLSPアイコンを取得
                local icon, _, _ = require("mini.icons").get("lsp", ctx.kind)
                -- パスソースの場合はファイル/ディレクトリのアイコンを取得
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
                if ctx.source_name == "minuet" then
                  return "BlinkCmpKindCopilot"
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
      default = { "lsp", "path", "snippets", "buffer", "minuet", "copilot", "cmdline" },
      providers = {
        copilot = {
          name = "copilot",
          module = "blink-copilot",
          score_offset = 100,
          async = true,
        },
        minuet = {
          name = "minuet",
          module = "minuet.blink",
          score_offset = 95,
          async = true,
          timeout_ms = 3000,
        },
      },
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
  opts_extend = { "sources.default" },
}
