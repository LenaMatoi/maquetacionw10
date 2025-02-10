@echo off
:: Solicita el nombre del nuevo usuario
set /p newUser=Introduce el nombre del nuevo usuario:

:: Verifica si se ingresó un nombre de usuario
if "%newUser%"=="" (
    echo No se proporcionó un nombre de usuario válido.
    pause
    exit /b
)

:: Crear el nuevo usuario sin contraseña (puedes ajustarlo según tu necesidad)
net user %newUser% /add
if %errorlevel% neq 0 (
    echo Hubo un problema al crear el usuario "%newUser%".
    pause
    exit /b
)
echo El usuario "%newUser%" ha sido creado exitosamente.

:: Agregar el usuario al grupo Administradores
net localgroup Administradores %newUser% /add
if %errorlevel% neq 0 (
    echo Hubo un problema al agregar al usuario "%newUser%" al grupo de Administradores.
    pause
    exit /b
)
echo El usuario "%newUser%" ha sido agregado al grupo de Administradores.

:: Desactivar el usuario Administrador
net user Administrador /active:no
if %errorlevel%==0 (
    echo La cuenta 'Administrador' ha sido desactivada correctamente.
) else (
    echo Hubo un problema al desactivar la cuenta 'Administrador'.
)

pause
