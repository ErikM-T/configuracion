# Cargar librerías de interfaz gráfica de Windows
Add-Type -AssemblyName PresentationFramework, System.Windows.Forms, System.Drawing

# ==============================================================================
# DISEÑO DE LA VENTANA EMERGENTE CON SUBMENÚS / PESTAÑAS (XAML / WPF)
# ==============================================================================
[xml]$xaml = @"
<Window xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation"
        xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml"
        Title="Panel de Control y Optimizacion de Windows" Height="520" Width="640"
        WindowStartupLocation="CenterScreen" ResizeMode="CanMinimize" Background="#181818">
    <Window.Resources>
        <!-- ESTILO DE BOTONES -->
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
                                <Setter TargetName="border" Property="Background" Value="#4B5563"/>
                                <Setter Property="Foreground" Value="White"/>
                            </Trigger>
                        </ControlTemplate.Triggers>
                    </ControlTemplate>
                </Setter.Value>
            </Setter>
        </Style>

        <!-- ESTILO DE CHECKBOXES -->
        <Style TargetType="CheckBox">
            <Setter Property="Foreground" Value="White"/>
            <Setter Property="FontSize" Value="12"/>
            <Setter Property="Margin" Value="0,6"/>
            <Setter Property="Cursor" Value="Hand"/>
        </Style>
    </Window.Resources>

    <Grid Margin="15">
        <Grid.RowDefinitions>
            <RowDefinition Height="Auto"/>
            <RowDefinition Height="*"/>
            <RowDefinition Height="Auto"/>
        </Grid.RowDefinitions>

        <!-- ENCABEZADO Y TÍTULO -->
        <StackPanel Grid.Row="0" Margin="0,0,0,10">
            <TextBlock Text="PANEL DE CONTROL Y OPTIMIZACION" Foreground="#00E5FF" FontSize="18" FontWeight="Bold" HorizontalAlignment="Center"/>
            <TextBlock Name="TxtSecret" Text="._." Foreground="#181818" FontSize="10" HorizontalAlignment="Center" Margin="0,2,0,0" Cursor="Hand"/>
        </StackPanel>

        <!-- SUBMENÚS CON PESTAÑAS (TAB CONTROL) -->
        <TabControl Grid.Row="1" Background="#222222" BorderBrush="#3F3F46">
            
            <!-- PESTAÑA 1: INICIO Y ACCIONES RÁPIDAS -->
            <TabItem Header="Acciones Rapidas" Foreground="Black" FontWeight="Bold">
                <Grid Margin="15">
                    <StackPanel VerticalAlignment="Center">
                        <Button Name="BtnInfo" Content="1. Ver Datos del Equipo y Registrar en Nube" Height="40" Margin="0,6" Cursor="Hand"/>
                        <Button Name="BtnWinUtil" Content="2. Abrir Chris Titus WinUtil" Height="40" Margin="0,6" Cursor="Hand"/>
                        <TextBlock Text="Tip: Usa la pestana 'Mantenimiento Avanzado' para personalizar las tareas." Foreground="#888888" FontSize="11" HorizontalAlignment="Center" Margin="0,15,0,0"/>
                    </StackPanel>
                </Grid>
            </TabItem>

            <!-- PESTAÑA 2: SUBMENÚ DE OPTIMIZACIÓN Y LIMPIEZA -->
            <TabItem Header="Mantenimiento Avanzado" Foreground="Black" FontWeight="Bold">
                <Grid Margin="15">
                    <Grid.RowDefinitions>
                        <RowDefinition Height="*"/>
                        <RowDefinition Height="Auto"/>
                    </Grid.RowDefinitions>

                    <ScrollViewer Grid.Row="0" VerticalScrollBarVisibility="Auto">
                        <StackPanel>
                            <TextBlock Text="Red y Conexion:" Foreground="#00E5FF" FontWeight="Bold" Margin="0,0,0,5"/>
                            <CheckBox Name="ChkDNS" Content="Limpiar cache DNS y restablecer adaptadores de red" IsChecked="True"/>
                            
                            <Separator Margin="0,8" Background="#3F3F46"/>
                            <TextBlock Text="Limpieza del Sistema:" Foreground="#00E5FF" FontWeight="Bold" Margin="0,0,0,5"/>
                            <CheckBox Name="ChkTemp" Content="Eliminar archivos temporales (%temp% y C:\Windows\Temp)" IsChecked="True"/>
                            <CheckBox Name="ChkPrefetch" Content="Limpiar carpeta Prefetch" IsChecked="True"/>
                            <CheckBox Name="ChkWinUpdate" Content="Limpiar cache de descargas de Windows Update" IsChecked="True"/>
                            <CheckBox Name="ChkPapelera" Content="Vaciar Papelera de Reciclaje" IsChecked="True"/>

                            <Separator Margin="0,8" Background="#3F3F46"/>
                            <TextBlock Text="Rendimiento y Mantenimiento:" Foreground="#00E5FF" FontWeight="Bold" Margin="0,0,0,5"/>
                            <CheckBox Name="ChkDISM" Content="Reparar imagen de Windows (DISM /RestoreHealth)" IsChecked="False"/>
                            <CheckBox Name="ChkSFC" Content="Escaneo de integridad del sistema (SFC /Scannow)" IsChecked="False"/>
                            <CheckBox Name="ChkEnergia" Content="Activar plan de energia de Alto Rendimiento" IsChecked="True"/>
                            <CheckBox Name="ChkTRIM" Content="Optimizar unidades de almacenamiento (TRIM en SSD / Defrag en HDD)" IsChecked="False"/>
                        </StackPanel>
                    </ScrollViewer>

                    <Button Name="BtnEjecutarSeleccion" Grid.Row="1" Content="Ejecutar Opciones Seleccionadas" Height="38" Margin="0,10,0,0" Background="#0284C7" Foreground="White" FontWeight="Bold"/>
                </Grid>
            </TabItem>
        </TabControl>

        <!-- PIE DE PÁGINA -->
        <Button Name="BtnSalir" Grid.Row="2" Content="Cerrar Panel" Height="35" Margin="0,10,0,0" Background="#DC2626" Foreground="White" FontSize="12" FontWeight="Bold" BorderThickness="0" Cursor="Hand"/>
    </Grid>
