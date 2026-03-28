#Requires AutoHotkey v2.0

SetTitleMatchMode 2

; ==============================================================================
; 除外グループ
; ==============================================================================
GroupAdd "VimGroup", "ahk_exe nvim.exe"
GroupAdd "VimGroup", "ahk_exe vim.exe"
GroupAdd "VimGroup", "ahk_exe Code.exe"
GroupAdd "VimGroup", "ahk_exe idea64.exe"
GroupAdd "VimGroup", "ahk_exe datagrip.exe"
GroupAdd "VimGroup", "ahk_exe WindowsTerminal.exe"
GroupAdd "VimGroup", "ahk_exe pwsh.exe"
GroupAdd "VimGroup", "ahk_exe powershell.exe"
GroupAdd "VimGroup", "Vim"
GroupAdd "VimGroup", "vim"
GroupAdd "VimGroup", "nvim"

; ==============================================================================
; ターミナル内で vim が動いているかを判定するヘルパー
; ==============================================================================
IsTerminalVim() {
    title := WinGetTitle("A")
    ; Windows Terminal のタイトルが vim/nvim を含む場合は除外
    return (InStr(title, "vim") || InStr(title, "nvim"))
}

; ==============================================================================
; ユーティリティ
; ==============================================================================
^!r:: Reload

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
; メイン: VimGroup でなく、かつターミナル内 vim でもない場合のみ動作
; ==============================================================================
#HotIf !WinActive("ahk_group VimGroup") && !IsTerminalVim()

^f::Send "{Right}"
^b::Send "{Left}"
^p::Send "{Up}"
^n::Send "{Down}"
^a::Send "{Home}"
^e::Send "{End}"
^d::Send "{Delete}"
^h::Send "{BackSpace}"
^k::Send "{ShiftDown}{End}{ShiftUp}{Delete}"
^u::Send "{Home}{ShiftDown}{End}{ShiftUp}{Delete}"

^i:: {
    if (IsIMEConverting())
        Send "+{Left}"
    else
        Send "{Tab}"
}
^o:: {
    if (IsIMEConverting())
        Send "+{Right}"
    else
        Send "{End}{Enter}"
}

#HotIf
