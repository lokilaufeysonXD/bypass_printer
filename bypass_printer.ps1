# nombre del script bypass_printer.ps1
# comando para que muestre los nombres de las impresoras en powerchell Get-Printer
# comando para que muestre el nombre de la red en que te encuentras (Get-NetConnectionProfile).Name

# Ruta del log
$logPath = "C:\Scripts\impresora_error.log"

# LISTA CONFIGURABLE DE REDES E IMPRESORAS
# --------------------------------------------------
$redesImpresoras = @{
    "red_01"    = "Brother"
    "red_02"    = "Brother"
    "red_03"    = "Brother"
    # Formato: "NOMBRE_RED" = "NOMBRE_IMPRESORA"
}

# Crear carpeta Scripts si no existe
if (-not (Test-Path "C:\Scripts")) {
    New-Item -Path "C:\Scripts" -ItemType Directory | Out-Null
}

try {
    # Limpiar la carpeta de impreciones pendientes
    Remove-Item -Path "C:\Windows\System32\spool\PRINTERS\*" -Force -ErrorAction Stop

    # Mensaje en consola y log
    $mensaje = "[$(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')] EXITO: Cola de impresion limpiada correctamente."
    Write-Host $mensaje
    $mensaje | Out-File -FilePath $logPath -Append
}
catch {
    $mensaje = "[$(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')] ERROR al limpiar la cola de impresion: $_"
    Write-Error $mensaje
    $mensaje | Out-File -FilePath $logPath -Append
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
                $mensaje = "[$(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')] EXITO: Impresora '$impresoraSeleccionada' establecida como predeterminada en red '$red'."
                $mensaje | Out-File -FilePath $logPath -Append
            } else {
                throw "La impresora '$impresoraSeleccionada' no se encontro en el sistema."
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
    $mensaje = "[$(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')] ERROR: $_"
    Write-Error $mensaje
    $mensaje | Out-File -FilePath $logPath -Append
    Start-Sleep -Seconds 10
}