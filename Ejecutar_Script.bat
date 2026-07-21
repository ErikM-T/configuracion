@echo off
:: Solicitar permisos de Administrador automáticamente
net session >nul 2>&1
if %errorLevel% neq 0 (
    powershell -Command "Start-Process '%~f0' -Verb RunAs"
    exit /b
)

:: Ejecutar el archivo .ps1 local
powershell -NoProfile -ExecutionPolicy Bypass -File "%~dp0mi-script.ps1"
