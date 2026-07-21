# Limpia la pantalla
Clear-Host

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "   CONSULTA DE INFORMACIÓN DEL EQUIPO   " -ForegroundColor Yellow
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

# Obtener datos del sistema operativo, RAM y BIOS (Número de Serie)
$os = (Get-CimInstance Win32_OperatingSystem).Caption
$ram = [math]::Round((Get-CimInstance Win32_PhysicalMemory | Measure-Object -Property Capacity -Sum).Sum / 1GB, 2)
$bios = Get-CimInstance Win32_BIOS
$computer = Get-CimInstance Win32_ComputerSystem

# Mostrar la información en pantalla
Write-Host "Sistema Operativo  : $os" -ForegroundColor Green
Write-Host "RAM Instalada      : $ram GB" -ForegroundColor Green
Write-Host "Marca / Fabricante : " -NoNewline; Write-Host $computer.Manufacturer -ForegroundColor Green
Write-Host "Modelo del Equipo  : " -NoNewline; Write-Host $computer.Model -ForegroundColor Green
Write-Host "Número de Serie    : " -NoNewline; Write-Host $bios.SerialNumber -ForegroundColor Yellow
Write-Host ""
Write-Host "========================================" -ForegroundColor Cyan
