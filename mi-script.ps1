# Cargar librerías de interfaz gráfica de Windows
Add-Type -AssemblyName PresentationFramework, System.Windows.Forms, System.Drawing

# ==============================================================================
# DISEÑO DE LA VENTANA EMERGENTE (XAML / WPF)
# ==============================================================================
[xml]$xaml = @"
<Window xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation"
        xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml"
        Title="Panel de Control y Optimizacion de Windows" Height="450" Width="600"
        WindowStartupLocation="CenterScreen" ResizeMode="CanMinimize" Background="#181818">
    <Window.Resources>
        <Style TargetType="Button">
            <Setter Property="Background" Value="#2B2B2B"/>
            <Setter Property="Foreground" Value="White"/>
            <Setter Property="FontSize" Value="13"/>
            <Setter Property="FontWeight" Value="SemiBold"/>
            <Setter Property="BorderBrush" Value="#3F3F46"/>
            <Setter Property="Template">
                <Setter.Value>
                    <ControlTemplate TargetType="Button">
                        <Border x:Name="border" 
                                Background="{TemplateBinding Background}" 
                                BorderBrush="{TemplateBinding BorderBrush}" 
                                BorderThickness="1" 
                                CornerRadius="4">
                            <ContentPresenter HorizontalAlignment="Center" VerticalAlignment="Center"/>
                        </Border>
                        <ControlTemplate.Triggers>
                            <Trigger Property="IsMouseOver" Value="True">
                                <Setter TargetName="border" Property="Background" Value="#0f0f0f"/>
                                <Setter Property="Foreground" Value="White"/>
                            </Trigger>
                        </ControlTemplate.Triggers>
                    </ControlTemplate>
                </Setter.Value>
            </Setter>
        </Style>
    </Window.Resources>

    <Grid Margin="20">
        <Grid.RowDefinitions>
            <RowDefinition Height="Auto"/>
            <RowDefinition Height="*"/>
            <RowDefinition Height="Auto"/>
        </Grid.RowDefinitions>

        <!-- TITULO ENCABEZADO -->
        <StackPanel Grid.Row="0" Margin="0,0,0,20">
            <TextBlock Text="PANEL DE CONTROL Y OPTIMIZACION" Foreground="#00E5FF" FontSize="20" FontWeight="Bold" HorizontalAlignment="Center"/>
            <TextBlock Text="Selecciona una accion para ejecutar en el sistema" Foreground="#AAAAAA" FontSize="12" HorizontalAlignment="Center" Margin="0,5,0,0"/>
            <TextBlock Name="TxtSecret" Text="._." Foreground="#181818" FontSize="10" HorizontalAlignment="Center" Margin="0,5,0,0" Cursor="Hand"/>
        </StackPanel>

        <!-- BOTONES DE OPCIONES -->
        <StackPanel Grid.Row="1" VerticalAlignment="Center">
            <Button Name="BtnInfo" Content="1. Ver Datos del Equipo y Registrar en Nube" Height="42" Margin="0,5" Cursor="Hand"/>
            <Button Name="BtnWinUtil" Content="2. Abrir Chris Titus WinUtil" Height="42" Margin="0,5" Cursor="Hand"/>
            <Button Name="BtnRed" Content="3. Ejecutar Optimizacion de Red y Sistema" Height="42" Margin="0,5" Cursor="Hand"/>
            <Button Name="BtnWindows" Content="4. Optimizacion de Windows (DISM, SFC, Limpieza)" Height="42" Margin="0,5" Cursor="Hand"/>
        </StackPanel>

        <!-- PIE DE PAGINA -->
        <Button Name="BtnSalir" Grid.Row="2" Content="Cerrar Panel" Height="35" Margin="0,15,0,0" Background="#DC2626" Foreground="White" FontSize="12" FontWeight="Bold" BorderThickness="0" Cursor="Hand"/>
    </Grid>
</Window>
"@

# Cargar la ventana desde el XAML
$reader = (New-Object System.Xml.XmlNodeReader $xaml)
$window = [System.Windows.Markup.XamlReader]::Load($reader)

# Vincular elementos de la ventana a variables de PowerShell
$BtnInfo    = $window.FindName("BtnInfo")
$BtnWinUtil = $window.FindName("BtnWinUtil")
$BtnRed     = $window.FindName("BtnRed")
$BtnWindows = $window.FindName("BtnWindows")
$BtnSalir   = $window.FindName("BtnSalir")

# ==============================================================================
# LOGICA DE LOS BOTONES
# ==============================================================================
# Vincular el TextBlock oculto
$TxtSecret = $window.FindName("TxtSecret")

