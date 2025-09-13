local keymap = vim.keymap
local opts = { noremap = true, silent = true }

keymap.set("n", "J", "mzJ`z")


-- go down/up
vim.g.mapleader = " "
vim.keymap.set("n", "<leader>pv", "<CMD>Oil<CR>", {desc = "Browse files"})
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv", {desc = "Remove linebreak"})

-- greatest remap ever
keymap.set("x", "<leader>pp", [["_dP]], {desc = "Add new paragraph"})

-- next greatest remap ever : asbjornHaland
keymap.set({"n", "v"}, "<leader>y", [["+y]])
keymap.set("n", "<leader>Y", [["+Y]])

keymap.set({"n", "v"}, "<leader>d", [["_d]])

-- Delete a word backwards
--keymap.set("n", "dw", 'vb"_d', {desc = "Delete work backwards"})

-- Select all
keymap.set("n", "<C-a>", "gg<S-v>G", {desc = "Select all"})

-- Jumplist
keymap.set("n", "<C-m>", "<C-i>", opts)

-- Reload config (TEST)
keymap.set({"n", "v"}, "<leader>sv", ":source $MYVIMRC<CR>", {desc = "Reload config"})

--[[
-- New tab
keymap.set("n", "te", ":tabedit", {desc = "Edit tabs"})
keymap.set("n", "<tab>", ":tabnext<Return>", { noremap = true, silent = true, desc = "Move to next tab"})
keymap.set("n", "<s-tab>", ":tabprev<Return>", { noremap = true, silent = true, desc = "Move to previous tab"})
-- Split window
keymap.set("n", "wsh", ":split<Return>", { noremap = true, silent = true, desc = "Split window horizontally"})
keymap.set("n", "wsv", ":vsplit<Return>", { noremap = true, silent = true, desc = "Split window vertically"})
-- Move window
keymap.set("n", "wl", "<C-w>h", {desc = "Move to left window"})
keymap.set("n", "wu", "<C-w>k", {desc = "Move to upper window"})
keymap.set("n", "wd", "<C-w>j", {desc = "Move to lower window"})
keymap.set("n", "wr", "<C-w>l", {desc = "Move to right window"})

]]--
-- Resize window
--keymap.set("n", "+", [[<cmd>vertical resize +5<cr>]], {desc = "Increase window height"})
--keymap.set("n", "-", [[<cmd>vertical resize -5<cr>]], {desc = "Decrease window height"})
--keymap.set("n", "*", [[<cmd>horizontal resize +2<cr>]], {desc = "Increase window width"})
--keymap.set("n", "_", [[<cmd>horizontal resize -2<cr>]], {desc = "Decrease window width"})
