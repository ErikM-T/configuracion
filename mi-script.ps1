function Mostrar-Menu {
    Clear-Host
    Write-Host "========================================" -ForegroundColor Cyan
    Write-Host "     PANEL DE CONTROL Y OPTIMIZACIÓN    " -ForegroundColor Yellow
    Write-Host "========================================" -ForegroundColor Cyan
    Write-Host ""
    Write-Host "1. Ver datos del equipo (Serial, OS, RAM)" -ForegroundColor White
    Write-Host "2. Abrir Chris Titus WinUtil" -ForegroundColor White
    Write-Host "3. Ejecutar optimización de red y sistema" -ForegroundColor White
    Write-Host "4. Salir" -ForegroundColor Red
    Write-Host ""
}

do {
    Mostrar-Menu
    $opcion = Read-Host "Selecciona una opción (1-4)"

    switch ($opcion) {
        '1' {
            Clear-Host
            Write-Host "--- INFORMACIÓN DEL SISTEMA ---" -ForegroundColor Cyan
            $os = (Get-CimInstance Win32_OperatingSystem).Caption
            $ram = [math]::Round((Get-CimInstance Win32_PhysicalMemory | Measure-Object -Property Capacity -Sum).Sum / 1GB, 2)
            $bios = Get-CimInstance Win32_BIOS
            $computer = Get-CimInstance Win32_ComputerSystem

            Write-Host "Sistema Operativo  : $os" -ForegroundColor Green
            Write-Host "RAM Instalada      : $ram GB" -ForegroundColor Green
            Write-Host "Marca / Fabricante : "$computer.Manufacturer -ForegroundColor Green
            Write-Host "Modelo del Equipo  : "$computer.Model -ForegroundColor Green
            Write-Host "Número de Serie    : "$bios.SerialNumber -ForegroundColor Yellow
            Write-Host ""
            Pause
        }
        '2' {
            Write-Host "`nLanzando Chris Titus Tech WinUtil..." -ForegroundColor Yellow
            irm https://christitus.com/win | iex
            Pause
        }
        '3' {
            Write-Host "`nEjecutando optimización básica de red y caché..." -ForegroundColor Yellow
            
            # Limpieza de DNS y reinicio de pila de red
            ipconfig /flushdns
            
            # Limpieza de archivos temporales del sistema
            Remove-Item -Path "$env:TEMP\*" -Recurse -Force -ErrorAction SilentlyContinue
            
            Write-Host "¡Optimización completada con éxito!" -ForegroundColor Green
            Pause
        }
        '4' {
            Write-Host "`nSaliendo del script..." -ForegroundColor Gray
        }
        default {
            Write-Host "`nOpción no válida. Intenta de nuevo." -ForegroundColor Red
            Start-Sleep -Seconds 2
        }
    }
} while ($opcion -ne '4')
