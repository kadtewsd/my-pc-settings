# Neovim で React をデバッグする設定(nvim-dap)

LazyVim + `lang.typescript` extra + `nvim-dap` で、React(ブラウザ側)のコードをデバッグするための設定メモ。

## ファイル構成

```
lua/plugins/
├── dap-react.lua   # デバッグ構成(Chrome に接続する設定)
├── dap-keys.lua    # IntelliJ 風のキーバインド
└── dap-ui.lua      # dap-ui のレイアウト(変数と REPL を下に配置)
```

---

## `lua/plugins/dap-react.lua`

**役割:** React 用のデバッグ構成を追加する。

`lang.typescript` extra が入れる設定は Node.js 用(`pwa-node`)なので、ブラウザで動く React には接続できず、`debug detached` になる。ここでは `pwa-chrome` を使って Chrome に接続する。

```lua
return {
  "mfussenegger/nvim-dap",
  opts = function()
    local dap = require("dap")
    for _, lang in ipairs({ "typescriptreact", "javascriptreact", "typescript", "javascript" }) do
      dap.configurations[lang] = dap.configurations[lang] or {}
      vim.list_extend(dap.configurations[lang], {
        {
          type = "pwa-chrome",
          request = "launch",
          name = "React: Launch Chrome (localhost:5173)",
          url = "http://localhost:5173", -- Vite は 5173、CRA は 3000
          webRoot = "${workspaceFolder}",
          sourceMaps = true,
          skipFiles = { "<node_internals>/**", "**/node_modules/**" },
        },
        {
          type = "pwa-chrome",
          request = "attach",
          name = "React: Attach to Chrome (9222)",
          port = 9222,
          webRoot = "${workspaceFolder}",
          sourceMaps = true,
        },
      })
    end
  end,
}
```

- **Launch:** Chrome を起動して `url` を開く。通常はこちらを使う。
- **Attach:** `--remote-debugging-port=9222` 付きで起動済みの Chrome に接続する。
- `skipFiles` で `node_modules` 内部にステップインしないようにする。

### 使い方

1. 別ターミナルで dev server を起動する(`npm run dev`)。
2. `.tsx` の止めたい行にブレークポイントを置く(`<leader>db`)。
3. `<leader>dc` を押し、`React: Launch Chrome` を選ぶ。
4. ブラウザで該当の操作をすると、その行で停止する。

Attach を使う場合は、先に Chrome をデバッグポート付きで起動する。

```sh
google-chrome --remote-debugging-port=9222 --user-data-dir=/tmp/chrome-debug
```

---

## `lua/plugins/dap-keys.lua`

**役割:** IntelliJ(Windows/Linux keymap)と同じキーでデバッグ操作できるようにする。

```lua
return {
  "mfussenegger/nvim-dap",
  keys = {
    { "<F9>",    function() require("dap").continue() end,          desc = "Resume (IntelliJ F9)" },
    { "<F8>",    function() require("dap").step_over() end,         desc = "Step Over (F8)" },
    { "<F7>",    function() require("dap").step_into() end,         desc = "Step Into (F7)" },
    { "<S-F8>",  function() require("dap").step_out() end,          desc = "Step Out (Shift+F8)" },
    { "<A-F9>",  function() require("dap").run_to_cursor() end,     desc = "Run to Cursor (Alt+F9)" },
    { "<C-F8>",  function() require("dap").toggle_breakpoint() end, desc = "Toggle Breakpoint (Ctrl+F8)" },
    { "<C-F2>",  function() require("dap").terminate() end,         desc = "Stop (Ctrl+F2)" },
    { "<A-F8>",  function() require("dapui").eval() end, mode = { "n", "v" }, desc = "Evaluate (Alt+F8)" },
  },
}
```

| IntelliJ | キー | 動作 |
|---|---|---|
| Resume | `F9` | 次のブレークポイントまで進める |
| Step Over | `F8` | 次の行へ |
| Step Into | `F7` | 関数の中に入る |
| Step Out | `Shift+F8` | 関数を抜ける |
| Run to Cursor | `Alt+F9` | カーソル位置まで実行 |
| Toggle Breakpoint | `Ctrl+F8` | ブレークポイント切替 |
| Stop | `Ctrl+F2` | デバッグ終了 |
| Evaluate | `Alt+F8` | 式の評価 |

### 注意

- ターミナルによっては、`Shift` / `Ctrl` / `Alt` 付きの F キーが届かない。kitty / WezTerm / Ghostty など拡張キー入力に対応したものを使うか、tmux なら `set -g extended-keys on` を設定する。
- macOS では `fn` の併用、または「標準のファンクションキーとして使用」の設定が必要な場合がある。
- LazyVim 標準の `<leader>d` 系キーもそのまま使える。

### 参考: LazyVim 標準キー

| キー | 動作 |
|---|---|
| `<leader>dc` | Continue / セッション開始 |
| `<leader>dO` | Step Over |
| `<leader>di` | Step Into |
| `<leader>do` | Step Out |
| `<leader>dC` | Run to Cursor |
| `<leader>db` | ブレークポイント切替 |
| `<leader>dB` | 条件付きブレークポイント |
| `<leader>de` | 式の評価 |
| `<leader>du` | dap-ui の開閉 |
| `<leader>dt` | 終了 |

`do`(小文字)が Step Out、`dO`(大文字)が Step Over である点に注意。

---

## `lua/plugins/dap-ui.lua`

**役割:** デバッグ時の UI レイアウトを変更する。

既定では左側に scopes / breakpoints / stacks / watches のサイドバーが出て、停止するまで空の領域が目立つ。ここでは左ペインをなくし、**画面下に「変数(scopes)」と「REPL」を半分ずつ**配置する。

```lua
return {
  "rcarriga/nvim-dap-ui",
  opts = {
    layouts = {
      {
        elements = {
          { id = "scopes", size = 0.5 },
          { id = "repl", size = 0.5 },
        },
        position = "bottom",
        size = 12, -- 下ペインの高さ(行数)
      },
    },
  },
}
```

- `opts.layouts` は配列ごと置き換わるため、既定の左ペインは表示されない。
- `size = 0.5` はペイン内の割合。`scopes` を広くしたい場合は `0.6` / `0.4` などに調整する。
- 高さは `size = 12` で変更する。
- 監視式やコールスタックも出したい場合は `elements` に `{ id = "watches", size = 0.2 }` や `{ id = "stacks", size = 0.2 }` を追加する。
- 設定変更後は nvim を再起動する。

---

## トラブルシューティング

| 症状 | 確認すること |
|---|---|
| すぐ `debug detached` になる | `pwa-node` の構成を選んでいないか。`React: Launch Chrome` を選ぶ |
| Chrome が開かない / 接続できない | `url` のポートが dev server と一致しているか。既存の Chrome を全部閉じてから再実行 |
| ブレークポイントが灰色のまま | `webRoot` と `sourceMaps` を確認。Vite なら `${workspaceFolder}` でほぼ動く |
| 原因が分からない | `:lua require('dap').set_log_level('TRACE')` の後 `:DapShowLog` でログを確認 |
| `js-debug-adapter` が見つからない | `:Mason` で `js-debug-adapter` をインストール |
