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
            Write-Host "==================================================" -ForegroundColor Cyan
            Write-Host "   INICIANDO CONFIGURACIÓN DE RENDIMIENTO Y RED   " -ForegroundColor Cyan
            Write-Host "==================================================" -ForegroundColor Cyan
            Start-Sleep -Seconds 1
            
            # ------------------------------------------------------------------------------
            # PARTE 1: CONFIGURACIÓN DE EFECTOS VISUALES (MÁSCARA BINARIA + REGISTRO)
            # ------------------------------------------------------------------------------
            Write-Host "`n[Ajustes Visuales] Aplicando perfil personalizado de rendimiento..." -ForegroundColor Yellow

            $desktopPath  = "HKCU:\Control Panel\Desktop"
            $advancedPath = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced"
            $visualFxPath = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\VisualEffects"

            # 1. Aplicar máscara binaria para actualizar la interfaz gráfica nativa
            [byte[]]$mask = 0x90,0x12,0x03,0x80,0x10,0x00,0x00,0x00
            Set-ItemProperty -Path $desktopPath -Name "UserPreferencesMask" -Value $mask -Type Binary -ErrorAction SilentlyContinue

            # 2. Definir modo personalizado (VisualFXSetting = 3)
            Set-ItemProperty -Path $visualFxPath -Name "VisualFXSetting" -Value 3 -ErrorAction SilentlyContinue

            # 3. Ajustes individuales del Registro
            Set-ItemProperty -Path $desktopPath -Name "MinAnimate" -Value "0" -ErrorAction SilentlyContinue
            Set-ItemProperty -Path $desktopPath -Name "DragFullWindows" -Value "0" -ErrorAction SilentlyContinue
            Set-ItemProperty -Path $advancedPath -Name "CursorShadow" -Value 0 -ErrorAction SilentlyContinue
            Set-ItemProperty -Path $desktopPath -Name "FontSmoothing" -Value "2" -ErrorAction SilentlyContinue
            Set-ItemProperty -Path $desktopPath -Name "FontSmoothingType" -Value 2 -ErrorAction SilentlyContinue
            Set-ItemProperty -Path $advancedPath -Name "IconsOnly" -Value 0 -ErrorAction SilentlyContinue
            Set-ItemProperty -Path $advancedPath -Name "ListviewShadow" -Value 1 -ErrorAction SilentlyContinue
            Set-ItemProperty -Path $desktopPath -Name "DropShadow" -Value "1" -ErrorAction SilentlyContinue
            Set-ItemProperty -Path $advancedPath -Name "TaskbarAnimations" -Value 0 -ErrorAction SilentlyContinue

            # 4. Notificar a la API de Windows que recargue la interfaz gráfica
            $code = @"
using System;
using System.Runtime.InteropServices;
public class WinApi {
    [DllImport("user32.dll", SetLastError = true)]
    public static extern bool SystemParametersInfo(uint uiAction, uint uiParam, IntPtr pvParam, uint fWinIni);
}
"@
            Add-Type -TypeDefinition $code -ErrorAction SilentlyContinue
            [WinApi]::SystemParametersInfo(0x0057, 0, [IntPtr]::Zero, 0x01 -bor 0x02) | Out-Null
            [WinApi]::SystemParametersInfo(0x0025, 0, [IntPtr]::Zero, 0x01 -bor 0x02) | Out-Null

            # 5. Reiniciar Explorer para refrescar los cambios de la interfaz
            Write-Host " Reiniciando el Explorador de Windows..." -ForegroundColor Yellow
            Stop-Process -Name explorer -Force -ErrorAction SilentlyContinue
            Start-Sleep -Seconds 1
            if (-not (Get-Process -Name explorer -ErrorAction SilentlyContinue)) {
                Start-Process explorer.exe
            }

            Write-Host " [✓] Efectos visuales actualizados correctamente." -ForegroundColor Green

            # ------------------------------------------------------------------------------
            # PARTE 2: OPTIMIZACIÓN DE RED
            # ------------------------------------------------------------------------------
            Write-Host "`nIniciando optimización de red..." -ForegroundColor Cyan

            # 1. Restablecer y vaciar la caché de DNS e IP
            Write-Host "[1/4] Limpiando caché de red e IP..." -ForegroundColor Yellow
            ipconfig /flushdns | Out-Null
            netsh int ip reset | Out-Null
            netsh winsock reset | Out-Null

            # 2. Optimizar el algoritmo de congestión TCP
            Write-Host "[2/4] Ajustando parámetros TCP globales..." -ForegroundColor Yellow
            netsh int tcp set global autotuninglevel=normal
            netsh int tcp set global congestionprovider=ctcp
            netsh int tcp set global ecncapability=disabled
            netsh int tcp set global timestamps=disabled

            # 3. Deshabilitar algoritmos de retraso (Heurística de red)
            Write-Host "[3/4] Deshabilitando heurística de red..." -ForegroundColor Yellow
            netsh int tcp set heuristics disabled

            # 4. Deshabilitar el reajuste de tareas de red (Offloading)
            Write-Host "[4/4] Maximizando descarga de tareas de hardware (Offloading)..." -ForegroundColor Yellow
            Set-NetAdapterAdvancedProperty -Name "*" -DisplayName "Large Send Offload V2 (IPv4)" -DisplayValue "Enabled" -ErrorAction SilentlyContinue
            Set-NetAdapterAdvancedProperty -Name "*" -DisplayName "Large Send Offload V2 (IPv6)" -DisplayValue "Enabled" -ErrorAction SilentlyContinue

            Write-Host "`n==================================================" -ForegroundColor Green
            Write-Host " ¡Proceso completado con éxito!" -ForegroundColor Green
            Write-Host "==================================================" -ForegroundColor Green
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
