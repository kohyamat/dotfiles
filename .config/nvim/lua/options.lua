-- Global
vim.opt.mouse = "a"
vim.opt.errorbells = false
vim.opt.backspace = "indent,eol,start"
vim.opt.clipboard = "unnamedplus"
vim.opt.nrformats = "hex"
vim.opt.timeout = true
vim.opt.ttimeout = true
vim.opt.timeoutlen = 750
vim.opt.ttimeoutlen = 250
vim.opt.updatetime = 1500
vim.opt.ruler = true
vim.opt.incsearch = true
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.wrapscan = true
vim.opt.hlsearch = true
vim.opt.showmatch = true
vim.opt.whichwrap = "b,s,h,l,<,>,[,]"
vim.opt.lazyredraw = false
vim.opt.smarttab = true
vim.opt.shiftround = true
vim.opt.showcmd = true
vim.opt.cmdheight = 2
vim.opt.laststatus = 2
vim.opt.pumheight = 40
vim.opt.previewheight = 15
vim.opt.writebackup = false
vim.opt.backup = false
vim.opt.swapfile = false
vim.opt.wildmenu = true
vim.opt.wildmode = "list:longest,full"
vim.opt.wildoptions = "tagfile"
vim.opt.wildignorecase = true
vim.opt.winblend = 20
vim.opt.pumblend = 20
vim.opt.termguicolors = true

-- Window
vim.opt.number = true
vim.opt.cursorline = true
vim.opt.cursorcolumn = true
vim.opt.list = true
vim.opt.signcolumn = "number"
vim.opt.listchars = "tab:▸ ,trail:_,extends:»,precedes:«,nbsp:%"
vim.opt.fillchars = [[eob: ,fold:·,foldopen:,foldsep: ,foldclose:]]
vim.opt.foldenable = false
vim.opt.foldcolumn = "0"
vim.opt.foldminlines = 3
vim.opt.foldnestmax = 2
vim.opt.foldmethod = "expr"
vim.opt.foldexpr = "v:lua.vim.treesitter.foldexpr()"
-- if vim.fn.has("nvim-10") then
--   function MyFoldtext()
--     local text = vim.treesitter.foldtext()
--     local n_lines = vim.v.foldend - vim.v.foldstart
--     local text_lines = " lines"
--     if n_lines == 1 then
--       text_lines = " line"
--     end
--     table.insert(text, { "···[" .. n_lines .. text_lines .. "]", { "Folded" } })
--     return text
--   end
--   vim.opt.foldtext = "v:lua.MyFoldtext()"
-- end

-- Buffer
vim.opt.shiftwidth = 2
vim.opt.tabstop = 2
vim.opt.softtabstop = 0
vim.opt.expandtab = true
vim.opt.autoindent = true
vim.opt.smartindent = true
vim.opt.cindent = true
vim.opt.textwidth = 0

-- Use pyenv python3 if available
local pyenv_root = os.getenv("PYENV_ROOT")
if pyenv_root then
  vim.g.python3_host_prog = pyenv_root .. "/shims/python3"
end

-- Disable auto-comment
vim.api.nvim_create_autocmd("FileType", {
  pattern = "*",
  callback = function()
    vim.opt_local.formatoptions:remove({ "r", "o" })
  end,
})

-- WSL clipboard integration
if vim.fn.has("wsl") == 1 then
  if vim.fn.executable("xsel") == 0 then
    print("xsel is not installed, clipboard integration is disabled.")
    -- vim.g.clipboard = {
    --   name = "WslClipboard",
    --   copy = {
    --     ["+"] = "clip.exe",
    --     ["*"] = "clip.exe",
    --   },
    --   paste = {
    --     ["+"] = 'powershell.exe -c [Console]::Out.Write($(Get-Clipboard -Raw).tostring().replace("`r", ""))',
    --     ["*"] = 'powershell.exe -c [Console]::Out.Write($(Get-Clipboard -Raw).tostring().replace("`r", ""))',
    --   },
    --   cache_enabled = 1,
    -- }
  else
    vim.g.clipboard = {
      name = "WslClipboard",
      copy = {
        ["+"] = "xsel -bi",
        ["*"] = "xsel -bi",
      },
      paste = {
        ["+"] = "xsel -bo",
        ["*"] = function()
          return vim.fn.systemlist('xsel -bo | tr -d "\r"')
        end,
      },
      cache_enabled = 1,
    }
  end
end
