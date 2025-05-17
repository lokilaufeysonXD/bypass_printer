# nombre del script bypass_printer.ps1

# Ruta del log
$logPath = "C:\Scripts\impresora_error.log"

# Crear carpeta Scripts si no existe
if (-not (Test-Path "C:\Scripts")) {
    New-Item -Path "C:\Scripts" -ItemType Directory | Out-Null
}


# Obtener el nombre de la red actual
$red = (Get-NetConnectionProfile).Name
Write-Host " Red detectada: '$red'"


try {    
    if ($red -like "*INFINITUM7005*") {
        try {
            $impresora = Get-WmiObject -Query "SELECT * FROM Win32_Printer WHERE Name = 'Brother MFC-J285DW Printer'"
            if ($impresora) {
                $impresora.SetDefaultPrinter() | Out-Null
                Write-Host " Impresora 'Brother' establecida como predeterminada."

                # Log de exito
                $mensaje = "[$(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')] EXITO: Impresora 'Brother' establecida como predeterminada en red '$red'."
                $mensaje | Out-File -FilePath $logPath -Append
            } else {
                throw "La impresora 'Brother' no se encontro en el sistema."
            }
        } catch {
            Write-Error " Error al establecer la impresora: $_"
            throw $_
        }
    }
    else {
        Write-Error " Red no reconocida: '$red'."
        throw "Red no valida: $red"
    }

        # "***" {
        #     Set-Printer -Name "Epson-Centro2" -IsDefault $true
        #     Write-Host "Impresora Epson-Centro2 establecida como predeterminada."
        # }
        # "***" {
        #     Set-Printer -Name "Canon-Centro3" -IsDefault $true
        #     Write-Host "Impresora Canon-Centro3 establecida como predeterminada."
        # }
        # Default {
        #     Write-Host "Red no reconocida. No se cambio la impresora predeterminada."
        # }

    }catch {
    $mensaje = "[$(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')] ERROR: $_"
    Write-Error $mensaje
    $mensaje | Out-File -FilePath $logPath -Append
    Start-Sleep -Seconds 10
}