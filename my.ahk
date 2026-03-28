#Requires AutoHotkey v2.0

; --- 除外設定 ---
SetTitleMatchMode 2
GroupAdd "VimGroup", "ahk_exe nvim.exe"
GroupAdd "VimGroup", "ahk_exe vim.exe"
GroupAdd "VimGroup", "ahk_exe gvim.exe"
GroupAdd "VimGroup", "Vim"
GroupAdd "VimGroup", "vim"

; --- IME状態取得関数 ---
IsIMEConverting() {
    try {
        hwnd := WinGetID("A")
        defaultIMEWnd := DllCall("imm32\ImmGetDefaultIMEWnd", "Uint", hwnd, "Uint")
        ; 0x0283 は WM_IME_CONTROL, 0x0005 は IMC_GETOPENSTATUS
        res := DllCall("SendMessage", "UInt", defaultIMEWnd, "UInt", 0x0283, "Int", 0x0005, "Int", 0)
        if (res == 0)
            return false ; IME OFF
        
        ; 変換中（候補ウィンドウが出ているか、文節選択中か）の判定
        ; IMC_GETCONVERSIONMODE などでより細かく取れますが、簡易的には以下
        return true
    } catch {
        return false
    }
}

; --- メイン設定 ---
#HotIf !WinActive("ahk_group VimGroup")

; 移動・編集系
^f::Send "{Right}"
^b::Send "{Left}"
^p::Send "{Up}"
^n::Send "{Down}"
^a::Send "{Home}"
^e::Send "{End}"
^d::Send "{Delete}"
^h::Send "{BackSpace}"
^k::Send "{ShiftDown}{End}{ShiftUp}{Delete}"

; --- Ctrl + I / O の特殊挙動 ---
^i:: {
    if (IsIMEConverting())
        Send "+{Left}"  ; 変換中なら文節を左に縮める（Mac風）
    else
        Send "{Tab}"    ; 通常時はTab
}

^o:: {
    if (IsIMEConverting())
        Send "+{Right}" ; 変換中なら文節を右に伸ばす（Mac風）
    else
        Send "{End}{Enter}" ; 通常時は行末改行
}

#HotIf
