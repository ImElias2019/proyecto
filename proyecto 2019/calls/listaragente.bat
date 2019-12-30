@echo off
::menu de inicio
:inicio
set ciagente=1
cls
echo Listado de agentes:
echo.
echo 1. Listar TODOS los agentes
echo 2. Listar la informacion especifica de un agente
echo 0. Volver
set /p opc=
if %opc% equ 0 ( goto :EOF )
::se asegura que se ingresen valores correctos
if %opc% lss 1 (
	echo.
	echo Valor incorrecto ingresado
	pause
	goto inicio
	)
if %opc% gtr 2 (
	echo.
	echo Valor incorrecto ingresado
	pause
	goto inicio
	)
::va a una etiqueta dependiendo la opcion
if %opc% equ 1 goto listadogeneral
if %opc% equ 2 goto listadoespecifico
::
::listado de todos los agentes
:listadogeneral
cls
echo.
echo Listado de TODOS los agentes:
echo.
dir /b .\principal\sistema\agentes
echo.
echo.
timeout>nul /T 1 /NOBREAK
pause
goto inicio
::
::listado de la informacion de un agente en especifico
:listadoespecifico
cls
echo.
echo Informacion de un agente especifico:
echo.
echo Ingrese la cedula del agente (0 para volver):
set /p ciagente=
if %ciagente% equ 0 ( goto inicio )
::se asegura exista el agente
if not exist .\principal\usuario\agentes\%ciagente%.txt (
	echo.
	echo Tal agente no existe, ingrese otro
	pause
	goto listadoespecifico
	)
::una vez se ingresa el agente, habran dos opciones en este menu
:listadoespecificopaso2
cls
echo.
echo 1. Ver informacion del agente
echo 2. Ver recorrido que hace hacia las propiedades
echo 0. Volver
set /p opc=
if %opc% equ 0 ( goto inicio )
::se asegura ingresen valores correctos
if %opc% lss 1 (
	echo.
	echo Valor incorrecto ingresado
	pause
	goto listadoespecificopaso2
	)
if %opc% gtr 2 (
	echo.
	echo Valor incorrecto ingresado
	pause
	goto listadoespecificopaso2
	)
::para ir a sus respectivas etiquetas dependiendo de la opcion
if %opc% equ 1 goto infoagente
if %opc% equ 2 goto recorrido
::
::muestra la info del agente
:infoagente
cls
set contador=1
SETLOCAL EnableDelayedExpansion
for /f %%i in ( .\principal\sistema\agentes\%ciagente%\%ciagente%.txt ) do (
	if !contador! equ 1 echo Nombre:
	if !contador! equ 2 echo Apellido:
	if !contador! equ 3 echo Mail:
	if !contador! equ 4 echo Propiedades que maneja:
	if !contador! lss 5 ( echo %%i )
	echo.
	set /a contador= !contador!+1
)
ENDLOCAL
timeout>nul /T 1 /NOBREAK
pause
goto listadoespecificopaso2
::
::muestra el recorrido que realiza de una sucursal a esa propiedad ingresada
::primero muestra cuales son las propiedades que el agente posee para poder
::buscar que recorrido tiene que hacer de una sucursal hasta esa propiedad
:recorrido
cls
echo.
echo Propiedades bajo el cargo del agente:
echo.
dir /b .\principal\sistema\agentes\%ciagente%\infoprop
echo.
echo Ingrese la propiedad para saber el recorrido (origen y destino) que realiza (0 para cancelar):
set /p propiedad=
if %propiedad% equ 0 goto listadoespecificopaso2
::se asegura que exista tal propiedad
if not exist .\principal\sistema\agentes\%ciagente%\infoprop\%propiedad%.txt (
	echo Tal propiedad no fue asignada a este agente o no existe.
	pause
	goto :recorrido
	)
::hecho eso, muestra la informacion de recorrido que hace con esa propiedad
cls
echo.
set contador=1
SETLOCAL EnableDelayedExpansion
for /f %%i in ( .\principal\sistema\agentes\%ciagente%\infoprop\%propiedad%.txt ) do (
	if !contador! equ 1 ( echo Origen: )
	if !contador! equ 2 ( echo Destino: )
	if !contador! lss 3 (
	echo %%i
	echo.
	)
	
	set /a contador=!contador!+1
)
ENDLOCAL
echo.
pause
goto listadoespecificopaso2