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
            # PARTE 1: CONFIGURACIÓN DE EFECTOS VISUALES (SEGÚN LA IMAGEN)
            # ------------------------------------------------------------------------------
            Write-Host "`n[Ajustes Visuales] Aplicando perfil personalizado de rendimiento..." -ForegroundColor Yellow
            
            $desktopPath  = "HKCU:\Control Panel\Desktop"
            $advancedPath = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced"
            $visualFxPath = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\VisualEffects"
            
            # Establecer modo personalizado (Personalizar: 3)
            Set-ItemProperty -Path $visualFxPath -Name "VisualFXSetting" -Value 3 -ErrorAction SilentlyContinue
            
            # 1. Desactivar animaciones al minimizar/maximizar
            Set-ItemProperty -Path $desktopPath -Name "MinAnimate" -Value "0" -ErrorAction SilentlyContinue
            
            # 2. Desactivar mostrar contenido de la ventana mientras se arrastra
            Set-ItemProperty -Path $desktopPath -Name "DragFullWindows" -Value "0" -ErrorAction SilentlyContinue
            
            # 3. Desactivar sombras bajo el puntero del mouse
            Set-ItemProperty -Path $advancedPath -Name "CursorShadow" -Value 0 -ErrorAction SilentlyContinue
            
            # 4. ACTIVAR: Suavizar bordes para las fuentes de pantalla
            Set-ItemProperty -Path $desktopPath -Name "FontSmoothing" -Value "2" -ErrorAction SilentlyContinue
            Set-ItemProperty -Path $desktopPath -Name "FontSmoothingType" -Value 2 -ErrorAction SilentlyContinue
            
            # 5. ACTIVAR: Mostrar vistas en miniatura en lugar de iconos (IconsOnly = 0)
            Set-ItemProperty -Path $advancedPath -Name "IconsOnly" -Value 0 -ErrorAction SilentlyContinue
            
            # 6. ACTIVAR: Usar sombras en las etiquetas de iconos en el Escritorio
            Set-ItemProperty -Path $advancedPath -Name "ListviewShadow" -Value 1 -ErrorAction SilentlyContinue
            
            # 7. ACTIVAR: Mostrar sombras bajo las ventanas
            Set-ItemProperty -Path $desktopPath -Name "DropShadow" -Value "1" -ErrorAction SilentlyContinue
            
            # 8. Desactivar animaciones en la barra de tareas y controles
            Set-ItemProperty -Path $advancedPath -Name "TaskbarAnimations" -Value 0 -ErrorAction SilentlyContinue
            
            Write-Host " [✓] Efectos visuales ajustados con éxito." -ForegroundColor Green
            
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
            Write-Host " Se recomienda reiniciar el equipo para aplicar todos los cambios." -ForegroundColor Cyan
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
