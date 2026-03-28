scoop bucket add extras
scoop install vim git
scoop install windows-terminal vscode
scoop install oh-my-posh
scoop install autohotkey

# PS7
scoop install pwsh

# PS のタイピングは Emacs 風に。
cp .\Microsoft.PowerShell_profile.ps1 $PROFILE
# oh-my-posh の aliens を git の状態に合わせて背景色を変えるように修正
# 既定の設定はそのままにしとく
# cp .\aliens.omp.json $env:POSH_THEMES_PATH/aliens.omp.json
cp .\aliens.omp.json $HOME/aliens.omp.json
Install-Module fPSReadLine -Force  -Scope CurrentUser

cp .\my.ahk ~
# sudo
winget install gsudo
