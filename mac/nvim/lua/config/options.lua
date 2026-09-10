-- lua/config/options.lua
-- 旧 .vimrc からプラグイン非依存の設定だけを移植したもの。
-- LazyVim は ignorecase/smartcase/hlsearch/splitbelow/splitright などを
-- すでにデフォルトで有効にしているので、ここでは重複しても実害はないが、
-- 明示したい項目だけ残してある。

local opt = vim.opt

-- インデント
opt.tabstop = 4
opt.softtabstop = 0
opt.shiftwidth = 4
opt.expandtab = true

-- 検索
opt.ignorecase = true
opt.smartcase = true
opt.hlsearch = true
opt.incsearch = true

-- 分割方向
opt.splitright = true
opt.splitbelow = true

-- バックアップ/スワップ無効
opt.backup = false
opt.swapfile = false

opt.fileformats = { "unix", "dos", "mac" }

opt.number = true
opt.relativenumber = false -- <C-l> でトグル(keymaps.lua参照)

opt.scrolloff = 3
opt.modeline = true
opt.modelines = 10

opt.title = true
opt.titlestring = "%F"

opt.autoread = true
opt.errorbells = false
opt.visualbell = false

opt.clipboard = "unnamedplus" -- OS クリップボードと共有(pbcopy等のハックは不要に)
opt.mouse = "a"
opt.whichwrap = "b,s,h,l,<,>,[,]"

opt.guicursor = "a:blinkon0" -- カーソル点滅なし

-- 以下は意図的に移植していません:
--   fileencoding/fileencodings/bomb/binary/ttyfast/backspace
--     -> Neovim のデフォルトで十分、または非推奨設定
--   syntax on / statusline の手動フォーマット
--     -> LazyVim の treesitter / lualine が担当
--   highlight Pmenu/PmenuSel/Search/Visual
--     -> 使っているcolorschemeに任せる方がよい
