# Neovim 設定メモ

[LazyVim](https://www.lazyvim.org/) ベースの設定。  
設定ファイルは `~/.config/nvim/` に配置。

---

## セットアップ

### 必須ツール

```bash
# ripgrep（<leader>sg での grep 検索に必須）
brew install ripgrep

# Nerd Font（アイコン表示に必須）
brew install --cask font-jetbrains-mono-nerd-font
```

> **Nerd Font インストール後**、ターミナルのフォントを `JetBrainsMono Nerd Font` に変更すること。  
> アイコンが `?` になる場合は Nerd Font が設定されていない。

### LazyVim extras（`lazyvim.json`）

| Extra | 用途 |
|---|---|
| `lang.go` | Go |
| `lang.julia` | Julia |
| `lang.markdown` | Markdown |
| `lang.typescript` | TypeScript |
| `lang.typescript.vtsls` | TypeScript (vtsls LSP) |

---

## カスタムキーマップ（`lua/config/keymaps.lua`）

LazyVim のデフォルトをそのまま使用し、以下の変更のみ追加。

| キー | モード | 動作 |
|---|---|---|
| `;` | Normal | `:` （コマンドモード） |
| `:` | Normal | `;` （検索繰り返し） |

> `<C-f>` や Emacs 風カーソル移動などは **設定しないこと**。  
> Snacks Explorer などのプラグインキーと競合する。

---

## Snacks Explorer カスタム（`lua/plugins/snacks.lua`）

| キー | 動作 |
|---|---|
| `<C-f>` | ディレクトリを展開（`l` と同等） |
| `<C-b>` | ディレクトリを折りたたむ（`h` と同等） |
| `<C-j>` | カーソル下移動（デフォルト） |
| `<C-k>` | カーソル上移動（デフォルト） |

### Snacks Explorer デフォルトキー（変更なし）

| キー | 動作 |
|---|---|
| `l` | 開く / 展開 |
| `h` | 閉じる / 折りたたむ |
| `<BS>` | 親ディレクトリへ |
| `a` | 新規ファイル/ディレクトリ作成 |
| `d` | 削除 |
| `r` | リネーム |
| `c` | コピー |
| `m` | 移動 |
| `y` | パスをヤンク |
| `I` | 隠しファイル（ignored）トグル |
| `H` | dotfile（hidden）トグル |
| `<leader>/` | Explorer 内 grep |

---

## オプション（`lua/config/options.lua`）

| 設定 | 値 | 備考 |
|---|---|---|
| `tabstop` | 4 | |
| `shiftwidth` | 4 | |
| `expandtab` | true | タブをスペースに変換 |
| `clipboard` | `unnamedplus` | OS クリップボードと共有 |
| `relativenumber` | false | |
| `scrolloff` | 3 | |
| `swapfile` | false | |
| `backup` | false | |
| `mouse` | `a` | 全モードでマウス有効 |
| `guicursor` | `a:blinkon0` | カーソル点滅なし |

---

## トラブルシューティング

### `fail to spawn rg` が出る
→ `brew install ripgrep` でインストール。

### Explorer のアイコンが `?` になる
→ Nerd Font 未設定。`brew install --cask font-jetbrains-mono-nerd-font` 後、ターミナルのフォントを変更する。

### `<C-f>` が Explorer で動かない
→ `keymaps.lua` に `<C-f>` のグローバルマッピングを追加しないこと。  
　 Explorer のキーは `lua/plugins/snacks.lua` で設定済み。
