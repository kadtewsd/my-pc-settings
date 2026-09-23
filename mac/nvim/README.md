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

## 追加設定

### 0. 前提:プラグイン管理の基本

`~/.config/nvim/lua/plugins/example.lua` は**サンプルファイル**。中に古い/非互換な設定(`typescript.nvim`の手動セットアップ、`mini-starter`等)が混在していることがあるので、エラーが出たら疑う場所その1。

```bash
:Lazy sync
```
は設定変更のたびに実行し、`Loaded (N)` の数がプラグイン総数に近いか確認する癖をつける(途中で止まっていると気づきにくい)。

---

### 1. TypeScript(vtsls)

```lua
-- lua/plugins/lang.lua など
{ import = "lazyvim.plugins.extras.lang.typescript" },
```

エイリアスを使うなら、**tsconfig.jsonとvite.config.tsの両方**に同じものを設定:

```json
// tsconfig.json — paths は必ず compilerOptions の中
{
  "compilerOptions": {
    "baseUrl": ".",
    "paths": { "@/*": ["./src/*"] }
  }
}
```
```ts
// vite.config.ts
resolve: {
  alias: { '@': path.resolve(__dirname, './src') }
}
```

確認:
```
:lua print(vim.inspect(vim.lsp.get_clients()))
```
`vtsls` が出ていればOK。

---

### 2. Go(gopls)

```lua
{ import = "lazyvim.plugins.extras.lang.go" },
```

`go.mod` があるディレクトリからnvimを開く(サブディレクトリから開くとgoplsのモジュール解決がズレる)。

確認:
```
:lua print(vim.inspect(vim.lsp.get_clients()))
```
`gopls` が出ているか、かつ
```bash
go env GOPATH
go env GOMODCACHE
```
が想定通りのパスか。

---

### 3. colorscheme(tokyonight-storm例)

**設定箇所は1つに統一する**。重複があると後勝ちで意図せず戻る。

```bash
grep -rn "colorscheme = " ~/.config/nvim/lua/plugins/
```
これで複数ファイルに同じキーがないか事前に確認してから書く。

```lua
{
  "LazyVim/LazyVim",
  opts = {
    colorscheme = "tokyonight-storm",
  },
},
```

不要な旧テーマのプラグイン指定(例: `{ "ellisonleao/gruvbox.nvim" }`)は削除しておく(読み込みコストと混乱の元)。

確認:
```
:colorscheme
```

---

### 4. grug-far(プロジェクト全体の検索・置換)

**必須: localleaderを明示的に設定する**(デフォルトでは未設定なことが多く、これが今回一番ハマった箇所)。

```lua
-- lua/config/options.lua
vim.g.maplocalleader = ","  -- お好みのキーに。スペース統一するなら " "
```

grug-farプラグイン自体がLazy管理に入っているか確認:
```
:Lazy
```
で `grug-far.nvim` を探す。

**使い方**
```
:Telescope live_grep     " まず検索
```
もしくは直接:
```
:GrugFar
```
Search/Replace/Files Filterを入力し、確定後カーソルを結果プレビュー欄に移してから:
```
,r    " localleaderがカンマの場合
```
不安ならキーマップに頼らずコマンドで確実に実行:
```
:GrugFarSync
```

---

### 共通トラブルシュートの型

どの言語・プラグインでも詰まったら、この順で確認すると早い:

1. `:Lazy sync` は最新か(`Loaded (N/N)` の数字を見る)
2. 関係するLSPは `vim.lsp.get_clients()` に出ているか
3. 設定ファイルが複数箇所に重複して書かれていないか(`grep -rn` で横断確認)
4. モジュール解決系(paths/alias/go.mod)は**エディタ用とビルド用の両方**揃っているか
5. それでもダメなら `nvim -u NONE` で素の状態から切り分け、最後は再起動

### `fail to spawn rg` が出る
→ `brew install ripgrep` でインストール。

### Explorer のアイコンが `?` になる
→ Nerd Font 未設定。`brew install --cask font-jetbrains-mono-nerd-font` 後、ターミナルのフォントを変更する。

### `<C-f>` が Explorer で動かない
→ `keymaps.lua` に `<C-f>` のグローバルマッピングを追加しないこと。
　 Explorer のキーは `lua/plugins/snacks.lua` で設定済み。
