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
vim.opt.lazyredraw = true
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
vim.opt.listchars = "tab:▸ ,trail:_,extends:»,precedes:«,nbsp:%"
vim.opt.foldenable = true
vim.opt.foldminlines = 5
vim.opt.foldmethod = "expr"
vim.opt.foldexpr = "nvim_treesitter#foldexpr()"
vim.opt.foldcolumn = "2"
vim.opt.foldnestmax = 3

-- Buffer
vim.opt.shiftwidth = 2
vim.opt.tabstop = 2
vim.opt.softtabstop = 0
vim.opt.expandtab = true
vim.opt.autoindent = true
vim.opt.smartindent = true
vim.opt.textwidth = 0

local pyenv_root = os.getenv("PYENV_ROOT")
if pyenv_root then
  vim.g.python3_host_prog = pyenv_root .. "/shims"
end
