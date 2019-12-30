@echo off
::menu de inicio
:inicio
cls
echo.
echo Eliminacion de un administrador:
echo.
echo Ingrese la cedula del administrador que
echo desea eliminar (0 para cancelar)
echo.
set /p ci=
if %ci% equ 0 ( goto :EOF )
::se asegura que exista tal admin
if not exist .\principal\usuario\administrador\%ci%.txt (
	cls
	echo No existe un administrador con tal cedula. Ingrese otro.
	pause
	goto inicio
	)
::mueve el archivo del administrador a otra ruta para confirmar que exista al menos un administrador
move>nul ".\principal\usuario\administrador\%ci%.txt" ".\principal"
::si no existe al menos un admin, vuelve el archivo a la carpeta de usuarios\administradores y sale del programa
if not exist .\principal\usuario\administrador\*.txt (
	move>nul ".\principal\%ci%.txt" ".\principal\usuario\administrador"
	cls
	echo No puedes eliminar al unico administrador de la inmobiliaria.
	pause
	goto :EOF
	)
::si existe mas de un administrador, simplemente elimina al administrador
del .\principal\%ci%.txt
cls
echo.
echo Administrador eliminado con exito
pause