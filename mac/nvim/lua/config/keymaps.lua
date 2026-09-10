-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

-- ; と : を入れ替え（; でコマンドモード、: で検索繰り返し）
vim.keymap.set("n", ";", ":")
vim.keymap.set("n", ":", ";")
