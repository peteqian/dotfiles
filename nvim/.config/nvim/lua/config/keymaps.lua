-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here
local map = vim.keymap.set

-- Tabs: <leader><Tab> new, <Tab> next, <S-Tab> previous
map("n", "<Tab>", ":tabnext<Return>", { desc = "Next Tab" })
map("n", "<S-Tab>", ":tabprev<Return>", { desc = "Previous Tab" })

-- Select all
map("n", "<C-a>", "gg<S-v>G")
