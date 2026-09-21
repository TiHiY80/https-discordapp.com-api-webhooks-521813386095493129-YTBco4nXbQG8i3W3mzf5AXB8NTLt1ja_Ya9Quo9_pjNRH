#Requires -Version 5.1
<#
.SYNOPSIS
    Зупиняє Thrustmaster TARGET, щоб WARDOGS бачив T.16000M напряму.
#>

$ErrorActionPreference = 'SilentlyContinue'

$targetNames = @(
    'TARGET',
    'TARGETGUI',
    'TSS',
    'Thrustmaster TARGET'
)

$stopped = @()

Get-Process | Where-Object {
    $n = $_.ProcessName
    $targetNames | Where-Object { $n -like "*$_*" }
} | ForEach-Object {
    Write-Host "  Зупиняю: $($_.ProcessName) (PID $($_.Id))"
    Stop-Process -Id $_.Id -Force
    $stopped += $_.ProcessName
}

if ($stopped.Count -eq 0) {
    Write-Host "  TARGET не запущений — добре."
} else {
    Write-Host "  TARGET зупинено. Для Star Citizen запустиш його знову після WARDOGS."
}

return ($stopped.Count -eq 0 -or $stopped.Count -gt 0)
