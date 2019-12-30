@echo off
::como lo unico a modificar del admin es su clave, esto es lo que hace la modificacion de admin, solo modificar la clave
:inicio
::ingreso de la cedula
cls
echo.
echo Modificacion de clave de un administrador:
echo.
echo Ingrese la cedula del administrador
echo que desea modificar (0 para cancelar)
echo.
set /p ci=
::se asegura que exista tal admin
if %ci% equ 0 ( goto :EOF )
if not exist .\principal\usuario\administrador\%ci%.txt (
	cls
	echo No existe un administrador con tal cedula. Ingrese otro.
	pause
	goto inicio
	)
::ingreso de la clave nueva del administrador
cls
echo Modificacion de clave de un administrador:
echo.
echo Ingrese la nueva clave (0 para cancelar)
echo.
set /p clave=
if %clave% equ 0 ( goto :EOF )
::redirige al archivo txt del admin en usuario, la clave
echo %clave% > .\principal\usuario\administrador\%ci%.txt