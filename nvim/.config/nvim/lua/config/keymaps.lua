vim.g.mapleader = " "

local keymap = vim.keymap

-- Delete a word backwards
keymap.set("n", "dw", 'vb"_d')

-- Select all
keymap.set("n", "<C-a>", "gg<S-v>G")

-- New tab
-- keymap.set("n", "te", ":tabedit")
-- keymap.set("n", "<Tab>", ":bnext<CR>", { silent = true })
-- keymap.set("n", "<S-Tab>", ":bprevious<CR>", { silent = true })

-- Split window
keymap.set("n", "ss", ":split<Return>", opts)
keymap.set("n", "sv", ":vsplit<Return>", opts)

-- Move window
keymap.set("n", "sh", "<C-w>h")
keymap.set("n", "sk", "<C-w>k")
keymap.set("n", "sj", "<C-w>j")
keymap.set("n", "sl", "<C-w>l")

-- Resize window
keymap.set("n", "<C-w><left>", "<C-w><")
keymap.set("n", "<C-w><right>", "<C-w>>")
keymap.set("n", "<C-w><up>", "<C-w>+")
keymap.set("n", "<C-w><down>", "<C-w>-")

-- Move up
keymap.set("v", "J", ":m '>+1<CR>gv=gv")
-- Move down
keymap.set("v", "K", ":m '<-2<CR>gv=gv")

-- greatest remap ever
keymap.set("x", "<leader>p", [["_dP]])

-- next greatest remap ever : asbjornHaland
keymap.set({ "n", "v" }, "<leader>y", [["+y]])
keymap.set("n", "<leader>Y", [["+Y]])

keymap.set({ "n", "v" }, "<leader>d", [["_d]])

-- Copy current file path to clipboard
keymap.set("n", "<leader>fp", function()
  local path = vim.fn.expand("%:p")
  vim.fn.setreg("+", path)
  vim.notify("Copied: " .. path)
end, { desc = "Copy absolute file path" })

keymap.set("n", "<leader>fP", function()
  local path = vim.fn.expand("%")
  vim.fn.setreg("+", path)
  vim.notify("Copied: " .. path)
end, { desc = "Copy relative file path" })
