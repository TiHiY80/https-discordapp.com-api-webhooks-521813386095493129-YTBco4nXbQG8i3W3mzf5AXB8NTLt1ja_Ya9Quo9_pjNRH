#Requires -Version 5.1
<#
.SYNOPSIS
    Підготовка ПК для WARDOGS: T.16000M (collective/yaw) + миша (pitch/roll).
#>

$ErrorActionPreference = 'Stop'
$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$DestDir = Join-Path $env:USERPROFILE 'Documents\WARDOGS-Setup'
$ConfigDir = Join-Path $env:LOCALAPPDATA 'Wardogs\Saved\Config\WindowsClient'
$ConfigFile = Join-Path $ConfigDir 'GameUserSettings.ini'

function Show-InGameSteps {
    Write-Host ''
    Write-Host '  ═══ КРОКИ В WARDOGS (гра має бути ЗАКРИТА до запуску цього скрипта) ═══'
    Write-Host ''
    Write-Host '  1. Запусти WARDOGS → Firing Range → Vendor → MH-6 → пілот (правий бік).'
    Write-Host ''
    Write-Host '  2. Settings → Controls → Settings:'
    Write-Host '       Rotary Vehicle Mouse Control     = Enabled'
    Write-Host '       Helicopter Mouse Swipe L/R       = Roll'
    Write-Host '       Helicopter Mouse Swipe U/D       = Pitch'
    Write-Host '       Invert Y Axis – Air Vehicle      = Enabled'
    Write-Host '       Invert Y Axis – Infantry         = Disabled'
    Write-Host '       Freelook on by Default          = Disabled'
    Write-Host '       Helicopter Mouse Pitch/Roll Sens = 60–65%'
    Write-Host ''
    Write-Host '  3. Settings → Gamepad → HOTAS:'
    Write-Host '       Enable HOTAS                     = Enabled'
    Write-Host '       Collective Up/Down               = повзунок на базі T.16000M'
    Write-Host '       Yaw Left/Right                   = твіст (опційно)'
    Write-Host '       Pitch / Roll                     = НЕ прив''язувати (Delete)'
    Write-Host '       Self-Centering Collective        = Disabled'
    Write-Host '       Collective Sensitivity           = 0.75'
    Write-Host '       Collective Deadzone              = 0.02'
    Write-Host '       Yaw Deadzone                     = 0.06'
    Write-Host ''
    Write-Host '  4. Settings → Controls → Settings → Flight Assists:'
    Write-Host '       Stability Assist + Turn Coordination = Enabled (для старту)'
    Write-Host ''
    Write-Host '  5. Тест: повзунок = висота, миша = pitch/roll. Left Alt = огляд.'
    Write-Host ''
    Write-Host '  Plan B (миша не крутить при HOTAS):'
    Write-Host '       HOTAS = Disabled, залиш Mouse Control = Enabled,'
    Write-Host '       запусти T16000M-Collective-Fallback.ahk з Documents\WARDOGS-Setup'
    Write-Host ''
}

Write-Host ''
Write-Host '  [1/4] Зупинка TARGET...'
& (Join-Path $ScriptDir 'Stop-TARGET-for-WARDOGS.ps1')

Write-Host ''
Write-Host '  [2/4] Перевірка T.16000M...'
$joyOk = & (Join-Path $ScriptDir 'Detect-T16000M-Axes.ps1')
if (-not $joyOk) {
    Write-Host ''
    Write-Host '  Увага: стік не знайдено. Перевір USB і joy.cpl, потім повтори.'
}

Write-Host ''
Write-Host '  [3/4] Бекап конфігу WARDOGS...'
if (Test-Path $ConfigFile) {
    if (-not (Test-Path $DestDir)) {
        New-Item -ItemType Directory -Path $DestDir -Force | Out-Null
    }
    $stamp = Get-Date -Format 'yyyyMMdd-HHmmss'
    $backup = Join-Path $DestDir "GameUserSettings.ini.backup-$stamp"
    Copy-Item -Path $ConfigFile -Destination $backup -Force
    Write-Host "  Бекап: $backup"
} else {
    Write-Host '  GameUserSettings.ini ще немає (гра не запускалась або інший шлях).'
}

Write-Host ''
Write-Host '  [4/4] Копіювання файлів у Documents\WARDOGS-Setup...'
if (-not (Test-Path $DestDir)) {
    New-Item -ItemType Directory -Path $DestDir -Force | Out-Null
}

$filesToCopy = @(
    'T16000M-Collective-Fallback.ahk',
    'Detect-T16000M-Axes.ps1',
    'Stop-TARGET-for-WARDOGS.ps1',
    'README-uk.md'
)

foreach ($f in $filesToCopy) {
    $src = Join-Path $ScriptDir $f
    if (Test-Path $src) {
        Copy-Item -Path $src -Destination (Join-Path $DestDir $f) -Force
        Write-Host "  Скопійовано: $f"
    }
}

Show-InGameSteps

Write-Host '  Відкриваю joy.cpl для калібрування (якщо доступно)...'
Start-Process 'joy.cpl' -ErrorAction SilentlyContinue

return 0
