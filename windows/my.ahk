#Requires AutoHotkey v2.0

SetTitleMatchMode 2

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

IsTerminalVim() {
    title := WinGetTitle("A")
    return (InStr(title, "vim") || InStr(title, "nvim"))
}

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

; デバッグ用
^!d:: {
    MsgBox WinGetProcessName("A") . "`n" . WinGetTitle("A")
}

#HotIf !WinActive("ahk_group VimGroup") && !IsTerminalVim()

; --- 移動系 ---
^f::Send "{Right}"
^b::Send "{Left}"
^p::Send "{Up}"
^n::Send "{Down}"
^a::Send "{Home}"
^e::Send "{End}"

; --- 選択系 (Shift+Ctrl+*) ---
+^f::Send "+{Right}"
+^b::Send "+{Left}"
+^p::Send "+{Up}"
+^n::Send "+{Down}"
+^a::Send "+{Home}"
+^e::Send "+{End}"

; --- 編集系 ---
^d::Send "{Delete}"
^h::Send "{BackSpace}"
^k::Send "{ShiftDown}{End}{ShiftUp}{Delete}"
^u::Send "{Home}{ShiftDown}{End}{ShiftUp}{Delete}"

; --- IME 変換中の特殊挙動 ---
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
