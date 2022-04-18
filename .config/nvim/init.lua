-- Options ---------------------------------------
vim.o.mouse = "a"
vim.o.errorbells = false
vim.o.backspace = "indent,eol,start"
vim.o.clipboard = "unnamedplus"
vim.o.pastetoggle = "<F12>"
vim.o.nrformats = "hex"
vim.o.timeout = true
vim.o.ttimeout = true
vim.o.timeoutlen = 750
vim.o.ttimeoutlen = 250
vim.o.updatetime = 1500
vim.o.ruler = true
vim.o.incsearch = true
vim.o.ignorecase = true
vim.o.smartcase = true
vim.o.wrapscan = true
vim.o.hlsearch = true
vim.o.showmatch = true
vim.o.whichwrap = "b,s,h,l,<,>,[,]"
vim.o.lazyredraw = true
vim.o.smarttab = true
vim.o.shiftround = true
vim.o.showcmd = true
vim.o.cmdheight = 2
vim.o.laststatus = 2
vim.o.pumheight = 40
vim.o.previewheight = 15
vim.o.writebackup = false
vim.o.backup = false
vim.o.swapfile = false
vim.o.wildmenu = true
vim.o.wildmode = "list:longest,full"
vim.o.wildoptions = "tagfile"
vim.o.wildignorecase = true

vim.wo.number = true
vim.wo.cursorline = true
vim.wo.cursorcolumn = true
vim.wo.list = true
vim.wo.listchars = "tab:▸ ,trail:_,extends:»,precedes:«,nbsp:%"
vim.wo.foldenable = true
vim.wo.foldminlines = 4
vim.wo.foldmethod = "expr"
vim.wo.foldexpr = "nvim_treesitter#foldexpr()"
vim.wo.foldcolumn = "auto"
vim.wo.foldnestmax = 3

vim.bo.shiftwidth = 2
vim.bo.tabstop = 2
vim.bo.softtabstop = 0
vim.bo.expandtab = true
vim.bo.autoindent = true
vim.bo.smartindent = true
vim.bo.textwidth = 0

local pyenv_root = os.getenv("PYENV_ROOT")
if pyenv_root then
  vim.api.nvim_set_var("python3_host_prog", pyenv_root .. "/shims")
end

vim.cmd([[
if has('nvim')
  " Set terminal colors
  let s:num = 0
  for s:color in [
        \ '#1C2023', '#C7AE95', '#95C7AE', '#AEC795',
        \ '#AE95C7', '#C795AE', '#95AEC7', '#C7CCD1',
        \ '#747C84', '#C7AE95', '#95C7AE', '#AEC795',
        \ '#AE95C7', '#C795AE', '#95AEC7', '#f3f4f5',
        \ '#C7C795', '#C79595', '#393F45', '#565E65',
        \ '#ADB3BA', '#DFE2E5',
        \ ]
    let g:terminal_color_{s:num} = s:color
    let s:num += 1
  endfor

  " Use cursor shape feature
  let $NVIM_TUI_ENABLE_CURSOR_SHAPE = 1

  " Use true color feature
  if exists('+termguicolors')
    set termguicolors
  endif
endif
]])

-- Plugins ---------------------------------------
require("plugins")
vim.cmd([[autocmd BufWritePost plugins.lua PackerCompile]])

-- LSP
local on_attach = function(client, bufnr)
  local function buf_set_keymap(...)
    vim.api.nvim_buf_set_keymap(bufnr, ...)
  end

  -- Enable completion triggered by <c-x><c-o>
  vim.api.nvim_buf_set_option(bufnr, "omnifunc", "v:lua.vim.lsp.omnifunc")

  -- Disable document formatting
  -- client.resolved_capabilities.document_formatting = false

  -- Mappings.
  -- See `:help vim.lsp.*` for documentation on any of the below functions
  local opts = { noremap = true, silent = true }
  buf_set_keymap("n", "gD", "<cmd>lua vim.lsp.buf.declaration()<CR>", opts)
  buf_set_keymap("n", "gd", "<cmd>lua vim.lsp.buf.definition()<CR>", opts)
  buf_set_keymap("n", "<space>k", "<cmd>lua vim.lsp.buf.hover()<CR>", opts)
  buf_set_keymap("n", "gi", "<cmd>lua vim.lsp.buf.implementation()<CR>", opts)
  buf_set_keymap("n", "<space>h", "<cmd>lua vim.lsp.buf.signature_help()<CR>", opts)
  buf_set_keymap("n", "<space>wa", "<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>", opts)
  buf_set_keymap("n", "<space>wr", "<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>", opts)
  buf_set_keymap("n", "<space>wl", "<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>", opts)
  buf_set_keymap("n", "<space>D", "<cmd>lua vim.lsp.buf.type_definition()<CR>", opts)
  buf_set_keymap("n", "<space>rn", "<cmd>lua vim.lsp.buf.rename()<CR>", opts)
  buf_set_keymap("n", "<space>ca", "<cmd>lua vim.lsp.buf.code_action()<CR>", opts)
  buf_set_keymap("n", "gr", "<cmd>lua vim.lsp.buf.references()<CR>", opts)
  buf_set_keymap("n", "<space>f", "<cmd>lua vim.lsp.buf.formatting()<CR>", opts)
