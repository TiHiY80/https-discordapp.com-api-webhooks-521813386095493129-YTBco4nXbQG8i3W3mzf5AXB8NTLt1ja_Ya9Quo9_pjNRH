@echo off
chcp 65001 >nul
setlocal
cd /d "%~dp0"
title WARDOGS T.16000M Hybrid Setup

echo.
echo  WARDOGS: налаштування T.16000M + миша
echo  =====================================
echo.

powershell.exe -NoProfile -ExecutionPolicy Bypass -File "%~dp0Setup-Wardogs-T16000M-Hybrid.ps1"
if errorlevel 1 (
    echo.
    echo  Скрипт завершився з помилкою. Перевір повідомлення вище.
    pause
    exit /b 1
)

echo.
echo  Готово. Далі — кроки в WARDOGS (див. вікно PowerShell).
echo.
pause
