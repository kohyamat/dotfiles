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
vim.wo.foldminlines = 5
vim.wo.foldmethod = "expr"
vim.wo.foldexpr = "nvim_treesitter#foldexpr()"
vim.wo.foldcolumn = "2"
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
set guicursor=

" Use true color feature
if exists('+termguicolors')
  set termguicolors
endif
]])