</Window>
"@

# Cargar la ventana desde el XAML
$reader = (New-Object System.Xml.XmlNodeReader $xaml)
$window = [System.Windows.Markup.XamlReader]::Load($reader)

# Vincular elementos de la ventana a variables
$BtnInfo              = $window.FindName("BtnInfo")
$BtnWinUtil           = $window.FindName("BtnWinUtil")
$BtnEjecutarSeleccion = $window.FindName("BtnEjecutarSeleccion")
$BtnSalir             = $window.FindName("BtnSalir")
$TxtSecret            = $window.FindName("TxtSecret")

# Vincular CheckBoxes
$ChkDNS       = $window.FindName("ChkDNS")
$ChkTemp      = $window.FindName("ChkTemp")
$ChkPrefetch  = $window.FindName("ChkPrefetch")
$ChkWinUpdate = $window.FindName("ChkWinUpdate")
$ChkPapelera  = $window.FindName("ChkPapelera")
$ChkDISM      = $window.FindName("ChkDISM")
$ChkSFC       = $window.FindName("ChkSFC")
$ChkEnergia   = $window.FindName("ChkEnergia")
$ChkTRIM      = $window.FindName("ChkTRIM")

# ==============================================================================
# LÓGICA DE LOS BOTONES Y ACCIONES
# ==============================================================================

# ACCIÓN 1: Datos del equipo y Nube (Manejo de Serial nulo integrado)
$BtnInfo.Add_Click({
    $os = (Get-CimInstance Win32_OperatingSystem).Caption
    $ram = [math]::Round((Get-CimInstance Win32_PhysicalMemory | Measure-Object -Property Capacity -Sum).Sum / 1GB, 2)
    $bios = Get-CimInstance Win32_BIOS
    $computer = Get-CimInstance Win32_ComputerSystem
    
    $serialRAW = $bios.SerialNumber
    if ($null -ne $serialRAW) {
        $serial = $serialRAW.Trim()
    } else {
        $serial = "No Disponible"
    }

    $fabricante = $computer.Manufacturer
    $modelo = $computer.Model
    $fecha = Get-Date -Format "yyyy-MM-dd HH:mm:ss"

    $webhookUrl = "https://script.google.com/macros/s/AKfycbwCpTIuil6Ta82xD22Pqn6-z9VRjg5_aoghxpYemNHBkd7DsLE0BChGbnBi94SsvprvLg/exec"
    
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
        if ($null -ne $response -and $null -ne $response.status) {
            $estadoNube = "Registro en nube completado ($($response.status))."
        } else {
            $estadoNube = "Registro enviado (sin confirmacion de estado)."
        }
    } catch {
        $estadoNube = "Error al conectar con la nube: $_"
    }

    [System.Windows.Forms.MessageBox]::Show(
        "Sistema Operativo: $os`nRAM Instalada: $ram GB`nFabricante: $fabricante`nModelo: $modelo`nNumero de Serie: $serial`n`nEstado Nube: $estadoNube",
        "Informacion del Equipo",
        [System.Windows.Forms.MessageBoxButtons]::OK,
        [System.Windows.Forms.MessageBoxIcon]::Information
    )
})

