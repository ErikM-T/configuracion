# Cargar librerías de interfaz gráfica de Windows
Add-Type -AssemblyName PresentationFramework, System.Windows.Forms, System.Drawing

# ==============================================================================
# DISEÑO DE LA VENTANA EMERGENTE (XAML / WPF)
# ==============================================================================
[xml]$xaml = @"
<Window xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation"
        xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml"
        Title="Panel de Control y Optimizacion de Windows" Height="450" Width="600"
        WindowStartupLocation="CenterScreen" ResizeMode="NoResize" Background="#181818">
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
                                <Setter TargetName="border" Property="Background" Value="#4B5563"/>
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

# ACCION 1: Datos del equipo y Nube
$BtnInfo.Add_Click({
    $os = (Get-CimInstance Win32_OperatingSystem).Caption
    $ram = [math]::Round((Get-CimInstance Win32_PhysicalMemory | Measure-Object -Property Capacity -Sum).Sum / 1GB, 2)
    $bios = Get-CimInstance Win32_BIOS
    $computer = Get-CimInstance Win32_ComputerSystem
    $serial = $bios.SerialNumber.Trim()
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
        $estadoNube = "Registro en nube completado ($($response.status))."
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

# ACCION 2: Lanzar Chris Titus WinUtil
$BtnWinUtil.Add_Click({
    Start-Process powershell -ArgumentList "-NoProfile -ExecutionPolicy Bypass -Command `"irm https://christitus.com/win | iex`"" -Verb RunAs
})

# ACCION 3: Optimizacion de Red
$BtnRed.Add_Click({
    Start-Process powershell -ArgumentList "-NoProfile -ExecutionPolicy Bypass -Command `"ipconfig /flushdns; netsh int ip reset; netsh winsock reset; netsh int tcp set global autotuninglevel=normal`"" -Verb RunAs
    [System.Windows.Forms.MessageBox]::Show("Optimizacion de red aplicada con exito.", "Red", [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Information)
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