end

local lsp_installer = require("nvim-lsp-installer")
lsp_installer.on_server_ready(function(server)
  local opts = {}
  opts.on_attach = on_attach
  opts.capabilities = require("cmp_nvim_lsp").update_capabilities(vim.lsp.protocol.make_client_capabilities())

  if server.name == "sumneko_lua" then
    opts.settings = {
      Lua = {
        runtime = {
          -- Tell the language server which version of Lua you're using (most likely LuaJIT in the case of Neovim)
          version = "LuaJIT",
          -- Setup your lua path
          -- path = runtime_path,
        },
        diagnostics = {
          -- Get the language server to recognize the `vim` global
          globals = { "vim" },
        },
        workspace = {
          -- Make the server aware of Neovim runtime files
          library = vim.api.nvim_get_runtime_file("", true),
          checkThirdParty = false,
        },
        -- Do not send telemetry data containing a randomized but unique identifier
        telemetry = {
          enable = false,
        },
      },
    }
  end

  server:setup(opts)
end)

require("lspconfig").r_language_server.setup({})

-- nvim-cmp
vim.opt.completeopt = "menu,menuone,noselect"
vim.opt.shortmess = vim.opt.shortmess + { c = true }

local cmp = require("cmp")
local lspkind = require("lspkind")
cmp.setup({
  snippet = {
    expand = function(args)
      vim.fn["vsnip#anonymous"](args.body)
    end,
  },
  mapping = {
    ["<C-d>"] = cmp.mapping(cmp.mapping.scroll_docs(-4), { "i", "c" }),
    ["<C-f>"] = cmp.mapping(cmp.mapping.scroll_docs(4), { "i", "c" }),
    ["<C-t>"] = cmp.mapping(cmp.mapping.complete(), { "i", "c" }),
    ["<C-y>"] = cmp.config.disable,
    ["<C-e>"] = cmp.mapping({
      i = cmp.mapping.abort(),
      c = cmp.mapping.close(),
    }),
    ["<CR>"] = cmp.mapping.confirm({ select = false }),
    ["<Tab>"] = cmp.mapping(cmp.mapping.select_next_item(), { "i", "s" }),
    ["<S-Tab>"] = cmp.mapping(cmp.mapping.select_prev_item(), { "i", "s" }),
  },
  sources = cmp.config.sources({
    { name = "nvim_lsp" },
    { name = "vsnip" },
    { name = "path" },
    { name = "nvim_lsp_signature_help" },
    { name = "nvim_lsp_document_symbol" },
    { name = "omni" },
    { name = "treesitter" },
  }, {
    { name = "buffer" },
  }),
  formatting = {
    format = lspkind.cmp_format({
      mode = "symbol_text",
      -- maxwidth = 50,

      before = function(entry, vim_item)
        return vim_item
      end,
    }),
  },
})

