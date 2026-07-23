# Cargar librerías de interfaz gráfica de Windows
Add-Type -AssemblyName PresentationFramework, System.Windows.Forms, System.Drawing

# ==============================================================================
# DISEÑO DE LA VENTANA EMERGENTE (XAML / WPF)
# ==============================================================================
[xml]$xaml = @"
<Window xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation"
        xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml"
        Title="Panel de Control y Optimizacion de Windows" Height="620" Width="680"
        WindowStartupLocation="CenterScreen" ResizeMode="CanMinimize" Background="#181818">
    <Window.Resources>
        <!-- ESTILO DE PESTAÑAS (TABITEM) OSCURAS (CORREGIDO) -->
        <Style TargetType="TabItem">
            <Setter Property="Template">
                <Setter.Value>
                    <ControlTemplate TargetType="TabItem">
                        <Border x:Name="Border" Background="#2A2A2A" BorderBrush="#3F3F46" BorderThickness="1,1,1,0" CornerRadius="4,4,0,0" Margin="0,0,2,0" Padding="12,8">
                            <ContentPresenter x:Name="ContentSite" VerticalAlignment="Center" HorizontalAlignment="Center" ContentSource="Header"/>
                        </Border>
                        <ControlTemplate.Triggers>
                            <Trigger Property="IsSelected" Value="True">
                                <Setter TargetName="Border" Property="Background" Value="#181818"/>
                                <Setter Property="BorderBrush" Value="#00E5FF"/>
                                <Setter Property="Foreground" Value="#00E5FF"/>
                            </Trigger>
                            <Trigger Property="IsSelected" Value="False">
                                <Setter Property="Foreground" Value="#AAAAAA"/>
                            </Trigger>
                            <!-- EVENTO MOUSE OVER CORREGIDO -->
                            <MultiTrigger>
                                <MultiTrigger.Conditions>
                                    <Condition Property="IsMouseOver" Value="True"/>
                                    <Condition Property="IsSelected" Value="False"/>
                                </MultiTrigger.Conditions>
                                <Setter TargetName="Border" Property="Background" Value="#3F3F46"/>
                                <Setter Property="Foreground" Value="#FFFFFF"/>
                            </MultiTrigger>
                        </ControlTemplate.Triggers>
                    </ControlTemplate>
                </Setter.Value>
            </Setter>
            <Setter Property="FontWeight" Value="SemiBold"/>
            <Setter Property="FontSize" Value="13"/>
        </Style>

        <!-- ESTILO DE BOTONES GENERALES -->
        <Style TargetType="Button">
            <Setter Property="Background" Value="#2B2B2B"/>
            <Setter Property="Foreground" Value="White"/>
            <Setter Property="FontSize" Value="12"/>
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

        <!-- ESTILO DE ETIQUETAS Y VALORES -->
        <Style x:Key="InfoLabel" TargetType="TextBlock">
            <Setter Property="Foreground" Value="#00E5FF"/>
            <Setter Property="FontWeight" Value="Bold"/>
            <Setter Property="FontSize" Value="12"/>
            <Setter Property="Width" Value="140"/>
            <Setter Property="VerticalAlignment" Value="Center"/>
        </Style>

        <!-- TEXTBOX PARA VALORES (PERMITE COPIAR Y SELECCIONAR TEXTO) -->
        <Style x:Key="SelectableValue" TargetType="TextBox">
            <Setter Property="Foreground" Value="White"/>
            <Setter Property="Background" Value="Transparent"/>
            <Setter Property="BorderThickness" Value="0"/>
            <Setter Property="IsReadOnly" Value="True"/>
            <Setter Property="FontSize" Value="12"/>
            <Setter Property="VerticalAlignment" Value="Center"/>
            <Setter Property="Focusable" Value="True"/>
        </Style>
    </Window.Resources>

    <Grid Margin="15">
        <Grid.RowDefinitions>
            <RowDefinition Height="Auto"/>
            <RowDefinition Height="*"/>
            <RowDefinition Height="Auto"/>
        </Grid.RowDefinitions>

        <!-- ENCABEZADO -->
        <StackPanel Grid.Row="0" Margin="0,0,0,10">
            <TextBlock Text="PANEL DE CONTROL Y OPTIMIZACION" Foreground="#00E5FF" FontSize="18" FontWeight="Bold" HorizontalAlignment="Center"/>
            <TextBlock Name="TxtSecret" Text="._." Foreground="#181818" FontSize="10" HorizontalAlignment="Center" Margin="0,2,0,0" Cursor="Hand"/>
        </StackPanel>

        <!-- PESTAÑAS -->
        <TabControl Grid.Row="1" Background="#181818" BorderBrush="#3F3F46">
            
            <!-- PESTAÑA 1: INFORMACIÓN DEL EQUIPO -->
            <TabItem Header="Informacion y Datos">
                <Grid Margin="15">
                    <ScrollViewer VerticalScrollBarVisibility="Auto">
                        <StackPanel>
                            <TextBlock Text="Especificaciones del Sistema:" Foreground="#00E5FF" FontWeight="Bold" FontSize="14" Margin="0,0,0,10"/>
                            
                            <!-- LISTA DE DATOS -->
                            <Border Background="#222222" BorderBrush="#3F3F46" BorderThickness="1" CornerRadius="4" Padding="10" Margin="0,0,0,15">
                                <StackPanel>
                                    <StackPanel Orientation="Horizontal" Margin="0,4">
                                        <TextBlock Text="Sistema Operativo:" Style="{StaticResource InfoLabel}"/>
                                        <TextBox Name="TxtOS" Text="Cargando..." Style="{StaticResource SelectableValue}"/>
                                    </StackPanel>
                                    <StackPanel Orientation="Horizontal" Margin="0,4">
                                        <TextBlock Text="RAM Instalada:" Style="{StaticResource InfoLabel}"/>
                                        <TextBox Name="TxtRAM" Text="Cargando..." Style="{StaticResource SelectableValue}"/>
                                    </StackPanel>
                                    <StackPanel Orientation="Horizontal" Margin="0,4">
                                        <TextBlock Text="Fabricante:" Style="{StaticResource InfoLabel}"/>
                                        <TextBox Name="TxtFabricante" Text="Cargando..." Style="{StaticResource SelectableValue}"/>
                                    </StackPanel>
                                    <StackPanel Orientation="Horizontal" Margin="0,4">
                                        <TextBlock Text="Modelo:" Style="{StaticResource InfoLabel}"/>
                                        <TextBox Name="TxtModelo" Text="Cargando..." Style="{StaticResource SelectableValue}"/>
                                    </StackPanel>
                                    <StackPanel Orientation="Horizontal" Margin="0,4">
                                        <TextBlock Text="Numero de Serie:" Style="{StaticResource InfoLabel}"/>
                                        <TextBox Name="TxtSerial" Text="Cargando..." Style="{StaticResource SelectableValue}"/>
                                    </StackPanel>
                                </StackPanel>
                            </Border>

                            <!-- ACCIONES DE INFORMACIÓN -->
                            <Grid Margin="0,0,0,15">
                                <Grid.ColumnDefinitions>
                                    <ColumnDefinition Width="*"/>
                                    <ColumnDefinition Width="10"/>
                                    <ColumnDefinition Width="*"/>
                                </Grid.ColumnDefinitions>
                                <Button Name="BtnCopiarReporte" Grid.Column="0" Content="Copiar Ficha al Portapapeles" Height="38" Background="#3B82F6" Foreground="White" Cursor="Hand"/>
                                <Button Name="BtnEnviarNube" Grid.Column="2" Content="Enviar Datos a la Nube" Height="38" Background="#16A34A" Foreground="White" Cursor="Hand"/>
                            </Grid>

                            <Separator Margin="0,5,0,15" Background="#3F3F46"/>
                            <TextBlock Text="Herramienta de Terceros:" Foreground="#00E5FF" FontWeight="Bold" FontSize="14" Margin="0,0,0,8"/>
                            <Button Name="BtnWinUtil" Content="Abrir Chris Titus WinUtil" Height="38" Margin="0,4" Cursor="Hand"/>
                        </StackPanel>
                    </ScrollViewer>
                </Grid>
            </TabItem>

            <!-- PESTAÑA 2: DIAGNÓSTICO Y ACCESOS RÁPIDOS -->
            <TabItem Header="Diagnostico y Accesos">
                <Grid Margin="15">
                    <ScrollViewer VerticalScrollBarVisibility="Auto">
                        <StackPanel>
                            <TextBlock Text="Consulta de Salud y Vida del Disco:" Foreground="#00E5FF" FontWeight="Bold" FontSize="14" Margin="0,0,0,10"/>
                            
                            <!-- TARJETA ESTADO Y SALUD DEL DISCO -->
                            <Border Background="#222222" BorderBrush="#3F3F46" BorderThickness="1" CornerRadius="4" Padding="12" Margin="0,0,0,15">
                                <StackPanel>
                                    <StackPanel Orientation="Horizontal" Margin="0,4">
                                        <TextBlock Text="Estado del Disco:" Style="{StaticResource InfoLabel}"/>
                                        <TextBox Name="TxtDisco" Text="Cargando..." Style="{StaticResource SelectableValue}"/>
                                    </StackPanel>
                                    <TextBlock Text="* Muestra el tipo de unidad, tamaño total físico, estado S.M.A.R.T. y el porcentaje de vida útil restante (en SSDs)." Foreground="#AAAAAA" FontSize="11" Margin="0,8,0,0" TextWrapping="Wrap"/>
                                </StackPanel>
                            </Border>

                            <Separator Margin="0,5,0,15" Background="#3F3F46"/>

                            <TextBlock Text="Panel de Accesos Rapidos de Windows:" Foreground="#00E5FF" FontWeight="Bold" FontSize="14" Margin="0,0,0,10"/>
                            
                            <!-- BOTONES DE ACCESO RÁPIDO -->
                            <UniformGrid Columns="2" Margin="0,0,0,10">
                                <Button Name="BtnTaskMgr" Content="Administrador de Tareas" Height="40" Margin="4" Cursor="Hand"/>
                                <Button Name="BtnDevMgr" Content="Administrador de Dispositivos" Height="40" Margin="4" Cursor="Hand"/>
                                <Button Name="BtnNetCpl" Content="Conexiones de Red (NCPA)" Height="40" Margin="4" Cursor="Hand"/>
                                <Button Name="BtnControl" Content="Panel de Control Clasico" Height="40" Margin="4" Cursor="Hand"/>
                            </UniformGrid>
                        </StackPanel>
                    </ScrollViewer>
                </Grid>
            </TabItem>

            <!-- PESTAÑA 3: MANTENIMIENTO AVANZADO -->
            <TabItem Header="Mantenimiento Avanzado">
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
                            <CheckBox Name="ChkTRIM" Content="Optimizar unidades de almacenamiento (TRIM / Defrag)" IsChecked="False"/>
                        </StackPanel>
                    </ScrollViewer>

                    <Button Name="BtnEjecutarSeleccion" Grid.Row="1" Content="Ejecutar Opciones Seleccionadas" Height="38" Margin="0,10,0,0" Background="#0284C7" Foreground="White" FontWeight="Bold" Cursor="Hand"/>
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

