# Windows Mac-style Keybinds & Vim Integration

このプロジェクトは、Windows 環境において **「Mac/Emacs 風の快適なカーソル操作」** と **「Vim による効率的な編集」** を両立させるための設定群です。

---

## コンセプト

本質的には「Windows 上の操作体系を Emacs 風（Mac 標準風）に昇格させること」を目的としていますが、すべてのキーバインドを盲目的に移植しているわけではありません。

Windows 本来のショートカットの利便性と、Vim の強力な編集能力を損なわないよう、**「自分が本当に便利だと感じるものだけ」** を厳選して実装しています。

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

---

# AHK と PSReadLine の Emacs キーバインド役割分担メモ

## 結論

`my.ahk` があっても `Microsoft_PowerShell_profile.ps1` の Emacs 設定は**不要にならない**。
意図的に役割を分離した設計になっている。

---

## 役割分担

| 場所 | 担当 |
|---|---|
| ブラウザ・メモ帳・その他一般アプリ | AHK が Emacs 風キーを送る |
| PowerShell / pwsh | AHK は無効、PSReadLine が処理する |
| VSCode / IntelliJ / Vim | AHK は無効、各エディタが処理する |

---

## なぜ pwsh を AHK で賄えないか

### 理由1: WindowsTerminal レベルで AHK が無効化される

`my.ahk` の VimGroup 定義：

```ahk
GroupAdd "VimGroup", "ahk_exe WindowsTerminal.exe"
GroupAdd "VimGroup", "ahk_exe pwsh.exe"
GroupAdd "VimGroup", "ahk_exe powershell.exe"
```

pwsh 自体と、pwsh を動かす WindowsTerminal の両方が VimGroup に含まれているため、
AHK の Emacs キーバインドはそもそも発火しない。

### 理由2: PSReadLine との競合

仮に AHK が pwsh に `{Right}` を送ったとしても：

- PSReadLine がキー入力を横取りして独自処理する
- PSReadLine の EditMode Emacs が `Ctrl+f` を解釈しようとする
- 二重処理になり動作が不安定になる

---

---

## ps1 の `Import-Module PSReadLine` と `-EditMode Emacs` は不要か？

### `Import-Module PSReadLine`

pwsh 7系では自動ロードされるので**省略可能**。ただし：
- pwsh 5.1（Windows PowerShell）との互換性を考えると残しておくのが安全
- 害はないので残しておいて損はない

### `Set-PSReadlineOption -EditMode Emacs`

**必要。** ps1の設計の肝になっている。

設計パターンは以下の2ステップ：

```powershell
# Step1: Emacs モードで全 Emacs キーを有効化
Set-PSReadlineOption -EditMode Emacs

# Step2: Windows 標準キーだけ空 ScriptBlock で上書きして解放
$StandardKeys = @('Ctrl+v', 'Ctrl+c', 'Ctrl+z', 'Ctrl+a', 'Ctrl+t', 'Ctrl+f')
foreach ($key in $StandardKeys) {
    Set-PSReadlineKeyHandler -Key $key -ScriptBlock { }
}
```

「Emacs 全有効化 → Windows 標準キーだけ解放」というパターンで、
`-EditMode Emacs` がないとこの設計が崩れる。

---

## まとめ

- **AHK** → 一般アプリ向けの Emacs 風操作を担当
- **PSReadLine (ps1)** → pwsh 内の Emacs 風操作を担当
- AHK が意図的に pwsh を除外しているので、ps1 側がないと pwsh だけ Emacs 操作できなくなる
- レイヤーを正しく分けた設計になっている

