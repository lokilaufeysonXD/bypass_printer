# Verificar si el script se está ejecutando como administrador
if (-not ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole(`
        [Security.Principal.WindowsBuiltInRole]::Administrator)) {
    
    Write-Host "Este script requiere permisos de administrador. Solicitando ..."

    # Relanzar el script como administrador
    Start-Process -FilePath "powershell.exe" -ArgumentList "-NoProfile -ExecutionPolicy Bypass -File `"$PSCommandPath`"" -Verb RunAs
    exit
}

# Ruta del log
$logPath = "C:\Scripts\impresora_error.log"

# Crear carpeta Scripts si no existe
if (-not (Test-Path "C:\Scripts")) {
    New-Item -Path "C:\Scripts" -ItemType Directory | Out-Null
}

try {
    # Detener servicio de cola de impresión
    Stop-Service -Name Spooler -Force

    # Limpiar la carpeta de trabajos pendientes
    Remove-Item -Path "C:\Windows\System32\spool\PRINTERS\*" -Force -ErrorAction Stop

    # Reiniciar el servicio
    Start-Service -Name Spooler

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
finally {
    $divisor = "===============================================================================================================================================" | Out-File -FilePath $logPath -Append
    Write-Host $divisor
}

