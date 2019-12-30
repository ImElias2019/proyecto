@echo off
:inicio
set ci=nada
cls
echo.
echo Modificacion de agente:
echo Ingrese la cedula del agente a modificar (0 para cancelar)
set /p ci=
if %ci% equ 0 ( goto :EOF )
::se asegura que existe tal agente
if not exist .\principal\usuario\agentes\%ci%.txt (
	cls
	echo No existe un agente con tal cedula
	pause
	goto inicio
	)
:menu
set opc=nada
cls
::imprime en pantalla los datos del agente, que se pueden modificar, a traves del for
echo Datos del agente:
SETLOCAL EnableDelayedExpansion
set cont=1
for /f %%i in ( .\principal\sistema\agentes\%ci%\%ci%.txt ) do (
	if !cont! equ 1 echo Nombre:
	if !cont! equ 2 echo Apellido:
	if !cont! equ 3 echo Mail de contacto:
	if !cont! lss 4 ( echo %%i )
	echo.
	set /a cont= !cont!+1
)
ENDLOCAL
echo.
echo.
echo.
::menu con las opciones
echo Modificacion de agente:
echo.
echo Eliga que dato desea modificar
echo 1. Nombre
echo 2. Apellido
echo 3. Mail de contacto
echo 4. Clave
echo 0. Volver
set /p opc=
if %opc% equ 0 ( goto :inicio )
::se asegura que se ingresen valores correctos
if %opc% lss 1 (
	echo Valor incorrecto ingresado
	pause
	goto menu
	)
if %opc% gtr 4 (
	echo Valor incorrecto ingresado
	pause
	goto menu
	)

::ingresa en una variable la nueva informacion y la modifica dependiendo que se eligio
::si es la opc 4 (clave) va a una etiqueta - :clave
cls
echo.
echo Modificacion del agente:
if %opc% equ 1 ( echo Dato modificandose: Nombre )
if %opc% equ 2 ( echo Dato modificandose: Apellido )
if %opc% equ 3 ( echo Dato modificandose: Mail )
if %opc% equ 4 ( echo Dato modificandose: Clave )
echo.
echo Ingrese la nueva informacion (0 para volver)
set /p modificado=
if %modificado% equ 0 ( goto menu )
if %opc% equ 4 goto clave
::si son las primeras 3 opciones modifica esos datos, dependiendo que se ingreso, en el archivo del agente en sistema
set contador=1
SETLOCAL EnableDelayedExpansion
for /f %%i in ( .\principal\sistema\agentes\%ci%\%ci%.txt ) do (
	if !opc! neq !contador! (
		echo %%i >> auxi.txt
	) else (
		echo !modificado! >> auxi.txt
	)
	set /a contador=!contador!+1
)
ENDLOCAL
type auxi.txt > .\principal\sistema\agentes\%ci%\%ci%.txt
del auxi.txt
echo Modificacion completada. Pulse una tecla para continuar
pause>nul
goto :menu
::esto es solo para modificar la clave del agente
:clave
cls
echo %modificado% > .\principal\usuario\agentes\%ci%.txt
echo Modificacion completada. Pulse una tecla para continuar
pause>nul
goto :menu