#Requires -Version 5.1
<#
.SYNOPSIS
    Показує осі Thrustmaster T.16000M через WinMM (joyGetPosEx).
#>

Add-Type -TypeDefinition @'
using System;
using System.Runtime.InteropServices;

public static class JoyApi
{
    [StructLayout(LayoutKind.Sequential)]
    public struct JOYINFOEX
    {
        public int dwSize;
        public int dwFlags;
        public int dwXpos;
        public int dwYpos;
        public int dwZpos;
        public int dwRpos;
        public int dwUpos;
        public int dwVpos;
        public int dwButtons;
        public int dwButtonNumber;
        public int dwPOV;
        public int dwReserved1;
        public int dwReserved2;
    }

    [DllImport("winmm.dll")]
    public static extern int joyGetNumDevs();

    [DllImport("winmm.dll", CharSet = CharSet.Auto)]
    public static extern int joyGetDevCapsW(int uJoyID, ref JOYCAPS pjc, int cbjc);

    [DllImport("winmm.dll")]
    public static extern int joyGetPosEx(int uJoyID, ref JOYINFOEX pji);

    [StructLayout(LayoutKind.Sequential, CharSet = CharSet.Unicode)]
    public struct JOYCAPS
    {
        public ushort wMid;
        public ushort wPid;
        [MarshalAs(UnmanagedType.ByValTStr, SizeConst = 32)]
        public string szPname;
        public uint wXmin;
        public uint wXmax;
        public uint wYmin;
        public uint wYmax;
        public uint wZmin;
        public uint wZmax;
        public uint wNumButtons;
        public uint wPeriodMin;
        public uint wPeriodMax;
        public uint wRmin;
        public uint wRmax;
        public uint wUmin;
        public uint wUmax;
        public uint wVmin;
        public uint wVmax;
        public uint wCaps;
        public uint wMaxAxes;
        public uint wNumAxes;
        public uint wMaxButtons;
        [MarshalAs(UnmanagedType.ByValTStr, SizeConst = 32)]
        public string szRegKey;
        [MarshalAs(UnmanagedType.ByValTStr, SizeConst = 260)]
        public string szOEMVxD;
    }

    public const int JOY_RETURNALL = 0x000000FF;
}
'@

function Get-JoystickCaps {
    param([int]$Id)

    $caps = New-Object JoyApi+JOYCAPS
    $capsSize = [System.Runtime.InteropServices.Marshal]::SizeOf([type][JoyApi+JOYCAPS])
    $null = [JoyApi]::joyGetDevCapsW($Id, [ref]$caps, $capsSize)
    return $caps
}

function Read-Joystick {
    param([int]$Id)

    $info = New-Object JoyApi+JOYINFOEX
    $info.dwSize = [System.Runtime.InteropServices.Marshal]::SizeOf([type][JoyApi+JOYINFOEX])
    $info.dwFlags = [JoyApi]::JOY_RETURNALL
    $rc = [JoyApi]::joyGetPosEx($Id, [ref]$info)
    if ($rc -ne 0) { return $null }
    return $info
}

$count = [JoyApi]::joyGetNumDevs()
Write-Host ""
Write-Host "  Джойстиків (legacy joy API): $count"
Write-Host ""

$found = $false
for ($i = 0; $i -lt $count; $i++) {
    $caps = Get-JoystickCaps -Id $i
    if ([string]::IsNullOrWhiteSpace($caps.szPname)) { continue }

    $name = $caps.szPname.Trim([char]0).Trim()
    Write-Host "  [$i] $name"
    Write-Host "      Осі: X=$($caps.wNumAxes)  Кнопки: $($caps.wMaxButtons)"

    if ($name -match '16000|T\.16000|Thrustmaster') {
        $found = $true
        Write-Host ""
        Write-Host "  >>> T.16000M знайдено. Рухай СТІК, ТВІСТ і ПОВЗУНОК (5 сек)..."

        $base = Read-Joystick -Id $i
        Start-Sleep -Seconds 5
        $now = Read-Joystick -Id $i

        if ($base -and $now) {
            $delta = @{
                'X (roll)'       = [math]::Abs($now.dwXpos - $base.dwXpos)
                'Y (pitch)'      = [math]::Abs($now.dwYpos - $base.dwYpos)
                'Z (yaw/twist)'  = [math]::Abs($now.dwZpos - $base.dwZpos)
                'R (slider?)'    = [math]::Abs($now.dwRpos - $base.dwRpos)
                'U (slider?)'    = [math]::Abs($now.dwUpos - $base.dwUpos)
            }
            Write-Host ""
            Write-Host "  Зміна осей за 5 сек (найбільша = те, що рухав):"
            $delta.GetEnumerator() | Sort-Object Value -Descending | ForEach-Object {
                $mark = if ($_.Value -gt 1000) { ' <<<' } else { '' }
                Write-Host ("      {0,-16} {1,6}{2}" -f $_.Key, $_.Value, $mark)
            }
            $sliderAxis = ($delta.GetEnumerator() | Sort-Object Value -Descending | Select-Object -First 1).Key
            if (($delta.GetEnumerator() | Sort-Object Value -Descending | Select-Object -First 1).Value -gt 1000) {
                Write-Host ""
                Write-Host "  Collective (повзунок) скоріш за все: $sliderAxis"
            } else {
                Write-Host ""
                Write-Host "  Не бачу руху повзунка. Перевір USB і joy.cpl."
            }
        }
    }
    Write-Host ""
}

if (-not $found) {
    Write-Host "  T.16000M не знайдено. Перевір кабель і режим правої/лівої руки на базі."
    return $false
}

return $true
