@echo off
SET THISDIR=%~dp0
START /WAIT cmd.exe /c powershell.exe -ExecutionPolicy Bypass -NoLogo -NonInteractive -NoProfile -WindowStyle Hidden -File "%THISDIR%Fondo.ps1"
