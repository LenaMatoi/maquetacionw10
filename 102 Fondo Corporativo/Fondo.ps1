# Definir la URL base y la carpeta destino
$BaseUrl = "http://lenamatoi.sytes.net/wallpaper/"
$DestinationFolder = "C:\Windows\Web\Wallpaper\Valorant"

# Obtener el nombre de la máquina (ignorar mayúsculas/minúsculas)
$ComputerName = $env:COMPUTERNAME.ToLower()

# Verificar si el nombre de la máquina contiene "minint-"
if ($ComputerName -like "minint-*") {
    Write-Host "La máquina pertenece a un entorno corporativo (minint). Se usará 'corp.jpg'."
    $FileName = "corp.jpg"
} else {
    # Construir el nombre del archivo correspondiente basado en el nombre de la máquina
    $FileName = "$ComputerName.jpg"
    Write-Host "Usando el fondo de pantalla correspondiente al nombre de la máquina: $FileName"
}

# Construir la URL del archivo correspondiente
$FileUrl = "$BaseUrl$FileName"

# Verificar si la carpeta destino existe, si no, crearla
if (-Not (Test-Path -Path $DestinationFolder)) {
    New-Item -ItemType Directory -Path $DestinationFolder
}

# Descargar el archivo desde la URL
$DestinationPath = Join-Path -Path $DestinationFolder -ChildPath $FileName
try {
    Invoke-WebRequest -Uri $FileUrl -OutFile $DestinationPath
    Write-Host "Archivo descargado correctamente: $DestinationPath"
} catch {
    Write-Host "Error al descargar el archivo desde $FileUrl"
    exit 1
}

# Establecer el fondo de pantalla
try {
    Add-Type -TypeDefinition @"
    using System;
    using System.Runtime.InteropServices;
    public class Wallpaper {
        [DllImport("user32.dll", CharSet = CharSet.Auto)]
        public static extern int SystemParametersInfo(int uAction, int uParam, string lpvParam, int fuWinIni);
    }
"@
    [Wallpaper]::SystemParametersInfo(0x0014, 0, $DestinationPath, 0x0001 | 0x0002)
    Write-Host "Fondo de pantalla aplicado correctamente: $FileName"
} catch {
    Write-Host "Error al establecer el fondo de pantalla"
    exit 1
}

# Ejecutar el archivo WallpaperDEF.reg
$RegFilePath = "C:\Windows\Web\Wallpaper\Valorant\WallpaperDEF.reg"
if (Test-Path -Path $RegFilePath) {
    try {
        Start-Process -FilePath "regedit.exe" -ArgumentList "/s", $RegFilePath -Wait
        Write-Host "Fichero WallpaperDEF.reg ejecutado correctamente"
    } catch {
        Write-Host "Error al ejecutar WallpaperDEF.reg"
        exit 1
    }
} else {
    Write-Host "El fichero WallpaperDEF.reg no existe en la ruta esperada: $RegFilePath"
}

# Reiniciar el proceso explorer.exe
try {
    Stop-Process -Name explorer -Force
    Start-Process -FilePath "explorer.exe"
    Write-Host "Proceso explorer reiniciado"
} catch {
    Write-Host "Error al reiniciar el proceso explorer"
    exit 1
}
