# Ruta del log
$logPath = "C:\Scripts\impresora_error.log"

# Ruta del archivo de configuración
$configPath = "config\config_impresoras.txt"

# Función para escribir en el log
function Write-Log {
    param($message)
    $timestamp = Get-Date -Format "[yyyy-MM-dd HH:mm:ss]"
    "$timestamp $message" | Out-File -FilePath $logPath -Append
    Write-Host $message
}

# Crear carpeta Scripts si no existe
if (-not (Test-Path "C:\Scripts")) {
    New-Item -Path "C:\Scripts" -ItemType Directory | Out-Null
}

# Función para leer configuración
function Get-PrinterConfiguration {
    param($filePath)
    $config = @{}

    try {
        if (Test-Path $filePath) {
            $content = Get-Content $filePath
            foreach ($line in $content) {
                if ($line -match '^\s*#|^\s*$') { continue }
                if ($line -match '^"?([^"]+)"?\s*=\s*"?([^"]+)"?') {
                    $config[$matches[1].Trim()] = $matches[2].Trim()
                }
            }
        } else {
            Write-Log "ERROR: Archivo de configuracion no encontrado en $filePath"
        }
        return $config
    } catch {
        Write-Log "ERROR: No se pudo leer archivo de configuracion: $_"
        return @{}
    }
}

# Obtener red actual
$red = (Get-NetConnectionProfile).Name
Write-Host "Red detectada: '$red'"

# Obtener impresora segun la red
$redesImpresoras = Get-PrinterConfiguration -filePath $configPath
$printerName = $null

foreach ($redConfigurada in $redesImpresoras.Keys) {
    if ($red -like "*$redConfigurada*") {
        $printerName = $redesImpresoras[$redConfigurada]
        break
    }
}

if (-not $printerName) {
    Write-Log "ERROR: No se encontro una impresora configurada para la red '$red'"
    exit 1
}

# Confirmar que la impresora existe en el sistema
$printer = Get-Printer -Name "$printerName" -ErrorAction SilentlyContinue
if (-not $printer) {
    Write-Log "ERROR: La impresora '$printerName' no se encuentra instalada en el sistema."
    exit 1
}

# Enviar página de prueba y monitorear
try {
    rundll32 printui.dll,PrintUIEntry /k /n "$printerName"
    Write-Log "INFO: Pagina de prueba enviada a '$printerName'. Esperando procesamiento..."

    Start-Sleep -Seconds 5

    $intentos = 0
    $maxIntentos = 6
    $trabajosPendientes = $true

    while ($intentos -lt $maxIntentos -and $trabajosPendientes) {
        $trabajos = Get-PrintJob -PrinterName "$printerName" -ErrorAction SilentlyContinue
        if ($trabajos.Count -eq 0) {
            $trabajosPendientes = $false
            Write-Log "EXITO: La pagina de prueba de '$printerName' se imprimio correctamente o no hay trabajos pendientes."
        } else {
            Write-Log "INFO: Esperando impresion... (Intento $($intentos + 1))"
            Start-Sleep -Seconds 5
            $intentos++
        }
    }

    if ($trabajosPendientes) {
        Write-Log "ADVERTENCIA: La impresora '$printerName' aun tiene trabajos pendientes. Verifique si se imprimio correctamente."
    }
}
catch {
    Write-Log "ERROR: Fallo al enviar o monitorear impresion: $_"
}
finally {
    $divisor = "===============================================================================================================================================" | Out-File -FilePath $logPath -Append
    Write-Host $divisor
}
