@echo off
title Ejecutando Optimizador

:: Verificar permisos de Administrador
net session >nul 2>&1
if %errorLevel% neq 0 (
    powershell -Command "Start-Process '%~f0' -Verb RunAs"
    exit /b
)

:: Cambiar al directorio donde reside el archivo .bat
cd /d "%~dp0"

:: Ejecutar el script local
powershell -NoProfile -ExecutionPolicy Bypass -File "mi-script.ps1"

pause
