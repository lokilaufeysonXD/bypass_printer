# bypass_printer

![PowerShell](https://img.shields.io/badge/PowerShell-v5.1+-blue.svg)
![Windows](https://img.shields.io/badge/OS-Windows%2010%2F11-lightgrey)

Script PowerShell para gestionar automáticamente impresoras según la red conectada.

## 📝 Descripción

Este script lleva a cabo una:
1. **Limpieza automática** de la cola de impresión (`spool\PRINTERS`)
2. **Detección de red** actual
3. **Configuración automática** de impresora predeterminada basada en reglas configurables
4. **impresión de pagina de prueba**

## 🛠 Requisitos

- Windows 10/11
- PowerShell 5.1+
- Permisos de administrador

## ⚙️ Configuración

1. Crear archivo `bypass_printer\config\config_impresoras.txt` con formato:

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
bypass_printer/
├── config/
│   └── config_impresoras.txt
├── scripts/
│   └── bypass_printer.ps1
│   └── Clear_Errors.ps1
│   └── clear_tail.ps1
│   └── Test_Page.ps1
└── Menu.ps1
```

## 📜 Registro de eventos

Los logs se guardan en C:\Scripts\impresora_error.log con formato:
```text
  [2023-11-15 14:30:00] EXITO: Cola de impresión limpiada
  [2023-11-15 14:30:01] ERROR: Red 'RED_DESCONOCIDA' no configurada
```

## 🔄 Flujo de trabajo

<img src="https://github.com/user-attachments/assets/e3d76e75-4ece-4ab9-aa53-335121334667" alt="diagrama_de_flujo" width="3000"/>

## ⚠️ Notas importantes

  * Requiere ejecución como administrador
  * Las impresoras deben estar preinstaladas
  * Usa Get-Printer para ver nombres exactos de impresoras

