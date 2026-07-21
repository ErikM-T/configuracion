function Mostrar-Menu {
    Clear-Host
    Write-Host "========================================" -ForegroundColor Cyan
    Write-Host "     PANEL DE CONTROL Y OPTIMIZACIÓN    " -ForegroundColor Yellow
    Write-Host "========================================" -ForegroundColor Cyan
    Write-Host ""
    Write-Host "1. Ver datos del equipo (Serial, OS, RAM)" -ForegroundColor White
    Write-Host "2. Abrir Chris Titus WinUtil (No marcar Services - Set to Manual)" -ForegroundColor White
    Write-Host "3. Ejecutar optimización de red y sistema" -ForegroundColor White
    Write-Host "4. Ejecutar optimización de Windows (DISM, SFC, Limpieza)" -ForegroundColor White
    Write-Host "5. Salir" -ForegroundColor Red
    Write-Host ""
}

do {
    Mostrar-Menu
    $opcion = Read-Host "Selecciona una opción (1-5)"

    switch ($opcion) {
        '1' {
            Clear-Host
            Write-Host "--- INFORMACIÓN DEL SISTEMA Y REGISTRO EN NUBE ---" -ForegroundColor Cyan
            
            # Obtener datos del equipo
            $os = (Get-CimInstance Win32_OperatingSystem).Caption
            $ram = [math]::Round((Get-CimInstance Win32_PhysicalMemory | Measure-Object -Property Capacity -Sum).Sum / 1GB, 2)
            $bios = Get-CimInstance Win32_BIOS
            $computer = Get-CimInstance Win32_ComputerSystem
            $serial = $bios.SerialNumber.Trim()
            $fabricante = $computer.Manufacturer
            $modelo = $computer.Model
            $fecha = Get-Date -Format "yyyy-MM-dd HH:mm:ss"

            # Mostrar información en consola
            Write-Host "Sistema Operativo  : $os" -ForegroundColor Green
            Write-Host "RAM Instalada      : $ram GB" -ForegroundColor Green
            Write-Host "Marca / Fabricante : $fabricante" -ForegroundColor Green
            Write-Host "Modelo del Equipo  : $modelo" -ForegroundColor Green
            Write-Host "Número de Serie    : $serial" -ForegroundColor Yellow
            Write-Host ""

            # URL de tu Webhook de Google Apps Script
            $webhookUrl = "https://script.google.com/macros/s/AKfycbwCpTIuil6Ta82xD22Pqn6-z9VRjg5_aoghxpYemNHBkd7DsLE0BChGbnBi94SsvprvLg/exec"

            Write-Host "[Nube] Verificando y enviando datos a la base de datos central..." -ForegroundColor Gray

            # Construir el objeto JSON sin el parámetro Usuario
            $body = @{
                Fecha            = $fecha
                Fabricante       = $fabricante
                Modelo           = $modelo
                SerialNumber     = $serial
                RAM_GB           = $ram
                SistemaOperativo = $os
            } | ConvertTo-Json

            try {
                $response = Invoke-RestMethod -Uri $webhookUrl -Method Post -Body $body -ContentType "application/json" -MaximumRedirection 5
                
                if ($response.status -eq "exists") {
                    Write-Host " [i] El equipo con Serial '$serial' YA está registrado en la base de datos." -ForegroundColor Yellow
                } elseif ($response.status -eq "success") {
                    Write-Host " [✓] ¡Equipo registrado con éxito en la nube!" -ForegroundColor Green
                } else {
                    Write-Host " [!] Respuesta recibida: $($response.message)" -ForegroundColor Gray
                }
            } catch {
                Write-Host " [X] Error de conexión con la base de datos en la nube: $_" -ForegroundColor Red
            }

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

            # 4. Reiniciar Explorer para refrescar los cambios de la interfaz
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
            Clear-Host
            $version = (Get-CimInstance Win32_OperatingSystem).Version
            Write-Host "============================================================================" -ForegroundColor Green
            Write-Host "        INICIANDO OPTIMIZACIÓN DEL SISTEMA (Versión detectada: $version)" -ForegroundColor Green
            Write-Host "============================================================================" -ForegroundColor Green
            Write-Host ""
            
            # 1. REPARACIÓN Y VERIFICACIÓN DEL SISTEMA
            Write-Host "[1/4] Verificando e integrando archivos del sistema..." -ForegroundColor Yellow
            Write-Host "Ejecutando DISM (Reparación de imagen de Windows)..." -ForegroundColor Gray
            dism /online /cleanup-image /restorehealth
            
            Write-Host "`nEjecutando SFC (Comprobador de archivos del sistema)..." -ForegroundColor Gray
            sfc /scannow
            Write-Host ""
            
            # 2. AJUSTES DE ENERGÍA Y RENDIMIENTO
            Write-Host "[2/4] Configurando opciones de energía y rendimiento..." -ForegroundColor Yellow
            Write-Host "Desactivando la hibernación para liberar espacio..." -ForegroundColor Gray
            powercfg -h off
            
            Write-Host "Desbloqueando plan de Energía de Máximo Rendimiento..." -ForegroundColor Gray
            powercfg -duplicatescheme e9a42b02-d5df-448d-aa00-03f14749eb61
            Write-Host ""
            
            # 3. DESACTIVACIÓN DE SERVICIOS EN SEGUNDO PLANO Y TELEMETRÍA
            Write-Host "[3/4] Optimizando servicios en segundo plano..." -ForegroundColor Yellow
            Write-Host "Desactivando SysMain (Superfetch)..." -ForegroundColor Gray
            Stop-Service -Name "SysMain" -Force -ErrorAction SilentlyContinue
            Set-Service -Name "SysMain" -StartupType Disabled -ErrorAction SilentlyContinue
            
            Write-Host "Desactivando Telemetría y Diagnósticos (DiagTrack)..." -ForegroundColor Gray
            Stop-Service -Name "DiagTrack" -Force -ErrorAction SilentlyContinue
            Set-Service -Name "DiagTrack" -StartupType Disabled -ErrorAction SilentlyContinue
            
            # Desactivar Widgets en Windows 11
            $registryPath = "HKLM:\SOFTWARE\Policies\Microsoft\Dsh"
            if (-not (Test-Path $registryPath)) { New-Item -Path $registryPath -Force | Out-Null }
            Set-ItemProperty -Path $registryPath -Name "AllowNewsAndInterests" -Value 0 -ErrorAction SilentlyContinue
            
            Write-Host "Servicios optimizados correctamente." -ForegroundColor Green
            Write-Host ""
            
            # 4. LIMPIEZA DE ARCHIVOS TEMPORALES Y CACHÉ
            Write-Host "[4/4] Limpiando archivos temporales y caché del sistema..." -ForegroundColor Yellow
            ipconfig /flushdns | Out-Null
            
            Write-Host "Eliminando archivos temporales..." -ForegroundColor Gray
            Remove-Item -Path "$env:TEMP\*" -Recurse -Force -ErrorAction SilentlyContinue
            Remove-Item -Path "C:\Windows\Temp\*" -Recurse -Force -ErrorAction SilentlyContinue
            Write-Host "Limpieza finalizada." -ForegroundColor Green
            Write-Host ""
            
            Write-Host "============================================================================" -ForegroundColor Green
            Write-Host "                    OPTIMIZACIÓN COMPLETADA CON ÉXITO" -ForegroundColor Green
            Write-Host "============================================================================" -ForegroundColor Green
            Write-Host "`nSe recomienda reiniciar el equipo para aplicar todos los cambios.`n" -ForegroundColor Yellow
            Pause
        }
        '5' {
            Write-Host "`nSaliendo del script..." -ForegroundColor Gray
        }
        default {
            Write-Host "`nOpción no válida. Intenta de nuevo." -ForegroundColor Red
            Start-Sleep -Seconds 2
        }
    }
} while ($opcion -ne '5')