# Vincular controles
$TxtOS                = $window.FindName("TxtOS")
$TxtRAM               = $window.FindName("TxtRAM")
$TxtFabricante        = $window.FindName("TxtFabricante")
$TxtModelo            = $window.FindName("TxtModelo")
$TxtSerial            = $window.FindName("TxtSerial")
$TxtDisco             = $window.FindName("TxtDisco")

$BtnCopiarReporte     = $window.FindName("BtnCopiarReporte")
$BtnEnviarNube        = $window.FindName("BtnEnviarNube")
$BtnWinUtil           = $window.FindName("BtnWinUtil")

$BtnTaskMgr           = $window.FindName("BtnTaskMgr")
$BtnDevMgr            = $window.FindName("BtnDevMgr")
$BtnNetCpl            = $window.FindName("BtnNetCpl")
$BtnControl           = $window.FindName("BtnControl")

$BtnEjecutarSeleccion = $window.FindName("BtnEjecutarSeleccion")
$BtnSalir             = $window.FindName("BtnSalir")
$TxtSecret            = $window.FindName("TxtSecret")

# Checkboxes
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
# OBTENCIÓN DE DATOS DEL EQUIPO
# ==============================================================================
$osData = (Get-CimInstance Win32_OperatingSystem).Caption
$ramData = [math]::Round((Get-CimInstance Win32_PhysicalMemory | Measure-Object -Property Capacity -Sum).Sum / 1GB, 2)
$biosData = Get-CimInstance Win32_BIOS
$compData = Get-CimInstance Win32_ComputerSystem

