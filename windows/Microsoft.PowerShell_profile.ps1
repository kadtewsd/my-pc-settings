Write-Host "ctrl + shift + v is paste"

# --- 1. Emacs 風キーバインドの導入と Windows 標準キーの保護 ---
Import-Module PSReadLine
Set-PSReadlineOption -EditMode Emacs

# Windows 標準のショートカット (Ctrl+C, V, Z, A, T, F 等) を PSReadLine から解放する
# -Function Invalid の代わりに空の ScriptBlock を使うことでエラーを回避し、
# ターミナル本体（Windows Terminal）側にキーイベントを渡します。
$StandardKeys = @('Ctrl+v', 'Ctrl+c', 'Ctrl+z', 'Ctrl+a', 'Ctrl+t', 'Ctrl+f')
foreach ($key in $StandardKeys) {
    Set-PSReadlineKeyHandler -Key $key -ScriptBlock { }
}

# Emacs 操作の中で特に便利なものだけを明示的に有効化
Set-PSReadlineKeyHandler -Key Ctrl+d -Function DeleteChar
Set-PSReadlineKeyHandler -Key Ctrl+b -Function BackwardChar
Set-PSReadlineKeyHandler -Key Ctrl+f -Function ForwardChar
Set-PSReadlineKeyHandler -Key Ctrl+p -Function PreviousHistory
Set-PSReadlineKeyHandler -Key Ctrl+n -Function NextHistory
Set-PSReadlineKeyHandler -Key Ctrl+a -Function BeginningOfLine
Set-PSReadlineKeyHandler -Key Ctrl+e -Function EndOfLine

# --- 2. 補完とビープ音のカスタマイズ (Unix風) ---
Set-PSReadlineOption -BellStyle None
Set-PSReadlineKeyHandler -Key Tab -Function TabCompleteNext
Set-PSReadlineKeyHandler -Key Shift+Tab -Function TabCompletePrevious

# --- 3. プロンプト設定 (Oh-My-Posh) ---
# ホームディレクトリを確実に特定
$UserHomePath = $env:USERPROFILE
if ($null -eq $UserHomePath) { $UserHomePath = $HOME }
$ThemeFile = Join-Path $UserHomePath "aliens.omp.json"

if (Test-Path $ThemeFile) {
    oh-my-posh init pwsh --config $ThemeFile | Invoke-Expression
} else {
    oh-my-posh init pwsh | Invoke-Expression
}

# --- 4. エイリアス設定 (Linux互換) ---
Set-Alias vi vim
Set-Alias grep Select-String
function ls-color { Get-ChildItem $args | Out-Host }
function which ($name) { Get-Command $name -ErrorAction SilentlyContinue | Select-Object -ExpandProperty Definition }

# --- 5. PowerShell 7 専用: 予測入力（Predictive IntelliSense） ---
$psrl = Get-Module PSReadLine
if ($psrl -and ($psrl.Version -ge [version]"2.2.0")) {
    Set-PSReadLineOption -PredictionSource History
    $opt = Get-PSReadLineOption
    if ($opt | Get-Member -Name "PredictionViewStyle") {
        Set-PSReadLineOption -PredictionViewStyle InlineView
    }
}

# --- 6. 文字コード対策 ---
$OutputEncoding = [System.Text.Encoding]::UTF8

# Tab キーの挙動: 予測がある時は AcceptSuggestion、なければ TabCompleteNext
Set-PSReadlineKeyHandler -Key Tab -ScriptBlock { 
    $line = $null; $cursor = $null
    [Microsoft.PowerShell.PSConsoleReadLine]::GetBufferState([ref]$line, [ref]$cursor)
    
    # サジェスト（予測入力）が表示されているかを確認
    $prediction = $null
    try {
        # 予測候補を取得して存在確認
        $ast = $null; $tokens = $null; $errors = $null; $position = $null
        [Microsoft.PowerShell.PSConsoleReadLine]::GetBufferState([ref]$ast, [ref]$tokens, [ref]$errors, [ref]$position)
        $lastWord = ($line -split '\s+')[-1]
        $history = [Microsoft.PowerShell.PSConsoleReadLine]::GetHistoryItems() | 
                   Where-Object { $_.CommandLine.StartsWith($line) } |
                   Select-Object -First 1
        $prediction = $history
    } catch { }
    
    if ($prediction -and $cursor -ge $line.Length) {
        [Microsoft.PowerShell.PSConsoleReadLine]::AcceptSuggestion()
    } else {
        [Microsoft.PowerShell.PSConsoleReadLine]::TabCompleteNext()
    }
}

