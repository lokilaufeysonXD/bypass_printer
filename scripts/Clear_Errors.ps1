Add-Type -AssemblyName System.Windows.Forms

# Ruta del log
$logPath = "C:\Scripts\impresora_error.log"

# Confirmación al usuario
$resultado = [System.Windows.Forms.MessageBox]::Show(
    "¿ Deseas borrar el contenido del log 'impresora_error.log' ?", 
    "Confirmacion requerida", 
    [System.Windows.Forms.MessageBoxButtons]::YesNo, 
    [System.Windows.Forms.MessageBoxIcon]::Question
)

if ($resultado -eq [System.Windows.Forms.DialogResult]::Yes) {
    try {
        Clear-Content -Path $logPath -ErrorAction Stop
        [System.Windows.Forms.MessageBox]::Show("Log limpiado correctamente.", "Éxito", [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Information)
    } catch {
        [System.Windows.Forms.MessageBox]::Show("Error al limpiar el log: $_", "Error", [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Error)
    }
} else {
    [System.Windows.Forms.MessageBox]::Show("Operacion cancelada por el usuario.", "Cancelado", [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Information)
}