# Consultar Salud, Capacidad y Porcentaje de Vida del Disco
try {
    $diskPhysical = Get-PhysicalDisk | Select-Object -First 1
    $diskSizeGB = [math]::Round($diskPhysical.Size / 1GB, 2)
    
    $wearRemaining = "N/A"
    try {
        $reliability = Get-StorageReliabilityCounter -PhysicalDisk $diskPhysical -ErrorAction Stop
        if ($null -ne $reliability.Wear) {
            $lifePercentage = 100 - $reliability.Wear
            if ($lifePercentage -ge 0 -and $lifePercentage -le 100) {
                $wearRemaining = "$lifePercentage%"
            } else {
                $wearRemaining = "$($reliability.Wear)%"
            }
        }
    } catch {
        $wearRemaining = "No soportado"
    }

    if ($wearRemaining -ne "N/A" -and $wearRemaining -ne "No soportado") {
        $diskStatus = "$($diskPhysical.MediaType) ($diskSizeGB GB) - Salud: $($diskPhysical.HealthStatus) (Vida Util: $wearRemaining)"
    } else {
        $diskStatus = "$($diskPhysical.MediaType) ($diskSizeGB GB) - Salud: $($diskPhysical.HealthStatus)"
    }
} catch {
    $diskStatus = "No detectable"
}

