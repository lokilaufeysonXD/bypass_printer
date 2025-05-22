# bypass_printer

![PowerShell](https://img.shields.io/badge/PowerShell-v5.1+-blue.svg)
![Windows](https://img.shields.io/badge/OS-Windows%2010%2F11-lightgrey)

Script PowerShell para gestionar automáticamente impresoras según la red conectada.

## 📝 Descripción

Este script lleva a cabo una:
1. **Limpieza automática** de la cola de impresión (`spool\PRINTERS`)
2. **Detección de red** actual
3. **Configuración automática** de impresora predeterminada basada en reglas configurables

## 🛠 Requisitos

- Windows 10/11
- PowerShell 5.1+
- Permisos de administrador

## ⚙️ Configuración

1. Crear archivo `C:\Scripts\config\config_impresoras.txt` con formato:

```text
  "red1" = "Printer1"
  "red2" = "Printer2"
  "nombre_de_la_red" = "nombre_de_la_impresora"
```
2. Obtener nombres de impresoras instaladas

   Ejecuta en PowerShell (como administrador):
```text
  Get-Printer

  Name                          DriverName              PortName              
  ----                          ----------              --------              
  Brother (...)                 Brother (...)           ....            
  Microsoft Print to PDF        Microsoft Print To PDF  PORTPROMPT:
```
3. Obtener nombres de redes WiFi/Ethernet

  Ejecuta en PowerShell (como administrador):
```text
  (Get-NetConnectionProfile).Name

  NOMBRE DE LA RED
```

## 📊 Estructura de archivos

```text
C:/
├── Scripts/
│   └── impresora_error.log
└── bypass_printer/
    ├── config/
    │   └── config_impresoras.txt
    └── bypass_printer.ps1
```

## 📜 Registro de eventos

Los logs se guardan en C:\Scripts\impresora_error.log con formato:
```text
  [2023-11-15 14:30:00] EXITO: Cola de impresión limpiada
  [2023-11-15 14:30:01] ERROR: Red 'RED_DESCONOCIDA' no configurada
```

## 🔄 Flujo de trabajo

<img src="https://github.com/user-attachments/assets/ded13412-c98f-4b7f-99a1-f16fc66f1939" alt="diagrama_de_flujo" width="300"/>

## ⚠️ Notas importantes

  * Requiere ejecución como administrador
  * Las impresoras deben estar preinstaladas
  * Usa Get-Printer para ver nombres exactos de impresoras

