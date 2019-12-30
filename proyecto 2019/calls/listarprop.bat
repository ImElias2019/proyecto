@echo off
::menu de inicio
:listadopropiedad
set numpadron=padron
set opc=0
cls
echo.
echo Listado de propiedades:
echo.
echo 1. Listar TODAS las propiedades
echo 2. Listar la informacion especifica de una de las propiedades
echo 3. Volver
set /p opc=
if %opc% equ 3 ( goto :EOF )
::se asegura se ingresen los valores correctos
if %opc% lss 1 (
	echo.
	echo Valor incorrecto ingresado
	pause
	goto listadopropiedad
	)
if %opc% gtr 2 (
	echo.
	echo Valor incorrecto ingresado
	pause
	goto listadopropiedad
	)
::dependiendo la opcion, 1 o 2, va a su respectiva etiqueta
if %opc% equ 1 ( goto listadogeneral )
if %opc% equ 2 ( goto listadoespecifico )
::
::lista todas las propiedades
:listadogeneral
cls
echo.
echo Listado de todas las propiedades:
echo.
dir /b .\principal\sistema\propiedades
echo.
pause
goto listadopropiedad

::lista la informacion de una propiedad
:listadoespecifico
cls
echo Ingrese el numero de padron de la
echo propiedad que quiera ver (ingrese 0 para volver):
set /p numpadron=

if %numpadron% equ 0 ( goto listadopropiedad )
::se asegura que exista tal propiedad
if not exist .\principal\sistema\propiedades\%numpadron%.txt (
	echo.
	echo Tal propiedad no existe, re-ingrese otro padron.
	pause
	goto listadoespecifico
	)
cls
echo.
echo Informacion de la propiedad:
echo.
SETLOCAL EnableDelayedExpansion
::desplega la informacion de la propiedad en pantalla
set cont=1
for /f %%i in ( .\principal\sistema\propiedades\%numpadron%.txt ) do (
	if !cont! equ 1 echo -Direccion:
	if !cont! equ 2 echo -Barrio:
	if !cont! equ 3 echo -Tipo de propiedad:
	if !cont! equ 4 echo -Cantidad de dormitorios:
	if !cont! equ 5 echo -Agente asignado:
	if !cont! equ 6 echo -Si posee propietario... 1. Si - 2. No
	if !cont! equ 7 echo -Propietario... un 0 significa que no posee
	if !cont! lss 8 (
	echo %%i
	)
	echo.
	set /a cont= !cont!+1
)
ENDLOCAL
pause
goto listadopropiedad