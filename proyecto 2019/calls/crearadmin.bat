@echo off
::menu de inicio
:inicio
cls
echo.
echo Creacion de administrador (presione 0 para cancelar):
echo.
echo Ingrese la cedula del nuevo administrador:
set /p ci=
if %ci% equ 0 ( goto :EOF )
::se asegura si existe un usuario con esa cedula
::si existe el agente con esa cedula
if exist .\principal\usuario\agentes\%ci%.txt (
	cls
	echo No se puede crear un administrador que sea agente de la inmobiliaria.
	echo Presione una tecla para continuar.
	pause>nul
	goto inicio
	)
::si ya existe un admin con esa cedula
if exist .\principal\usuario\administrador\%ci%.txt (
	cls
	echo Este usuario ya existe.
	echo Presione una tecla para continuar..
	pause>nul
	goto inicio
	)
::si ya existe un cliente con esa cedula
if exist .\principal\usuario\clientes\%ci%.txt (
	cls
	echo No se puede crear un administrador que sea cliente de la inmobiliaria.
	echo Presione una tecla para continuar...
	pause>nul
	goto inicio
	)
::ingresa la clave del admin
cls
echo.
echo Creacion de administrador (presione 0 para cancelar):
echo.
echo Ahora ingrese la clave del administrador:
set /p clave=
::crea el archivo txt del admin
echo %clave% > .\principal\usuario\administrador\%ci%.txt
cls
echo.
echo Administrador creado con exito
pause