return {
  "L3MON4D3/LuaSnip",
  version = "v2.*",
  build = "make install_jsregexp",
  dependencies = "rafamadriz/friendly-snippets",
  config = function()
    require("luasnip").setup({})
    require("luasnip.loaders.from_snipmate").lazy_load()
    require("luasnip.loaders.from_lua").lazy_load()
    require("luasnip.loaders.from_vscode").lazy_load({
      paths = {
        vim.fn.stdpath("data") .. "/lazy/friendly-snippets",
        "./snippets",
      },
    })
  end,
}
