# nombre del script bypass_printer.ps1
# comando para que muestre los nombres de las impresoras en powerchell Get-Printer
# comando para que muestre el nombre de la red en que te encuentras (Get-NetConnectionProfile).Name

# Ruta del log
$logPath = "C:\Scripts\impresora_error.log"

# Ruta del archivo de configuracion
$configPath = "config\config_impresoras.txt"

# Funcion Write-Log para escribir el formato del log
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

# Funcion para leer configuracion del archivo config_impresoras.txt
function Get-PrinterConfiguration {
    param($filePath)
    
    $config = @{}
    try {
        if (Test-Path $filePath) {
            $content = Get-Content $filePath
            if (-not $content) {
                $msg = "El archivo de configuracion esta vacio."
                Write-Log "ERROR: $msg"
                return @{}
            }
            
            foreach ($line in $content) {
                # Saltar lineas vacias o comentarios
                if ($line -match '^\s*#|^\s*$') { continue }
                
                # Extraer nombre de red e impresora
                if ($line -match '^"?([^"]+)"?\s*=\s*"?([^"]+)"?') {
                    $config[$matches[1].Trim()] = $matches[2].Trim()
                }
            }
        } else {
            $msg = "Archivo de configuracion no encontrado en $filePath"
            Write-Log "ERROR: $msg"
            return @{}
        }
        return $config
    } catch {
        $msg = "Error leyendo archivo de configuracion: $_"
        Write-Log "ERROR: $msg"
        return $null
    }
}

# Obtener configuracion de impresoras desde archivo
$redesImpresoras = Get-PrinterConfiguration -filePath $configPath

try {
    # Limpiar la carpeta de impreciones pendientes
    Remove-Item -Path "C:\Windows\System32\spool\PRINTERS\*" -Force -ErrorAction Stop

    # Mensaje en consola y log
    Write-Log "EXITO: Cola de impresion limpiada correctamente."

}
catch {
    Write-Log "ERROR: al limpiar la cola de impresion: $_"

}


# Obtener el nombre de la red actual
$red = (Get-NetConnectionProfile).Name
Write-Host " Red detectada: '$red'"


try {    
    # Buscar si la red esta en nuestra lista configurada
    $impresoraSeleccionada = $null
    
    foreach ($redConfigurada in $redesImpresoras.Keys) {
        if ($red -like "*$redConfigurada*") {
            $impresoraSeleccionada = $redesImpresoras[$redConfigurada]
            break
        }
    }

    if ($impresoraSeleccionada) {
        try {
            $impresora = Get-WmiObject -Query "SELECT * FROM Win32_Printer WHERE Name = '$impresoraSeleccionada'"
            if ($impresora) {
                $impresora.SetDefaultPrinter() | Out-Null
                Write-Host " Impresora '$impresoraSeleccionada' establecida como predeterminada."

                # Log de exito
                $msg = "Impresora '$impresoraSeleccionada' establecida como predeterminada."
                Write-Log "EXITO: $msg en red '$red'."
            } else {
                $msg = "La impresora '$impresoraSeleccionada' no se encontro en el sistema."
                Write-Host "ERROR: $msg"
                throw $msg
                # throw "La impresora '$impresoraSeleccionada' no se encontro en el sistema."
            }
        } catch {
            Write-Error " Error al establecer la impresora: $_"
            throw $_
        }
    }
    else {
        Write-Error " Red no reconocida: '$red'. No se cambio la impresora predeterminada."
        throw "Red no valida: $red"
    }

} catch {
    Write-Log "ERROR: $_"
    Start-Sleep -Seconds 10
}
finally {
    $divisor = "===============================================================================================================================================" | Out-File -FilePath $logPath -Append
    Write-Host $divisor.Trim()
}
