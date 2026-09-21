# WARDOGS: T.16000M + миша (гібрид)

Автоматична підготовка ПК і резервний collective, якщо HOTAS у грі не підхопить повзунок.

## Швидкий старт

1. Закрий WARDOGS повністю.
2. Підключи **Thrustmaster T.16000M**.
3. Запусти **`RUN-ME.bat`** від імені звичайного користувача (адмін не потрібен).
4. Скрипт:
   - зупинить **TARGET** (Star Citizen), щоб не заважав WARDOGS;
   - перевірить, чи Windows бачить стік;
   - зробить бекап `GameUserSettings.ini`, якщо файл існує;
   - покаже, яка вісь повзунка активна;
   - скопіює резервний **AutoHotkey**-скрипт collective (Plan B).
5. Запусти WARDOGS → **Firing Range** → MH-6 → сядь **пілотом з правого борту**.
6. Виконай **5 кроків у грі** з вікна, яке покаже `RUN-ME.bat` (≈2 хв).

## Схема керування

| Дія | Пристрій |
| --- | --- |
| Pitch / Roll | миша |
| Collective | повзунок на базі T.16000M (лівою рукою) |
| Yaw | твіст стіка або A/D |
| Огляд | Left Alt + миша |

## Plan B (якщо миша не крутить гелік при увімкненому HOTAS)

1. У WARDOGS: **Gamepad → HOTAS → Enable HOTAS = Disabled**.
2. Залиш **Rotary Vehicle Mouse Control = Enabled**.
3. Встанови [AutoHotkey v2](https://www.autohotkey.com/) (якщо ще немає).
4. Запусти `T16000M-Collective-Fallback.ahk` з папки `%USERPROFILE%\Documents\WARDOGS-Setup\`.
5. Повзунок емулює W/S для collective; миша лишається на pitch/roll.

## Файли

| Файл | Призначення |
| --- | --- |
| `RUN-ME.bat` | Головний запуск |
| `Setup-Wardogs-T16000M-Hybrid.ps1` | Перевірки, бекап, інструкції |
| `Stop-TARGET-for-WARDOGS.ps1` | Зупинка TARGET |
| `Detect-T16000M-Axes.ps1` | Діагностика осей стіка |
| `T16000M-Collective-Fallback.ahk` | Резервний collective через W/S |

## Важливо

- **TARGET для Star Citizen** під час WARDOGS не запускай.
- Бінди HOTAS (collective / yaw на осі) гра зберігає після призначення в меню; скрипт їх не підміняє.
- Якщо бінди зникають після перезапуску — відомий баг EA; перевір осі ще раз у Firing Range.
