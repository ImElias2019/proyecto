@echo off
::menu de inicio
:listadocliente
set opc=3
set ci=1
cls
echo Listado de clientes:
echo.
echo 1. Listar TODOS los clientes
echo 2. Listar la informacion sobre un cliente especifico
echo 0. Volver
set /p opc=
if %opc% equ 0 ( goto :EOF )
::se asegura de que los valores ingresados sean los del menu
if %opc% lss 1 (
	echo Valor incorrecto ingresado
	pause
	goto listadocliente
	)
if %opc% gtr 2 (
	echo Valor incorrecto ingresado
	pause
	goto listadocliente
	)
::segun su opcion, va a su etiqueta
if %opc% equ 1 goto listadogeneral
if %opc% equ 2 goto listadoespecifico
::
::listado de un cliente en especifico
:listadoespecifico
cls
echo.
echo Listado de un cliente:
echo.
echo Ingrese el cliente que desea visualizar su informacion
echo (ingrese 0 para volver)
set /p ci=
cls
::se ingresa 0 para volver
if %ci% equ 0 ( goto listadocliente )
::se asegura que exista el cliente ingresado
if not exist .\principal\usuario\clientes\%ci%.txt (
	echo No existe un cliente con esa cedula, ingresela nuevamente
	pause
	goto listadoespecifico
	)
::esto tiene el funcionamiento de mostrar en pantalla la informacion del archivo txt del cliente, con su correspondiente dato
echo Datos del cliente:
SETLOCAL EnableDelayedExpansion
set cont=1
for /f %%i in ( .\principal\sistema\clientes\%ci%.txt ) do (
	if !cont! equ 1 echo Nombre:
	if !cont! equ 2 echo Apellido:
	if !cont! equ 3 echo Fecha de ingreso:
	if !cont! equ 4 echo Edad:
	if !cont! equ 5 echo Telefono:
	if !cont! equ 6 echo Propiedad alquilada:
	if !cont! equ 7 echo Precio de alquiler:
	echo %%i
	echo.
	set /a cont= !cont!+1
)
ENDLOCAL
echo.
echo.
pause
goto listadocliente




::listado de todos los clientes (solo su cedula)
:listadogeneral
cls
echo Listado de todos los clientes:
echo.
dir /b .\principal\usuario\clientes
echo.
echo.
echo.
pause
goto listadocliente