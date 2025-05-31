do {
    Clear-Host
    Write-Host "***************************
** BYPASS PRINTER SCRIPT **
***************************`r`n"

    Write-Host "=== MENU PRINCIPAL ==="
    Write-Host "1. Limpiar la cola de impresion"
    Write-Host "2. Baypass de impresoras"
    Write-Host "3. Abrir la configuracion de impresoras"
    Write-Host "4. Abrir los logs del script"
    Write-Host "5. Imprimir un pagina de prueba"
    Write-Host "6. Limpiar la lista de herrores"
    Write-Host "Q. Salir`r`n"
    
    $opcion = Read-Host "Seleccione una opcion"
    
    switch ($opcion) {
        '1' { 
            Write-Host "ejecutando limpieza de la cola de impresion..."
            # Llamar al script de limpieza de cola de impresion
            .\scripts\clear_tail.ps1
            Pause
        }
        '2' { 
            Write-Host "Ejecutando Bypass de impresoras..."
            # Llamar al script bypass_printer.ps1
            .\scripts\bypass_printer.ps1
            Pause
        }
        '3' { 
            Write-Host "Abriendo la configuracion de la impresora..."
            $archivo = "config\config_impresoras.txt"
                if (Test-Path $archivo) {
                    Start-Process notepad $archivo
                } else {
                    Write-Host "El archivo no existe: $archivo"
                }
            Pause
        }
        '4' { 
            Write-Host "Abriendo el archivo de log..."
            $archivo = "C:\Scripts\impresora_error.log"
                if (Test-Path $archivo) {
                    Start-Process notepad $archivo
                } else {
                    Write-Host "El archivo no existe: $archivo"
                }
            Pause
        }
        '5' { 
            Write-Host "Imprimiendo pagina de prueba..."
            # Llamar al script Test_page.ps1
            .\scripts\Test_page.ps1
            Pause
        }
        '6' { 
            Write-Host "Borrando log..."
            # Llamar al script Clear_Errors.ps1
            .\scripts\Clear_Errors.ps1
            Pause
        }
        'Q' { 
            Write-Host "Saliendo del script..."
        }
        default {
            Write-Host "Opcion no valida. Intente nuevamente."
            Pause
        }
    }
} until ($opcion -eq 'Q')