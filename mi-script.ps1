# Limpia la pantalla
Clear-Host

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "   CONSULTA DE INFORMACIÓN DEL EQUIPO   " -ForegroundColor Yellow
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

# Obtener datos de la BIOS y del Sistema
$bios = Get-CimInstance -ClassName Win32_BIOS
$computer = Get-CimInstance -ClassName Win32_ComputerSystem

# Mostrar la información en pantalla
Write-Host "Marca / Fabricante : " -NoNewline; Write-Host $computer.Manufacturer -ForegroundColor Green
Write-Host "Modelo del Equipo  : " -NoNewline; Write-Host $computer.Model -ForegroundColor Green
Write-Host "Número de Serie    : " -NoNewline; Write-Host $bios.SerialNumber -ForegroundColor Yellow
Write-Host ""
Write-Host "========================================" -ForegroundColor Cyan