$serialRAW = $biosData.SerialNumber
$serialData = if ($null -ne $serialRAW) { $serialRAW.Trim() } else { "No Disponible" }
$fabData = $compData.Manufacturer
$modData = $compData.Model

# Asignación a la UI
$TxtOS.Text         = $osData
$TxtRAM.Text        = "$ramData GB"
$TxtFabricante.Text = $fabData
$TxtModelo.Text     = $modData
$TxtSerial.Text     = $serialData
$TxtDisco.Text      = $diskStatus

# ==============================================================================
# ACCIONES DE LOS BOTONES
# ==============================================================================

# COPIAR FICHA TÉCNICA
$BtnCopiarReporte.Add_Click({
    $reporte = @"
=== FICHA TECNICA DEL EQUIPO ===
SO: $osData
RAM: $ramData GB
Fabricante: $fabData
Modelo: $modData
Serie: $serialData
Disco Principal: $diskStatus
Fecha Consulta: $(Get-Date -Format "yyyy-MM-dd HH:mm:ss")
"@
    [System.Windows.Forms.Clipboard]::SetText($reporte)
    [System.Windows.Forms.MessageBox]::Show("Ficha tecnica copiada al portapapeles.", "Exito", [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Information)
})

# ACCESOS RÁPIDOS
$BtnTaskMgr.Add_Click({ Start-Process taskmgr })
$BtnDevMgr.Add_Click({ Start-Process devmgmt.msc })
$BtnNetCpl.Add_Click({ Start-Process ncpa.cpl })
$BtnControl.Add_Click({ Start-Process control })

# ENVIAR A LA NUBE
$BtnEnviarNube.Add_Click({
    $fecha = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    $webhookUrl = "https://script.google.com/macros/s/AKfycbwCpTIuil6Ta82xD22Pqn6-z9VRjg5_aoghxpYemNHBkd7DsLE0BChGbnBi94SsvprvLg/exec"
    
    $body = @{
        Fecha            = $fecha
        Fabricante       = $fabData
        Modelo           = $modData
        SerialNumber     = $serialData
        RAM_GB           = $ramData
        SistemaOperativo = $osData
    } | ConvertTo-Json

    try {
        $response = Invoke-RestMethod -Uri $webhookUrl -Method Post -Body $body -ContentType "application/json" -MaximumRedirection 5
        [System.Windows.Forms.MessageBox]::Show("Registro enviado correctamente a la nube.", "Exito", [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Information)
    } catch {
        [System.Windows.Forms.MessageBox]::Show("Error al conectar con la nube: $_", "Error de Conexion", [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Error)
    }
})

# CHRIS TITUS WINUTIL
$BtnWinUtil.Add_Click({
    Start-Process powershell -ArgumentList "-NoProfile -ExecutionPolicy Bypass -Command `"irm https://christitus.com/win | iex`"" -Verb RunAs
})

# EASTER EGG
$TxtSecret.Add_MouseLeftButtonDown({
    Start-Process powershell -ArgumentList "-NoExit -Command `"curl.exe parrot.live`""
})

# EJECUTAR MANTENIMIENTO
$BtnEjecutarSeleccion.Add_Click({
    $scriptBlock = ""

    if ($ChkDNS.IsChecked) { $scriptBlock += 'Write-Host "-> Optimizando Red y DNS..." -ForegroundColor Yellow; ipconfig /flushdns; netsh int ip reset; netsh winsock reset; netsh int tcp set global autotuninglevel=normal; ' }
    if ($ChkTemp.IsChecked) { $scriptBlock += 'Write-Host "-> Limpiando Archivos Temporales..." -ForegroundColor Yellow; Remove-Item -Path "$env:TEMP\*" -Recurse -Force -ErrorAction SilentlyContinue; Remove-Item -Path "C:\Windows\Temp\*" -Recurse -Force -ErrorAction SilentlyContinue; ' }
    if ($ChkPrefetch.IsChecked) { $scriptBlock += 'Write-Host "-> Limpiando Prefetch..." -ForegroundColor Yellow; Remove-Item -Path "C:\Windows\Prefetch\*" -Recurse -Force -ErrorAction SilentlyContinue; ' }
    if ($ChkWinUpdate.IsChecked) { $scriptBlock += 'Write-Host "-> Limpiando Cache de Windows Update..." -ForegroundColor Yellow; Remove-Item -Path "C:\Windows\SoftwareDistribution\Download\*" -Recurse -Force -ErrorAction SilentlyContinue; ' }
    if ($ChkPapelera.IsChecked) { $scriptBlock += 'Write-Host "-> Vaciando Papelera de Reciclaje..." -ForegroundColor Yellow; Clear-RecycleBin -Force -ErrorAction SilentlyContinue; ' }
    if ($ChkEnergia.IsChecked) { $scriptBlock += 'Write-Host "-> Activando Plan de Alto Rendimiento..." -ForegroundColor Yellow; powercfg -duplicatescheme e9a42b02-d5df-448d-aa00-03f14749eb61; powercfg -setactive 8c5e7fda-e8bf-4a96-9a15-a94ee2d1e5c4; ' }
    if ($ChkTRIM.IsChecked) { $scriptBlock += 'Write-Host "-> Optimizando Unidades de Disco..." -ForegroundColor Yellow; Optimize-Volume -DriveLetter C -Defrag -Verbose; ' }
    if ($ChkDISM.IsChecked) { $scriptBlock += 'Write-Host "-> Ejecutando DISM /RestoreHealth..." -ForegroundColor Yellow; dism /online /cleanup-image /restorehealth; ' }
    if ($ChkSFC.IsChecked) { $scriptBlock += 'Write-Host "-> Ejecutando SFC /Scannow..." -ForegroundColor Yellow; sfc /scannow; ' }

    if ([string]::IsNullOrWhiteSpace($scriptBlock)) {
        [System.Windows.Forms.MessageBox]::Show("Por favor, selecciona al menos una opcion.", "Aviso", [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Warning)
        return
    }

    $fullCommand = "Write-Host '==========================================' -ForegroundColor Cyan; Write-Host '   EJECUTANDO TAREAS SELECCIONADAS        ' -ForegroundColor Cyan; Write-Host '==========================================' -ForegroundColor Cyan; " + $scriptBlock + "Write-Host '`nProceso completado con exito.' -ForegroundColor Green; Pause"
    Start-Process powershell -ArgumentList "-NoProfile -ExecutionPolicy Bypass -Command `"$fullCommand`"" -Verb RunAs
})

# CERRAR
$BtnSalir.Add_Click({ $window.Close() })

# MOSTRAR VENTANA
$null = $window.ShowDialog()
