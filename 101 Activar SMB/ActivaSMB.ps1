# Habilitar el cliente SMB1
Write-Host "Habilitando cliente SMB1..." -ForegroundColor Green
Enable-WindowsOptionalFeature -Online -FeatureName "SMB1Protocol-Client" -NoRestart

# Comprobar si se habilitó correctamente
$smb1Status = Get-WindowsOptionalFeature -Online -FeatureName "SMB1Protocol-Client"

if ($smb1Status.State -eq "Enabled") {
    Write-Host "SMB1 Client habilitado correctamente." -ForegroundColor Green
} else {
    Write-Host "Hubo un problema al habilitar SMB1 Client. Revisa la configuración." -ForegroundColor Red
}

# Recordatorio de reinicio
Write-Host "Es necesario reiniciar el equipo para completar los cambios." -ForegroundColor Yellow
