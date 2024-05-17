vim.g.mapleader = ";"
vim.g.maplocalleader = ","

vim.keymap.set("n", "ss", ":split<CR>")
vim.keymap.set("n", "sv", ":vsplit<CR>")
vim.keymap.set("n", "tt", ":tabnew<CR>")
vim.keymap.set("n", "tl", ":tabnext<CR>")
vim.keymap.set("n", "th", ":tabprevious<CR>")
vim.keymap.set("n", "tw", ":tabclose<CR>")
vim.keymap.set("n", "]b", ":bnext<CR>")
vim.keymap.set("n", "[b", ":bprevious<CR>")

-- Cursor move
-- vim.keymap.set("n", "<S-j>", "5j")
-- vim.keymap.set("n", "<S-k>", "5k")
-- vim.keymap.set("v", "<S-j>", "5j")
-- vim.keymap.set("v", "<S-k>", "5k")

-- Window move
-- vim.keymap.set("n", "<C-h>", "<C-w>h")
-- vim.keymap.set("n", "<C-j>", "<C-w>j")
-- vim.keymap.set("n", "<C-k>", "<C-w>k")
-- vim.keymap.set("n", "<C-l>", "<C-w>l")

-- Window size
-- vim.keymap.set("n", "sh", "<C-w><")
-- vim.keymap.set("n", "sj", "<C-w>-")
-- vim.keymap.set("n", "sk", "<C-w>+")
-- vim.keymap.set("n", "sl", "<C-w>>")
-- vim.keymap.set("n", "sH", "<C-w>H")
-- vim.keymap.set("n", "sJ", "<C-w>J")
-- vim.keymap.set("n", "sK", "<C-w>K")
-- vim.keymap.set("n", "sL", "<C-w>L")

-- Search
vim.keymap.set("n", "n", "nzz")
vim.keymap.set("n", "N", "Nzz")
vim.keymap.set("n", "*", "*zz")
vim.keymap.set("n", "#", "#zz")
vim.keymap.set("n", "g*", "g*zz")
vim.keymap.set("n", "g#", "g#zz")

-- Stop highlight
vim.keymap.set("n", "<esc><esc>", ":nohlsearch<CR>")

-- Terminal mode
vim.keymap.set("t", "<C-n>", "<C-\\><C-n>")
vim.keymap.set("t", "<C-h>", "<C-\\><C-n><C-w>h")
vim.keymap.set("t", "<C-j>", "<C-\\><C-n><C-w>j")
vim.keymap.set("t", "<C-k>", "<C-\\><C-n><C-w>k")
vim.keymap.set("t", "<C-l>", "<C-\\><C-n><C-w>l")

-- Build and run c++ code
vim.keymap.set("n", "<leader>m", ":!g++ -Wall % && ./a.out<cr>")
