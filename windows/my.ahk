#Requires AutoHotkey v2.0

; ==============================================================================
; 除外設定 (Vim や ターミナル、IDE では AHK の介入を完全に防ぐ)
; ==============================================================================
SetTitleMatchMode 2

; 1. プロセス名による判定 (EXE単位で確実に除外)
GroupAdd "VimGroup", "ahk_exe nvim.exe"            ; Neovim 本体
GroupAdd "VimGroup", "ahk_exe vim.exe"             ; Vim 本体
GroupAdd "VimGroup", "ahk_exe Code.exe"            ; VS Code (Vim拡張のため)
GroupAdd "VimGroup", "ahk_exe idea64.exe"          ; IntelliJ IDEA
GroupAdd "VimGroup", "ahk_exe datagrip.exe"        ; DataGrip
GroupAdd "VimGroup", "ahk_exe WindowsTerminal.exe" ; Windows Terminal (最優先で除外)
GroupAdd "VimGroup", "ahk_exe pwsh.exe"            ; PowerShell 7
GroupAdd "VimGroup", "ahk_exe powershell.exe"      ; Windows PowerShell

; 2. ウィンドウタイトルによる補完的な判定
GroupAdd "VimGroup", "Vim"
GroupAdd "VimGroup", "vim"
GroupAdd "VimGroup", "nvim"

; ==============================================================================
; ユーティリティ
; ==============================================================================
; Ctrl + Alt + R でスクリプトを即時リロード (修正後の反映を楽にする)
^!r:: {
    Reload
}

; IME変換中かどうかを判定する関数
IsIMEConverting() {
    try {
        hwnd := WinGetID("A")
        defaultIMEWnd := DllCall("imm32\ImmGetDefaultIMEWnd", "Uint", hwnd, "Uint")
        res := DllCall("SendMessage", "UInt", defaultIMEWnd, "UInt", 0x0283, "Int", 0x0005, "Int", 0)
        return res != 0
    } catch {
        return false
    }
}

; ==============================================================================
; メイン設定: VimGroup (ターミナル等) がアクティブでない場合のみ AHK が動作
; ==============================================================================
#HotIf !WinActive("ahk_group VimGroup")

; --- 移動系 (Mac/Emacs 風) ---
^f::Send "{Right}"
^b::Send "{Left}"
^p::Send "{Up}"
^n::Send "{Down}"
^a::Send "{Home}"
^e::Send "{End}"

; --- 編集系 ---
^d::Send "{Delete}"
^h::Send "{BackSpace}"
^k::Send "{ShiftDown}{End}{ShiftUp}{Delete}" ; カーソル以降を削除
^u::Send "{Home}{ShiftDown}{End}{ShiftUp}{Delete}" ; 行全体を削除

; --- IME 変換中の特殊挙動 (Ctrl + I / O) ---
^i:: {
    if (IsIMEConverting())
        Send "+{Left}"  ; 変換文節を縮める
    else
        Send "{Tab}"
}

^o:: {
    if (IsIMEConverting())
        Send "+{Right}" ; 変換文節を伸ばす
    else
        Send "{End}{Enter}" ; 行末で改行
}

#HotIf
