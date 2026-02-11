#Requires AutoHotkey v2.0

^!v::RunWait 'powershell -Command "(Get-clipboard -textformattype html)[8] -replace `'<!--StartFragment-->`', `'`' -replace `'<!--EndFragment-->`', `'`' -replace `'<span>Â </span>`', `'`' | Set-Clipboard"'