-- Use buffer source for `/` (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline("/", {
  mapping = cmp.mapping.preset.cmdline(),
  sources = {
    { name = "buffer" },
  },
})

-- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline(":", {
  mapping = cmp.mapping.preset.cmdline(),
  sources = cmp.config.sources({
    { name = "path" },
  }, {
    { name = "cmdline" },
  }),
})

-- auto-pairs
local npairs = require("nvim-autopairs")
local cmp_autopairs = require("nvim-autopairs.completion.cmp")
cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done({ map_char = { tex = "" } }))
cmp_autopairs.lisp[#cmp_autopairs.lisp + 1] = "racket"
npairs.setup({ map_cr = true })


-- Keymaps ---------------------------------------
local api = vim.api

vim.g.mapleader = ";"
vim.g.maplocalleader = ","

api.nvim_set_keymap("n", "ss", "<cmd>split<CR>", { noremap = true })
api.nvim_set_keymap("n", "sv", "<cmd>vsplit<CR>", { noremap = true })
api.nvim_set_keymap("n", "tt", "<cmd>tabnew<CR>", { noremap = true })
api.nvim_set_keymap("n", "tl", "<cmd>tabnext<CR>", { noremap = true })
api.nvim_set_keymap("n", "th", "<cmd>tabprevious<CR>", { noremap = true })
api.nvim_set_keymap("n", "tw", "<cmd>tabclose<CR>", { noremap = true })
api.nvim_set_keymap("n", "]b", "<cmd>bnext<CR>", { noremap = true, silent = true })
api.nvim_set_keymap("n", "[b", "<cmd>bprevious<CR>", { noremap = true, silent = true })

-- Cursor move
api.nvim_set_keymap("n", "<S-j>", "5j", { noremap = true })
api.nvim_set_keymap("n", "<S-k>", "5k", { noremap = true })
api.nvim_set_keymap("v", "<S-j>", "5j", { noremap = true })
api.nvim_set_keymap("v", "<S-k>", "5k", { noremap = true })

-- Window move
api.nvim_set_keymap("n", "<C-h>", "<C-w>h", { noremap = true })
api.nvim_set_keymap("n", "<C-j>", "<C-w>j", { noremap = true })
api.nvim_set_keymap("n", "<C-k>", "<C-w>k", { noremap = true })
api.nvim_set_keymap("n", "<C-l>", "<C-w>l", { noremap = true })

-- Window size
api.nvim_set_keymap("n", "sh", "<C-w><", { noremap = true })
api.nvim_set_keymap("n", "sj", "<C-w>-", { noremap = true })
api.nvim_set_keymap("n", "sk", "<C-w>+", { noremap = true })
api.nvim_set_keymap("n", "sl", "<C-w>>", { noremap = true })
api.nvim_set_keymap("n", "sH", "<C-w>H", { noremap = true })
api.nvim_set_keymap("n", "sJ", "<C-w>J", { noremap = true })
api.nvim_set_keymap("n", "sK", "<C-w>K", { noremap = true })
api.nvim_set_keymap("n", "sL", "<C-w>L", { noremap = true })

-- Search
api.nvim_set_keymap("n", "n", "nzz", { noremap = true })
api.nvim_set_keymap("n", "N", "Nzz", { noremap = true })
api.nvim_set_keymap("n", "*", "*zz", { noremap = true })
api.nvim_set_keymap("n", "#", "#zz", { noremap = true })
api.nvim_set_keymap("n", "g*", "g*zz", { noremap = true })
api.nvim_set_keymap("n", "g#", "g#zz", { noremap = true })

-- Stop highlight
api.nvim_set_keymap("n", "<esc><esc>", "<cmd>nohlsearch<CR>", { noremap = true, silent = true })

-- Terminal mode
api.nvim_set_keymap("t", "<C-n>", "<C-\\><C-n>", { noremap = true })
api.nvim_set_keymap("t", "<C-h>", "<C-\\><C-n><C-w>h", { noremap = true })
api.nvim_set_keymap("t", "<C-j>", "<C-\\><C-n><C-w>j", { noremap = true })
api.nvim_set_keymap("t", "<C-k>", "<C-\\><C-n><C-w>k", { noremap = true })
api.nvim_set_keymap("t", "<C-l>", "<C-\\><C-n><C-w>l", { noremap = true })

-- Telescope
api.nvim_set_keymap("n", "<leader>ff", "<cmd>Telescope find_files<CR>", { noremap = true })
api.nvim_set_keymap("n", "<localleader>ff", "<cmd>Telescope find_files hidden=true<CR>", { noremap = true })
api.nvim_set_keymap("n", "<leader>fg", "<cmd>Telescope live_grep<CR>", { noremap = true })
api.nvim_set_keymap("n", "<leader>fb", "<cmd>Telescope buffers<CR>", { noremap = true })
api.nvim_set_keymap("n", "<leader>fh", "<cmd>Telescope help_tags<CR>", { noremap = true })

-- Hop
vim.api.nvim_set_keymap(
  "n",
  "<leader>l",
  '<cmd>lua require"hop".hint_words({ direction = require"hop.hint".HintDirection.AFTER_CURSOR, current_line_only = true })<cr>',
  {}
)
vim.api.nvim_set_keymap(
  "n",
  "<leader>h",
  '<cmd>lua require"hop".hint_words({ direction = require"hop.hint".HintDirection.BEFORE_CURSOR, current_line_only = true })<cr>',
  {}
)
vim.api.nvim_set_keymap(
  "n",
  "<leader>j",
  '<cmd>lua require"hop".hint_lines({ direction = require"hop.hint".HintDirection.AFTER_CURSOR })<cr>',
  {}
)
vim.api.nvim_set_keymap(
  "n",
  "<leader>k",
  '<cmd>lua require"hop".hint_lines({ direction = require"hop.hint".HintDirection.BEFORE_CURSOR })<cr>',
  {}
)

-- Trouble
vim.api.nvim_set_keymap("n", "<leader>xx", "<cmd>Trouble<cr>", { silent = true, noremap = true })
vim.api.nvim_set_keymap("n", "<leader>xw", "<cmd>Trouble workspace_diagnostics<cr>", { silent = true, noremap = true })
vim.api.nvim_set_keymap("n", "<leader>xd", "<cmd>Trouble document_diagnostics<cr>", { silent = true, noremap = true })
vim.api.nvim_set_keymap("n", "<leader>xl", "<cmd>Trouble loclist<cr>", { silent = true, noremap = true })
vim.api.nvim_set_keymap("n", "<leader>xq", "<cmd>Trouble quickfix<cr>", { silent = true, noremap = true })
vim.api.nvim_set_keymap("n", "gR", "<cmd>Trouble lsp_references<cr>", { silent = true, noremap = true })