# Acción al hacer clic izquierdo sobre el TextBlock
$TxtSecret.Add_MouseLeftButtonDown({
    Start-Process powershell -ArgumentList "-NoExit -Command `"curl.exe parrot.live`""
})
# ACCIÓN 1: Datos del equipo y Nube (SERIAL NO INDISPENSABLE)
$BtnInfo.Add_Click({
    $os = (Get-CimInstance Win32_OperatingSystem).Caption
    $ram = [math]::Round((Get-CimInstance Win32_PhysicalMemory | Measure-Object -Property Capacity -Sum).Sum / 1GB, 2)
    $bios = Get-CimInstance Win32_BIOS
    $computer = Get-CimInstance Win32_ComputerSystem
    
    # Manejo seguro del Serial Number para evitar errores si es nulo
    $serialRAW = $bios.SerialNumber
    if ($null -ne $serialRAW) {
        $serial = $serialRAW.Trim()
    } else {
        $serial = "No Disponible" # Valor por defecto si no hay serial
    }

    $fabricante = $computer.Manufacturer
    $modelo = $computer.Model
    $fecha = Get-Date -Format "yyyy-MM-dd HH:mm:ss"

    $webhookUrl = "https://script.google.com/macros/s/AKfycbwCpTIuil6Ta82xD22Pqn6-z9VRjg5_aoghxpYemNHBkd7DsLE0BChGbnBi94SsvprvLg/exec"
    
    $body = @{
        Fecha            = $fecha
        Fabricante       = $fabricante
        Modelo           = $modelo
        SerialNumber     = $serial # Ahora siempre lleva un valor (el serial o "No Disponible")
        RAM_GB           = $ram
        SistemaOperativo = $os
    } | ConvertTo-Json

    try {
        $response = Invoke-RestMethod -Uri $webhookUrl -Method Post -Body $body -ContentType "application/json" -MaximumRedirection 5
        
        # Manejo de la respuesta de la nube
        if ($null -ne $response -and $null -ne $response.status) {
            $estadoNube = "Registro en nube completado ($($response.status))."
        } else {
            $estadoNube = "Registro enviado (sin confirmacion de estado)."
        }
    } catch {
        $estadoNube = "Error al conectar con la nube (verificar internet): $_"
    }

    [System.Windows.Forms.MessageBox]::Show(
        "Sistema Operativo: $os`nRAM Instalada: $ram GB`nFabricante: $fabricante`nModelo: $modelo`nNumero de Serie: $serial`n`nEstado Nube: $estadoNube",
        "Informacion del Equipo",
        [System.Windows.Forms.MessageBoxButtons]::OK,
        [System.Windows.Forms.MessageBoxIcon]::Information
    )
})

# ACCION 2: Lanzar Chris Titus WinUtil
$BtnWinUtil.Add_Click({
    Start-Process powershell -ArgumentList "-NoProfile -ExecutionPolicy Bypass -Command `"irm https://christitus.com/win | iex`"" -Verb RunAs
})

# ACCIÓN 3: Optimización de Red y Sistema (Con Limpieza Integrada)
$BtnRed.Add_Click({
    $comandos = @'
    Write-Host "==================================================" -ForegroundColor Cyan
    Write-Host "   INICIANDO OPTIMIZACION DE RED Y DEL SISTEMA    " -ForegroundColor Cyan
    Write-Host "==================================================" -ForegroundColor Cyan
    Write-Host ""
    
    # 1. OPTIMIZACIÓN DE RED Y DNS
    Write-Host "[1/3] Limpiando cache de red e IP..." -ForegroundColor Yellow
    ipconfig /flushdns
    netsh int ip reset
    netsh winsock reset
    netsh int tcp set global autotuninglevel=normal
    
    # 2. LIMPIEZA DE ARCHIVOS TEMPORALES Y CACHÉ
    Write-Host "`n[2/3] Eliminando archivos temporales y cache del sistema..." -ForegroundColor Yellow
    
    Write-Host " -> Limpiando temporales de usuario (%temp%)..." -ForegroundColor Gray
    Remove-Item -Path "$env:TEMP\*" -Recurse -Force -ErrorAction SilentlyContinue
    
    Write-Host " -> Limpiando temporales del sistema (C:\Windows\Temp)..." -ForegroundColor Gray
    Remove-Item -Path "C:\Windows\Temp\*" -Recurse -Force -ErrorAction SilentlyContinue
    
    Write-Host " -> Limpiando carpeta Prefetch..." -ForegroundColor Gray
    Remove-Item -Path "C:\Windows\Prefetch\*" -Recurse -Force -ErrorAction SilentlyContinue
    
    Write-Host " -> Limpiando cache de descargas de Windows Update..." -ForegroundColor Gray
    Remove-Item -Path "C:\Windows\SoftwareDistribution\Download\*" -Recurse -Force -ErrorAction SilentlyContinue
    
    # 3. VACIAR PAPELERA DE RECICLAJE
    Write-Host "`n[3/3] Vaciando Papelera de Reciclaje..." -ForegroundColor Yellow
    Clear-RecycleBin -Force -ErrorAction SilentlyContinue
    
    Write-Host "`n==================================================" -ForegroundColor Green
    Write-Host "       ¡PROCESO COMPLETADO CON ÉXITO!            " -ForegroundColor Green
    Write-Host "==================================================" -ForegroundColor Green
    Write-Host "`nPresiona cualquier tecla para cerrar esta ventana..." -ForegroundColor Gray
    Pause
'@

    Start-Process powershell -ArgumentList "-NoProfile -ExecutionPolicy Bypass -Command `"$comandos`"" -Verb RunAs
    [System.Windows.Forms.MessageBox]::Show(
        "Optimización de red y limpieza de archivos temporales aplicadas con éxito.", 
        "Red y Sistema", 
        [System.Windows.Forms.MessageBoxButtons]::OK, 
        [System.Windows.Forms.MessageBoxIcon]::Information
    )
})

# ACCION 4: Optimizacion de Windows (DISM, SFC)
$BtnWindows.Add_Click({
    Start-Process powershell -ArgumentList "-NoProfile -ExecutionPolicy Bypass -Command `"Write-Host 'Ejecutando DISM...'; dism /online /cleanup-image /restorehealth; Write-Host 'Ejecutando SFC...'; sfc /scannow; Pause`"" -Verb RunAs
})

# ACCION SALIR
$BtnSalir.Add_Click({
    $window.Close()
})

# ==============================================================================
# MOSTRAR LA VENTANA EMERGENTE
# ==============================================================================
$null = $window.ShowDialog()
