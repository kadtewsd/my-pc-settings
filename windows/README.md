# Windows Mac-style Keybinds & Vim Integration

このプロジェクトは、Windows 環境において **「Mac/Emacs 風の快適なカーソル操作」** と **「Vim による効率的な編集」** を両立させるための設定群です。

---

## コンセプト

本質的には「Windows 上の操作体系を Emacs 風（Mac 標準風）に昇格させること」を目的としていますが、すべてのキーバインドを盲目的に移植しているわけではありません。

Windows 本来のショートカットの利便性と、Vim の強力な編集能力を損なわないよう、**「自分が本当に便利だと感じるものだけ」** を厳選して実装しています。

---

## 設定の背景：なぜ「標準の Emacs モード」を使わないのか

PowerShell には `Set-PSReadLineOption -EditMode Emacs` や `Set-PSReadLineKeyHandler` といった、シェルを Emacs 風にする標準機能が存在します。しかし、それらを単純に有効化するだけでは以下の問題が発生します：

- **OS との不整合**: ブラウザなどの一般アプリでは効かないため、操作の一貫性が失われる。
- **中途半端なバインド**: Windows 独自のショートカット（`Ctrl+C`, `Ctrl+V` 等）と衝突し、意図せず「コピーしたつもりがプロセスをキルした」「貼り付けたつもりが矩形選択モードにならない」といった事故が多発する。
- **Vim との競合**: ターミナル内で Vim を動かした際、シェル側の Emacs バインドが Vim の重要なキー（`Ctrl+D` のスクロール等）を奪い取ってしまう。

本プロジェクトでは、これらのストレスを解消するため、**「OS レイヤー（AutoHotkey）」** と **「シェルレイヤー（PowerShell）」** の役割を明確に分け、本当に必要な操作だけをブリッジさせています。

---

## 主な特徴

### 1. Mac/Emacs 風カーソル移動 (AutoHotkey)

- ブラウザやテキストエディタ等の一般アプリにおいて、`Ctrl + F/B/P/N/A/E` によるカーソル移動を可能にします。
- `Ctrl + D` (Delete) や `Ctrl + H` (BackSpace)、`Ctrl + K` (行末まで削除) など、ホームポジションを崩さない編集をサポートします。

### 2. Vim との共存 (Smart Context Switching)

- Windows Terminal や Neovim、VS Code などの「Vim が動く場所」では、AHK による介入を自動的に無効化します。
- これにより、Vim の `Ctrl + D`（半ページスクロール）や `Ctrl + V`（矩形選択）との衝突を回避しています。

### 3. IME 連携の最適化

- 日本語入力（IME）の変換中のみ `Ctrl + I/O` で文節の伸縮を可能にするなど、日本語環境特有の利便性を追求しています。
- `Esc` や `Ctrl + [` を押した際に自動的に IME をオフにする設定を盛り込み、Vim のノーマルモードへスムーズに戻れるようにしています。

---

## 構成ファイル

| ファイル | 説明 |
|---|---|
| `mac_style_keybinds.ahk` | AutoHotkey v2 用のメインスクリプト |
| `_vimrc` | Windows ネイティブの Vim/Neovim 用設定 |
| `settings.json` | VS Code (Vim 拡張) 用の設定 |
| `.ideavimrc` | IntelliJ / JetBrains IDE 用の設定 |

---

## インストールと使用法

1. [AutoHotkey v2](https://www.autohotkey.com/) をインストールします。
2. `mac_style_keybinds.ahk` を実行します。
3. `Ctrl + Alt + R` でいつでも設定の再読み込みが可能です。

---

## 開発の動機

Windows デフォルトの「矢印キー連打」や「中途半端なショートカットの奪い合い」によるストレスを排除し、UNIX ライクな一貫性のある操作体験を Windows 上で構築するために作成されました。
