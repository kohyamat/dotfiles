" ==================================================
" === General settings =============================
" ==================================================
let mapleader = ";"
let maplocalleader = ","

set mouse=a
set noerrorbells
set backspace=indent,eol,start
set clipboard+=unnamedplus
set pastetoggle=<F12>
set nrformats-=octal
set timeout ttimeout
set timeoutlen=750
set ttimeoutlen=250
set updatetime=1500
if has('nvim')
  set ttimeoutlen=-1
endif
" Do not display completion messages
set shortmess+=c

" Python PATH
if !isdirectory(expand('~/.pyenv'))
  let g:python3_host_prog = $PYENV_ROOT . '/shims/python3'
endif

" Appearance ---------------------------------------
set title
set number
set ruler
set cursorline
set cursorcolumn
"hi clear CursorLine
set list
set listchars=tab:▸\ ,trail:_,extends:»,precedes:«,nbsp:%
set cmdheight=2
set laststatus=2
set linespace=0
set showcmd
set pumheight=40
set previewheight=15
set guifont=Menlo\ 12
set guifontwide=Menlo\ 12
set guioptions+=a

" Neovim
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

" Wildmenu -----------------------------------------
set wildmenu
set wildmode=list:longest,full
set wildoptions=tagfile
set wildignorecase
set wildignore+=.git,*.pyc,*.spl,*.o,*.out,*~,#*#,%*
set wildignore+=*.jpg,*.jpeg,*.png,*.gif,*.zip,**/tmp/**,*.DS_Store

" Backup -------------------------------------------
set nowritebackup
set nobackup
set noswapfile

" Search -------------------------------------------
set incsearch
set ignorecase
set smartcase
set wrapscan
set hlsearch
set showmatch

" Tabs and indents ---------------------------------
set shiftwidth=2
set tabstop=2
set softtabstop=0
set expandtab
set smarttab
set autoindent
set smartindent
" set cindent
set shiftround
"set nowrap
set textwidth=0

" Folds --------------------------------------------
set foldenable
" set foldmethod=marker
set foldmethod=syntax
set foldminlines=5
set foldnestmax=3
set foldcolumn=2

" Mappings -----------------------------------------
" Emacs-like keybindings on insert mode
" inoremap <C-h> <LEFT>
" inoremap <C-b> <LEFT>
" inoremap <C-l> <RIGHT>
" inoremap <C-f> <RIGHT>
" inoremap <C-a> <HOME>
" inoremap <C-e> <END>
" inoremap <C-d> <DELETE>

" vv select to end line
vnoremap v $h

" Window
nnoremap s <Nop>
nnoremap ss :split<CR>
nnoremap sv :vsplit<CR>
nnoremap tt :tabnew<CR>
nnoremap tl :tabnext<CR>
nnoremap th :tabprevious<CR>
nnoremap tw :tabclose<CR>

" Move to other buffer
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-h> <C-w>h
nnoremap <C-l> <C-w>l

" Change buffer size
nnoremap sh <C-w><
nnoremap sj <C-w>-
nnoremap sk <C-w>+
nnoremap sl <C-w>>
nnoremap sH <C-w>H
nnoremap sJ <C-w>J
nnoremap sK <C-w>K
nnoremap sL <C-w>L

" Toggle Paste Mode
nnoremap <silent> ,p :<C-u>set paste!<CR>
      \:<C-u>echo("Toggle PasteMode => " . (&paste == 0 ? "off" : "On"))<CR>

" Search
" When jump to searching term, the term set center of display.
nnoremap n nzz
nnoremap N Nzz
nnoremap * *zz
nnoremap # #zz
nnoremap g* g*zz
nnoremap g# g#zz

" Stop highlight
nnoremap <silent> <Esc><Esc> :nohlsearch<CR>

" Get away from inside [], (), {}, «», '', "", **
" inoremap <c-g> <esc>/[)}*"»'`\]*]<cr>:nohl<cr>a
" nnoremap <c-g> /[)}*"»'`\]*]<cr>:nohl<cr>a

" Terminal mode
if has('nvim')
  tnoremap <esc><esc> <C-\><C-n>
  tnoremap <C-h> <C-\><C-n><C-w>h
  tnoremap <C-j> <C-\><C-n><C-w>j
  tnoremap <C-k> <C-\><C-n><C-w>k
  tnoremap <C-l> <C-\><C-n><C-w>l
endif

" ==================================================
" === Plugin Manager  ==============================
" ==================================================
" Vim-plug
if has('vim_starting')
  set rtp+=~/.config/nvim/plugged/vim-plug
  if !isdirectory(expand('~/.config/nvim/plugged/vim-plug'))
    echo 'Installing vim-plug...'
    call system('mkdir -p ~/.config/nvim/plugged/vim-plug')
    call system('git clone https://github.com/junegunn/vim-plug.git
          \ ~/.config/nvim/plugged/vim-plug/autoload')
    echo 'Done.'
  end
endif

call plug#begin('~/.config/nvim/plugged')

Plug 'junegunn/vim-plug', {'dir': '~/.config/nvim/plugged/vim-plug/autoload'}

" Completion & Language Server Protocol
Plug 'prabirshrestha/vim-lsp'
Plug 'mattn/vim-lsp-settings'
Plug 'mattn/vim-lsp-icons'
Plug 'prabirshrestha/async.vim'
Plug 'prabirshrestha/asyncomplete.vim'
Plug 'prabirshrestha/asyncomplete-lsp.vim'
Plug 'prabirshrestha/asyncomplete-buffer.vim'
Plug 'prabirshrestha/asyncomplete-file.vim'
Plug 'dense-analysis/ale'
Plug 'hrsh7th/vim-vsnip'
Plug 'hrsh7th/vim-vsnip-integ'
Plug 'microsoft/vscode-python'
Plug 'Ikuyadeu/vscode-R'
Plug 'xabikos/vscode-javascript'

" Syntax
Plug 'Vimjas/vim-python-pep8-indent'
Plug 'vim-ruby/vim-ruby'
Plug 'keith/swift.vim'
Plug 'dag/vim-fish'
Plug 'cespare/vim-toml'
Plug 'hail2u/vim-css3-syntax'
Plug 'elzr/vim-json'
Plug 'lindemann09/jags.vim'
Plug 'mdlerch/mc-stan.vim'
Plug 'dart-lang/dart-vim-plugin'
Plug 'thosakwe/vim-flutter'
Plug 'posva/vim-vue'

" Runner
Plug 'skywind3000/asyncrun.vim'

" Python
Plug 'tmhedberg/simpylfold', { 'for': 'python' }
if empty(globpath(&rtp, 'plugin/ipy.vim'))
  Plug 'bfredl/nvim-ipy'
else
  Plug 'bfredl/nvim-ipy', { 'do': ':UpdateRemotePlugins' }
endif

" R
Plug 'jalvesaq/Nvim-R', { 'for' : 'r' }

" Markdown
Plug 'plasticboy/vim-markdown', { 'for': 'markdown' }
Plug 'iamcco/markdown-preview.nvim', { 'do': { -> mkdp#util#install() } }
Plug 'previm/previm'
Plug 'tyru/open-browser.vim'

" Rst
Plug 'Rykka/InstantRst'

" Vim8
if !has('nvim')
  Plug 'roxma/vim-hug-neovim-rpc'
endif

" Misc
Plug 'cocopon/iceberg.vim'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'tpope/vim-surround'
Plug 'easymotion/vim-easymotion'
Plug 'rhysd/accelerated-jk'
Plug 'tyru/caw.vim'
Plug 'kana/vim-smartchr'
Plug 'Shougo/context_filetype.vim'
" Plug 'osyo-manga/vim-precious'
Plug 'alvan/vim-closetag'
Plug 'Konfekt/FastFold'
Plug 'dhruvasagar/vim-table-mode'
Plug 'Raimondi/delimitMate'
if has('nvim')
  if empty(globpath(&rtp, 'plugin/denite.vim'))
    Plug 'Shougo/denite.nvim'
  else
    Plug 'Shougo/denite.nvim', { 'do': ':UpdateRemotePlugins' }
  endif
  if empty(globpath(&rtp, 'plugin/defx.vim'))
    Plug 'Shougo/defx.nvim'
  else
    Plug 'Shougo/defx.nvim', { 'do': ':UpdateRemotePlugins' }
  endif
else
  Plug 'Shougo/denite.nvim'
  Plug 'Shougo/defx.nvim'
  Plug 'roxma/nvim-yarp'
  Plug 'roxma/vim-hug-neovim-rpc'
endif
Plug 'Shougo/neomru.vim'
Plug 'Shougo/vimproc.vim', {'do': 'make'}
Plug 'mechatroner/rainbow_csv'

call plug#end()

" Install plugins at the first time
if empty(globpath(&rtp, 'autoload/lsp.vim'))
  echo 'Installing plugins...'
  :PlugInstall4
endif

" ==================================================
" === Plugin configurations ========================
" ==================================================
" colorscheme
colorscheme iceberg
hi Normal ctermbg=NONE guibg=NONE
hi EndOfBuffer ctermbg=NONE guibg=NONE
hi NonText ctermbg=NONE guibg=NONE
hi Pmenu ctermbg=235 ctermfg=245 guibg=#1e2132 guifg=#686f9a

" vim-airline --------------------------------------
let g:airline#extensions#tabline#buffer_idx_mode = 1
let g:airline#extensions#tabline#enabled = 1
let g:airline_detect_iminsert = 1
let g:airline_powerline_fonts = 0
let g:airline_skip_empty_sections = 1
let g:unite_force_overwrite_statusline = 0
let g:vimfiler_force_overwrite_statusline = 0
let g:airline#extensions#tagbar#enabled = 1
let g:airline_mode_map = {}
let g:airline_mode_map = {
      \ '__' : '-',
      \ 'n'  : 'N',
      \ 'i'  : 'I',
      \ 'R'  : 'R',
      \ 'c'  : 'C',
      \ 'v'  : 'V',
      \ 'V'  : 'V',
      \ 's'  : 'S',
      \ 'S'  : 'S',
      \ }
if !exists('g:airline_symbols')
  let g:airline_symbols = {}
endif
let g:airline_left_sep = ' '
let g:airline_left_alt_sep = ': '
let g:airline_right_sep = ' '
let g:airline_right_alt_sep = ': '
let g:airline_symbols.crypt = '🔒'
let g:airline_symbols.linenr = '␤'
let g:airline_symbols.linenr = '¶'
let g:airline_symbols.maxlinenr = '☰'
let g:airline_symbols.maxlinenr = ''
let g:airline_symbols.branch = '⎇'
let g:airline_symbols.paste = 'ρ'
let g:airline_symbols.paste = 'Þ'
let g:airline_symbols.paste = '∥'
let g:airline_symbols.notexists = '∄'
let g:airline_symbols.whitespace = 'ws'
let g:airline_theme = 'iceberg'

" Denite -------------------------------------------
autocmd FileType denite call s:denite_my_settings()
function! s:denite_my_settings() abort
  " define mappings
  nnoremap <silent><buffer><expr> <CR>
        \ denite#do_map('do_action')
  nnoremap <silent><buffer><expr> d
        \ denite#do_map('do_action', 'delete')
  nnoremap <silent><buffer><expr> p
        \ denite#do_map('do_action', 'preview')
  nnoremap <silent><buffer><expr> q
        \ denite#do_map('quit')
  nnoremap <silent><buffer><expr> i
        \ denite#do_map('open_filter_buffer')
  nnoremap <silent><buffer><expr> <Space>
        \ denite#do_map('toggle_select').'j'
endfunction

nmap <silent> <C-u><C-t> :<C-u>Denite filetype -direction=belowright<CR>
nmap <silent> <C-u><C-b> :<C-u>Denite buffer -direction=belowright<CR>
nmap <silent> <C-u><C-f> :<C-u>Denite file/rec -direction=belowright<CR>
nmap <silent> <C-u><C-l> :<C-u>Denite line -direction=belowright<CR>
nmap <silent> <C-u><C-g> :<C-u>Denite grep -direction=belowright<CR>
nmap <silent> <C-u><C-]> :<C-u>DeniteCursorWord grep -direction=belowright<CR>
nmap <silent> <C-u><C-u> :<C-u>Denite file_mru -direction=belowright<CR>
nmap <silent> <C-u><C-y> :<C-u>Denite neoyank -direction=belowright<CR>
nmap <silent> <C-u><C-r> :<C-u>Denite -resume<CR>
nmap <silent> <C-u>; :<C-u>Denite -resume -immediately -select=+1<CR>
nmap <silent> <C-u>- :<C-u>Denite -resume -immediately -select=-1<CR>
nmap <silent> <C-u><C-d> :<C-u>call denite#start([{'name': 'file/rec', 'args': ['~/dotfiles']}])<CR>
nnoremap ml :<C-u>call denite#start([{'name': 'file/rec', 'args': [g:memolist_path]}])<CR>

" Settings from denite-examples
autocmd FileType denite-filter call s:denite_filter_my_settings()
function! s:denite_filter_my_settings() abort
  imap <silent><buffer> <C-o> <Plug>(denite_filter_quit)
endfunction

" Change file/rec command.
if executable('rg')
  call denite#custom#var('file/rec', 'command',
        \ ['rg', '--files', '--glob', '!.git'])
  call denite#custom#var('grep', 'command', ['rg', '--threads', '1'])
  call denite#custom#var('grep', 'recursive_opts', [])
  call denite#custom#var('grep', 'final_opts', [])
  call denite#custom#var('grep', 'separator', ['--'])
  call denite#custom#var('grep', 'default_opts',
        \ ['--vimgrep', '--no-heading'])
else
  call denite#custom#var('file/rec', 'command',
        \ ['ag', '--follow', '--nocolor', '--nogroup', '-g', ''])
endif


" Change matchers.
call denite#custom#source(
      \ 'file_mru', 'matchers', ['matcher/fuzzy', 'matcher/project_files'])
" call denite#custom#source(
"      \ 'file/rec', 'matchers', ['matcher/cpsm'])

" Change sorters.
call denite#custom#source(
      \ 'file/rec', 'sorters', ['sorter/sublime'])

" " Change default action.
" call denite#custom#kind('file', 'default_action', 'split')

" Add custom menus
let s:menus = {}

let s:menus.my_commands = {
      \ 'description': 'Example commands'
      \ }
let s:menus.my_commands.command_candidates = [
      \ ['Split the window', 'vnew'],
      \ ['Open zsh menu', 'Denite menu:zsh'],
      \ ['Format code', 'FormatCode', 'go,python'],
      \ ]

call denite#custom#var('menu', 'menus', s:menus)

" Ag command on grep source
call denite#custom#var('grep', 'command', ['ag'])
call denite#custom#var('grep', 'default_opts', ['-i', '--vimgrep'])
call denite#custom#var('grep', 'recursive_opts', [])
call denite#custom#var('grep', 'pattern_opt', [])
call denite#custom#var('grep', 'separator', ['--'])
call denite#custom#var('grep', 'final_opts', [])

" Define alias
call denite#custom#alias('source', 'file/rec/git', 'file/rec')
call denite#custom#var('file/rec/git', 'command',
      \ ['git', 'ls-files', '-co', '--exclude-standard'])

call denite#custom#alias('source', 'file/rec/py', 'file/rec')
call denite#custom#var('file/rec/py', 'command',
      \ ['scantree.py', '--path', ':directory'])

" Change ignore_globs
call denite#custom#filter('matcher/ignore_globs', 'ignore_globs',
      \ [ '.git/', '.ropeproject/', '__pycache__/',
      \   'venv/', 'images/', '*.min.*', 'img/', 'fonts/',
      \   '.mypy_cache/'])

call denite#custom#var(
     \ 'buffer', 'exclude_filetypes', ['denite', 'nvim-ipy'])

" Custom action
" Note: lambda function is not supported in Vim8.
call denite#custom#action('file', 'test',
      \ {context -> execute('let g:foo = 1')})
call denite#custom#action('file', 'test2',
      \ {context -> denite#do_action(
      \  context, 'open', context['targets'])})

" Floating window
let s:denite_win_width_percent = 0.85
let s:denite_win_height_percent = 0.7

" Change denite default options
call denite#custom#option('default', {
      \ 'split': 'floating',
      \ 'winwidth': float2nr(&columns * s:denite_win_width_percent),
      \ 'wincol': float2nr((&columns - (&columns * s:denite_win_width_percent)) / 2),
      \ 'winheight': float2nr(&lines * s:denite_win_height_percent),
      \ 'winrow': float2nr((&lines - (&lines * s:denite_win_height_percent)) / 2),
      \ })

" Defx ---------------------------------------------
call defx#custom#column('icon', {
      \ 'directory_icon': '▸',
      \ 'opened_icon': '▾',
      \ 'root_icon': ' ',
      \ })

call defx#custom#column('mark', {
      \ 'readonly_icon': '✗',
      \ 'selected_icon': '✓',
      \ })

call defx#custom#column('filename', {
      \ 'min_width': 40,
      \ 'max_width': 40,
      \ })

call defx#custom#option('_', {
      \ 'columns': 'mark:indent:icon:filename:typee',
      \ })

function! Root(path) abort
  return fnamemodify(a:path, ':t')
endfunction

call defx#custom#source('file', {
      \ 'root': 'Root',
      \})

nnoremap <silent><buffer><expr> > defx#do_action('resize',
      \ defx#get_context().winwidth + 10)
nnoremap <silent><buffer><expr> < defx#do_action('resize',
      \ defx#get_context().winwidth - 10)

nnoremap <silent><C-e> :Defx `expand('%:p:h')` -search=`expand('%:p')`
      \ -split=vertical -winwidth=40 -direction=topleft<CR>

autocmd FileType defx call s:defx_my_settings()
function! s:defx_my_settings() abort
  " Define mappings
  nnoremap <silent><buffer><expr> <CR>
        \ defx#do_action('drop')
  " nnoremap <silent><buffer><expr> <CR>
  "      \ defx#do_action('open')
  nnoremap <silent><buffer><expr> c
        \ defx#do_action('copy')
  nnoremap <silent><buffer><expr> m
        \ defx#do_action('move')
  nnoremap <silent><buffer><expr> p
        \ defx#do_action('paste')
  nnoremap <silent><buffer><expr> l
        \ defx#do_action('open')
  nnoremap <silent><buffer><expr> E
        \ defx#do_action('open', 'vsplit')
  nnoremap <silent><buffer><expr> P
        \ defx#do_action('open', 'pedit')
  nnoremap <silent><buffer><expr> o
        \ defx#do_action('open_or_close_tree')
  nnoremap <silent><buffer><expr> K
        \ defx#do_action('new_directory')
  nnoremap <silent><buffer><expr> N
        \ defx#do_action('new_file')
  nnoremap <silent><buffer><expr> M
        \ defx#do_action('new_multiple_files')
  nnoremap <silent><buffer><expr> C
        \ defx#do_action('toggle_columns',
        \                'mark:indent:icon:filename:type:size:time')
  nnoremap <silent><buffer><expr> S
        \ defx#do_action('toggle_sort', 'time')
  nnoremap <silent><buffer><expr> d
        \ defx#do_action('remove')
  nnoremap <silent><buffer><expr> r
        \ defx#do_action('rename')
  nnoremap <silent><buffer><expr> !
        \ defx#do_action('execute_command')
  nnoremap <silent><buffer><expr> x
        \ defx#do_action('execute_system')
  nnoremap <silent><buffer><expr> yy
        \ defx#do_action('yank_path')
  nnoremap <silent><buffer><expr> .
        \ defx#do_action('toggle_ignored_files')
  nnoremap <silent><buffer><expr> ;
        \ defx#do_action('repeat')
  nnoremap <silent><buffer><expr> h
        \ defx#do_action('cd', ['..'])
  nnoremap <silent><buffer><expr> ~
        \ defx#do_action('cd')
  nnoremap <silent><buffer><expr> q
        \ defx#do_action('quit')
  nnoremap <silent><buffer><expr> <Space>
        \ defx#do_action('toggle_select') . 'j'
  nnoremap <silent><buffer><expr> *
        \ defx#do_action('toggle_select_all')
  nnoremap <silent><buffer><expr> j
        \ line('.') == line('$') ? 'gg' : 'j'
  nnoremap <silent><buffer><expr> k
        \ line('.') == 1 ? 'G' : 'k'
  nnoremap <silent><buffer><expr> <C-l>
        \ defx#do_action('redraw')
  nnoremap <silent><buffer><expr> <C-g>
        \ defx#do_action('print')
  nnoremap <silent><buffer><expr> cd
        \ defx#do_action('change_vim_cwd')
endfunction

" vim-easymotion -----------------------------------
map <Leader>l <Plug>(easymotion-lineforward)
map <Leader>j <Plug>(easymotion-j)
map <Leader>k <Plug>(easymotion-k)
map <Leader>h <Plug>(easymotion-linebackward)
let g:EasyMotion_startofline = 0
let g:EasyMotion_show_prompt = 0
let g:EasyMotion_verbose = 0

" accelerated-jk -----------------------------------
nmap <silent>j <Plug>(accelerated_jk_gj)
nmap <silent>k <Plug>(accelerated_jk_gk)

" smartchr -----------------------------------------
inoremap <expr> , smartchr#one_of(', ', ',')

augroup MyAutoCmd
  autocmd FileType python inoremap <expr> =
        \ smartchr#one_of(' = ', '=', ' == ')
  autocmd FileType javascript inoremap <buffer> <expr> =
        \ smartchr#loop(' = ', '=', ' == ', ' => ')
  autocmd FileType r
        \ inoremap <buffer> <expr> _ smartchr#loop('_', ' <- ', ' -> ')
        \| inoremap <buffer> <expr> ! smartchr#loop('!', ' != ')
augroup END

" delimitMate --------------------------------------
let g:delimitMate_autoclose = 1
let g:delimitMate_matchpairs = "(:),[:],{:},<:>"
let g:delimitMate_jump_expansion = 1
let g:delimitMate_expand_space = 1
let g:delimitMate_expand_cr = 1
let g:delimitMate_expand_inside_quotes = 0
" make compatible with vim-closetag
autocmd FileType html,vue
      \ let b:delimitMate_matchpairs = "(:),[:],{:}"

" context_filetype ---------------------------------
if !exists('g:context_filetype#filetypes')
  let g:context_filetype#filetypes = {}
endif
let g:context_filetype#filetypes = {
      \ 'toml'  : [
      \   {
      \     'start' : '^\s*hook_\(add\|source\|post_source\)\s*=\s*\('.'""'.'"'.'\|'."''"."'".'\)',
      \     'end' : '\2',
      \     'filetype'  :'vim',
      \   }
      \ ],
      \ 'r'  : [
      \   {
      \     'start' : '^\s*stan_.*\s*\(=\|<-\)\s*\('."''"."'".'\|'."'".'\)',
      \     'end' : '\2',
      \     'filetype'  : 'stan',
      \   }
      \ ],
      \ }

" asyncrun -----------------------------------------
let g:asyncrun_open = 8
" let $PYTHONUNBUFFERED = 1
noremap <Leader>t :call asyncrun#quickfix_toggle(8)<cr>

augroup python_file
  autocmd!
  autocmd FileType python nnoremap <silent> <Leader>r :AsyncRun python3 -u "%"<CR>
  autocmd FileType python vnoremap <silent> <Leader>r :'<,'>AsyncRun -raw python3 -u<CR>
augroup END

augroup r_file
  autocmd!
  autocmd FileType r nnoremap <silent> <Leader>r :AsyncRun Rscript "%"<CR>
augroup END

augroup javascript_file
  autocmd!
  autocmd FileType javascript nnoremap <silent> <Leader>r :AsyncRun node "%"<CR>
augroup END

augroup dart_file
  autocmd!
  autocmd FileType dart nnoremap <silent> <Leader>r :AsyncRun dart "%"<CR>
augroup END

augroup swift_file
  autocmd!
  autocmd FileType swift nnoremap <silent> <Leader>r :AsyncRun swift "%"<CR>
augroup END

" Nvim-R -------------------------------------------
let R_assign = 0
" let R_vsplit = 1
" let R_rconsole_height = 25
let R_objbr_place = "console,above"
let R_nvimpager = 'tab'
let R_show_args_help = 0
let R_wait_reply = 1
let R_csv_delim = ','

" nvim-ipy -----------------------------------------
autocmd FileType python
      \ map <silent><LocalLeader><Space> <Plug>(IPy-Run)
      \| map <silent><C-c> <Plug>(IPy-Interrupt)
      \| map <silent><C-x> <Plug>(IPy-Complete)
      \| map <silent><LocalLeader>rh <Plug>(IPy-WordObjInfo)
      \| nnoremap <LocalLeader>c :call IPyRun('close("all")',1)<cr>
      \| nnoremap <LocalLeader>rf :call StartIPython()<cr>
      \| nnoremap <LocalLeader>rq :call QuitIPython()<cr>

function! StartIPython()
  call QuitIPython()
  call IPyConnect("--no-window")
  " vertical ball
  vertical rightbelow 80split [jupyter]
  setfiletype nvim-ipy
  wincmd h
endfunction

function! QuitIPython()
  let s:bufNr = bufnr("$")
  while s:bufNr > 0
    if (matchstr(bufname(s:bufNr), "^\[jupyter") ==  "[jupyter") && buflisted(s:bufNr)
      call setbufvar(s:bufNr, "&bl", 0)
      call IPyTerminate()
      execute "bd! ".s:bufNr
    endif
    let s:bufNr = s:bufNr - 1
  endwhile
endfunction

" vim-markdown -------------------------------------
" let g:vim_markdown_folding_disabled = 1
let g:vim_markdown_folding_style_pythonic = 1
let g:vim_markdown_conceal = 0

" vim-table-mode -----------------------------------
function! s:isAtStartOfLine(mapping)
  let text_before_cursor = getline('.')[0 : col('.')-1]
  let mapping_pattern = '\V' . escape(a:mapping, '\')
  let comment_pattern = '\V' . escape(substitute(&l:commentstring, '%s.*$', '', ''), '\')
  return (text_before_cursor =~? '^' . ('\v(' . comment_pattern . '\v)?') . '\s*\v' . mapping_pattern . '\v$')
endfunction

inoreabbrev <expr> <bar><bar>
      \ <SID>isAtStartOfLine('\|\|') ?
      \ '<c-o>:TableModeEnable<cr><bar><space><bar><left><left>' : '<bar><bar>'
inoreabbrev <expr> __
      \ <SID>isAtStartOfLine('__') ?
      \ '<c-o>:silent! TableModeDisable<cr>' : '__'

let g:table_mode_corner='|'

" Fastfold -----------------------------------------
nmap zuz <Plug>(FastFoldUpdate)
let g:fastfold_savehook = 1
let g:fastfold_fold_command_suffixes =  ['x','X','a','A','o','O','c','C']
let g:fastfold_fold_movement_commands = [']z', '[z', 'zj', 'zk']

let g:markdown_folding = 1
let g:tex_fold_enabled = 1
let g:vimsyn_folding = 'af'
let g:xml_syntax_folding = 1
let g:javaScript_fold = 1
let g:sh_fold_enabled= 7
let g:ruby_fold = 1
let g:perl_fold = 1
let g:perl_fold_blocks = 1
let g:r_syntax_folding = 1
let g:rust_fold = 1
let g:php_folding = 1

" SimpylFold ---------------------------------------
let g:SimpylFold_docstring_preview = 1

" vim-lsp ------------------------------------------
function! s:on_lsp_buffer_enabled() abort
  setlocal omnifunc=lsp#complete
  setlocal signcolumn=yes
  nmap <buffer> gd <plug>(lsp-definition)
  nmap <buffer> <f2> <plug>(lsp-rename)
  inoremap <expr> <cr> pumvisible() ? "\<c-y>\<cr>" : "\<cr>"
endfunction

augroup lsp_install
  au!
  autocmd User lsp_buffer_enabled call s:on_lsp_buffer_enabled()
augroup END

" Debug
command! LspDebug let lsp_log_verbose=1 | let lsp_log_file = expand('~/lsp.log')

let g:lsp_diagnostics_enabled = 1
let g:lsp_diagnostics_echo_cursor = 1
let g:lsp_highlights_enabled = 1
let g:lsp_textprop_enabled = 1
let g:lsp_text_edit_enabled = 1
let g:lsp_virtual_text_enabled = 0

let g:lsp_settings = {
  \ 'pyls': {
  \   'workspace_config': {
  \     'pyls': {
  \       'configurationSources': ['flake8'],
  \       'plugins': {
  \         'pydocstyle': {'enabled': v:true},
  \         'yapf': {'enabled': v:false},
  \       }
  \     }
  \   }
  \ },
  \}

" Folding
" set foldmethod=expr
"       \ foldexpr=lsp#ui#vim#folding#foldexpr()
"       \ foldtext=lsp#ui#vim#folding#foldtext()

" asyncomplete.vim ---------------------------------
" Tab completion
inoremap <expr> <Tab> pumvisible() ? "\<C-n>" : "\<Tab>"
inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"
" inoremap <expr> <CR> pumvisible() ? "\<C-y>" : "\<CR>"

set completeopt-=preview

" Sources
" Buffer
call asyncomplete#register_source(asyncomplete#sources#buffer#get_source_options({
      \ 'name': 'buffer',
      \ 'whitelist': ['*'],
      \ 'completor': function('asyncomplete#sources#buffer#completor'),
      \ 'config': {
      \    'max_buffer_size': 5000000,
      \  },
      \}))

" Files and directories
au User asyncomplete_setup call asyncomplete#register_source(asyncomplete#sources#file#get_source_options({
      \ 'name': 'file',
      \ 'whitelist': ['*'],
      \ 'completor': function('asyncomplete#sources#file#completor')
      \}))

" Debug
command! AscDebug let g:asyncomplete_log_file = expand('~/asyncomplete.log')

" ALE ----------------------------------------------
nmap <silent> <Leader>f <plug>(ale_fix)

let g:ale_linters = {
      \ 'python': ['mypy'],
      \}

let g:ale_fixers = {
      \ '*': ['remove_trailing_lines', 'trim_whitespace'],
      \ 'python': ['black', 'isort'],
      \ 'css': ['prettier'],
      \ 'html': ['prettier'],
      \ 'javascript': ['prettier'],
      \ 'json': ['prettier'],
      \ 'vue': ['prettier'],
      \ 'markdown': ['prettier'],
      \ 'dart': ['dartfmt'],
      \ 'r': ['styler'],
      \}

let g:ale_python_black_options = '-l 88'
let g:ale_python_isort_options = '-l 88'
let g:ale_python_mypy_options = '--ignore-missing-imports'

" vim-vsnip ----------------------------------------
imap <expr> <C-j>   vsnip#available(1)  ? '<Plug>(vsnip-expand)'         : '<C-j>'
imap <expr> <C-l>   vsnip#available(1)  ? '<Plug>(vsnip-expand-or-jump)' : '<C-l>'
smap <expr> <C-l>   vsnip#available(1)  ? '<Plug>(vsnip-expand-or-jump)' : '<C-l>'

" dart-vim-plugin ----------------------------------
let g:dart_style_guide = 1
let dart_html_in_string = v:true
