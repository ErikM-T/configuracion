# Limpia la pantalla
Clear-Host

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "     INFORMACIÓN DEL SISTEMA            " -ForegroundColor Yellow
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

# 1. Obtener la serie del equipo (BIOS/Motherboard)
$serial = (Get-CimInstance Win32_Bios).SerialNumber

# 2. Obtener otros datos del sistema (Opcional)
$equipo = $env:COMPUTERNAME
$usuario = $env:USERNAME
$os = (Get-CimInstance Win32_OperatingSystem).Caption

# Mostrar los resultados
Write-Host "Nombre del Equipo : $equipo" -ForegroundColor White
Write-Host "Usuario Actual    : $usuario" -ForegroundColor White
Write-Host "Sistema Operativo : $os" -ForegroundColor White
Write-Host "----------------------------------------" -ForegroundColor DarkGray
Write-Host "Número de Serie   : $serial" -ForegroundColor Green
Write-Host "----------------------------------------" -ForegroundColor DarkGray
Write-Host ""