# ACCIÓN 2: Lanzar Chris Titus WinUtil
$BtnWinUtil.Add_Click({
    Start-Process powershell -ArgumentList "-NoProfile -ExecutionPolicy Bypass -Command `"irm https://christitus.com/win | iex`"" -Verb RunAs
})

# EASTER EGG (Clic en ._.)
$TxtSecret.Add_MouseLeftButtonDown({
    Start-Process powershell -ArgumentList "-NoExit -Command `"curl.exe parrot.live`""
})

# ACCIÓN SUBMENÚ: EJECUTAR TAREAS SELECCIONADAS
$BtnEjecutarSeleccion.Add_Click({
    $scriptBlock = ""

    if ($ChkDNS.IsChecked) {
        $scriptBlock += 'Write-Host "-> Optimizando Red y DNS..." -ForegroundColor Yellow; ipconfig /flushdns; netsh int ip reset; netsh winsock reset; netsh int tcp set global autotuninglevel=normal; '
    }
    if ($ChkTemp.IsChecked) {
        $scriptBlock += 'Write-Host "-> Limpiando Archivos Temporales..." -ForegroundColor Yellow; Remove-Item -Path "$env:TEMP\*" -Recurse -Force -ErrorAction SilentlyContinue; Remove-Item -Path "C:\Windows\Temp\*" -Recurse -Force -ErrorAction SilentlyContinue; '
    }
    if ($ChkPrefetch.IsChecked) {
        $scriptBlock += 'Write-Host "-> Limpiando Prefetch..." -ForegroundColor Yellow; Remove-Item -Path "C:\Windows\Prefetch\*" -Recurse -Force -ErrorAction SilentlyContinue; '
    }
    if ($ChkWinUpdate.IsChecked) {
        $scriptBlock += 'Write-Host "-> Limpiando Cache de Windows Update..." -ForegroundColor Yellow; Remove-Item -Path "C:\Windows\SoftwareDistribution\Download\*" -Recurse -Force -ErrorAction SilentlyContinue; '
    }
    if ($ChkPapelera.IsChecked) {
        $scriptBlock += 'Write-Host "-> Vaciando Papelera de Reciclaje..." -ForegroundColor Yellow; Clear-RecycleBin -Force -ErrorAction SilentlyContinue; '
    }
    if ($ChkEnergia.IsChecked) {
        $scriptBlock += 'Write-Host "-> Activando Plan de Alto Rendimiento..." -ForegroundColor Yellow; powercfg -duplicatescheme e9a42b02-d5df-448d-aa00-03f14749eb61; powercfg -setactive 8c5e7fda-e8bf-4a96-9a15-a94ee2d1e5c4; '
    }
    if ($ChkTRIM.IsChecked) {
        $scriptBlock += 'Write-Host "-> Optimizando Unidades de Disco (TRIM/Defrag)..." -ForegroundColor Yellow; Optimize-Volume -DriveLetter C -Defrag -Verbose; '
    }
    if ($ChkDISM.IsChecked) {
        $scriptBlock += 'Write-Host "-> Ejecutando DISM /RestoreHealth..." -ForegroundColor Yellow; dism /online /cleanup-image /restorehealth; '
    }
    if ($ChkSFC.IsChecked) {
        $scriptBlock += 'Write-Host "-> Ejecutando SFC /Scannow..." -ForegroundColor Yellow; sfc /scannow; '
    }

    if ([string]::IsNullOrWhiteSpace($scriptBlock)) {
        [System.Windows.Forms.MessageBox]::Show("Por favor, selecciona al menos una opcion para ejecutar.", "Aviso", [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Warning)
        return
    }

    # Finalizar bloque de comandos
    $fullCommand = "Write-Host '==========================================' -ForegroundColor Cyan; Write-Host '   EJECUTANDO TAREAS SELECCIONADAS        ' -ForegroundColor Cyan; Write-Host '==========================================' -ForegroundColor Cyan; " + $scriptBlock + "Write-Host '`nProceso completado con exito.' -ForegroundColor Green; Write-Host 'Presiona cualquier tecla para salir...' -ForegroundColor Gray; Pause"

    Start-Process powershell -ArgumentList "-NoProfile -ExecutionPolicy Bypass -Command `"$fullCommand`"" -Verb RunAs
})

# ACCIÓN SALIR
$BtnSalir.Add_Click({
    $window.Close()
})

# ==============================================================================
# MOSTRAR LA VENTANA EMERGENTE
# ==============================================================================
$null = $window.ShowDialog()
