# Script de bienvenida e información básica
Clear-Host
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "      MI SCRIPT PERSONALIZADO           " -ForegroundColor Yellow
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

$nombre = Read-Host "Erik"
Write-Host "¡Hola, $nombre! Obteniendo datos de tu sistema..." -ForegroundColor Green

$os = (Get-CimInstance Win32_OperatingSystem).Caption
$ram = [math]::Round((Get-CimInstance Win32_PhysicalMemory | Measure-Object -Property Capacity -Sum).Sum / 1GB, 2)

Write-Host "Sistema Operativo: $os"
Write-Host "RAM Instalada: $ram GB"