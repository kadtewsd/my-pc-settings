Import-Module PSReadLine
Set-PSReadlineOption -EditMode Emacs
Set-PSReadlineKeyHandler -Key Ctrl+d -Function DeleteChar

oh-my-posh init pwsh --config $env:POSH_THEMES_PATH/cinnamon.omp.json | Invoke-Expression
