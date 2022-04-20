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
