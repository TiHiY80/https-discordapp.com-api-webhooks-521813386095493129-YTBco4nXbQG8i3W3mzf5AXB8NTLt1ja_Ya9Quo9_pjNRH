; WARDOGS Plan B: повзунок T.16000M → W/S (collective)
; Потрібен AutoHotkey v2: https://www.autohotkey.com/
#Requires AutoHotkey v2.0
#SingleInstance Force

global JoyId := 0
global SliderAxis := "R"   ; R або U — зміни, якщо Detect-T16000M-Axes.ps1 показав інше
global Deadzone := 8000
global PollMs := 40

SetTimer(PollCollective, PollMs)

PollCollective() {
    static lastState := ""

    if !IsWardogsActive()
        return ReleaseAll(&lastState)

    pos := ReadSlider(JoyId, SliderAxis)
    if (pos = "")
        return ReleaseAll(&lastState)

    mid := 32767
    delta := pos - mid

    newState := ""
    if (delta > Deadzone)
        newState := "up"
    else if (delta < -Deadzone)
        newState := "down"

    if (newState = lastState)
        return

    ReleaseAll(&lastState)

    if (newState = "up") {
        Send "{w down}"
        lastState := "up"
    } else if (newState = "down") {
        Send "{s down}"
        lastState := "down"
    }
}

IsWardogsActive() {
    return WinActive("ahk_exe Wardogs.exe")
        || WinActive("ahk_exe Wardogs-Win64-Shipping.exe")
}

ReadSlider(id, axis) {
    caps := Buffer(404, 0)
    NumPut("UInt", 404, caps, 0)
    if DllCall("winmm\joyGetDevCapsW", "UInt", id, "Ptr", caps, "UInt", 404)
        return ""

    info := Buffer(48, 0)
    NumPut("UInt", 48, info, 0)
    NumPut("UInt", 0xFF, info, 4)
    if DllCall("winmm\joyGetPosEx", "UInt", id, "Ptr", info)
        return ""

    offset := Map("X", 8, "Y", 12, "Z", 16, "R", 20, "U", 24, "V", 28)
    if !offset.Has(axis)
        return ""
    return NumGet(info, offset[axis], "UInt")
}

ReleaseAll(&state) {
    if (state = "up")
        Send "{w up}"
    else if (state = "down")
        Send "{s up}"
    state := ""
}

OnExit(*) => ReleaseAll(&lastState := "")
