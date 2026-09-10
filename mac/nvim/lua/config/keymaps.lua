-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

-- ; と : を入れ替え（; でコマンドモード、: で検索繰り返し）
vim.keymap.set("n", ";", ":")
vim.keymap.set("n", ":", ";")

-- :bd をウィンドウレイアウト保持版に置き換え
-- 通常の :bd は分割ウィンドウごと閉じてしまうため、
-- Snacks.bufdelete() で「現在バッファだけ削除・ウィンドウは残す」動作にする
vim.api.nvim_create_user_command("Bd", function() Snacks.bufdelete() end, { desc = "Delete buffer (keep window layout)" })

vim.cmd("cabbrev bd Bd")
