@echo off
::mensaje de advertencia
cls
echo.
echo Advertencia:
echo.
echo Si no existen agentes registrados en el sistema,
echo no se podra crear una nueva propiedad, ya que la propiedad
echo debe poseer un agente asignado.
echo.
pause
::menu de inicio
:inicio
cls
echo.
echo Creacion de propiedad - Ingrese los siguientes datos:
echo.
echo Numero de padron (0 para cancelar):
set /p numpadron=
if %numpadron% equ 0 ( goto :EOF )
::se asegura que no haya una propiedad con ese padron
if exist .\principal\sistema\propiedades\%numpadron%.txt (
	echo Tal propiedad ya existe, ingrese otra
	pause
	goto inicio
	)
::ingreso de la direccion de la propiedad
cls
echo.
echo Creacion de propiedad - Ingrese los siguientes datos:
echo.
echo Direccion (0 para cancelar):
set /p direccion=
if %direccion% equ 0 ( goto :EOF )
::ingreso del barrio de la propiedad
cls
echo.
echo Creacion de propiedad - Ingrese los siguientes datos:
echo.
echo Barrio (0 para cancelar):
set /p barrio=
if %barrio% equ 0 ( goto :EOF )
::ingreso del tipo de propiedad
cls
echo.
echo Creacion de propiedad - Ingrese los siguientes datos:
echo.
echo Tipo de propiedad (0 para cancelar):
set /p tipoprop=
if %tipoprop% equ 0 ( goto :EOF )
::ingreso de la cantidad de dormitorios
cls
echo.
echo Creacion de propiedad - Ingrese los siguientes datos:
echo.
echo Cantidad de dormitorios (0 para cancelar):
set /p cantdormitorios=
if %cantdormitorios% equ 0 ( goto :EOF )
::ingreso del agente a asignarle
:asignaragente
cls
echo.
echo Creacion de propiedad - Ingrese los siguientes datos:
echo.
echo Agente a asignarle (0 para cancelar):
set /p agenteasignado=
if %agenteasignado% equ 0 ( goto :EOF )
::se asegura que exista tal agente, de no ser asi, vuelve a la etiqueta asignaragente
if not exist .\principal\usuario\agentes\%agenteasignado%.txt (
	echo.
	echo Tal agente no existe, ingrese otro
	pause
	goto asignaragente
	)
::ingreso de la direccion de la sucursal
cls
echo.
echo Creacion de propiedad - Ingrese los siguientes datos:
echo.
echo Direccion de la sucursal donde
echo se empezara el viaje a ella (0 para cancelar):
set /p direccionsucursal=
::
::Pone los datos en sus respectivos archivos
::-Archivo de propiedad
::1. pone direccion
::2. barrio
::3. tipo de propiedad
::4. cantidad dormitorios
::5. agente que se le asigna
::6. que no tiene dueño (0)
::7. linea para poner la cedula del cliente (0 cuando se crea, ya que no hay nada que identificar)
echo %direccion% >> .\principal\sistema\propiedades\%numpadron%.txt
echo %barrio% >> .\principal\sistema\propiedades\%numpadron%.txt
echo %tipoprop% >> .\principal\sistema\propiedades\%numpadron%.txt
echo %cantdormitorios% >> .\principal\sistema\propiedades\%numpadron%.txt
echo %agenteasignado% >> .\principal\sistema\propiedades\%numpadron%.txt
echo 0 >> .\principal\sistema\propiedades\%numpadron%.txt
echo 0 >> .\principal\sistema\propiedades\%numpadron%.txt
::archivo de propiedad que esta en infoprop del agente asignado
echo %direccionsucursal% >> .\principal\sistema\agentes\%agenteasignado%\infoprop\%numpadron%.txt
echo %direccion% >> .\principal\sistema\agentes\%agenteasignado%\infoprop\%numpadron%.txt
::
::establece la cantidad de propiedades del agente asignado, el dir para obtener las propiedades que el agente posee
::en un archivo, y el for para contar las lineas del archivo txt y asi saber cuantas propiedades hay
SETLOCAL EnableDelayedExpansion
dir /b .\principal\sistema\agentes\%agenteasignado%\infoprop > .\principal\propasignar.txt
set cantprop=0
for /f %%i in ( .\principal\propasignar.txt ) do (
	set /a cantprop=!cantprop!+1
	)
::cambia el numero de propiedades en el archivo txt del agente
set contador=1
for /f %%i in ( .\principal\sistema\agentes\%agenteasignado%\%agenteasignado%.txt ) do (
	if !contador! neq 4 (
		echo %%i >> auxi.txt
	) else (
		echo !cantprop! >> auxi.txt
	)
	set /a contador=!contador!+1
)
type auxi.txt > .\principal\sistema\agentes\%agenteasignado%\%agenteasignado%.txt
del auxi.txt
del .\principal\propasignar.txt
cls
echo Propiedad creada exitosamente
pause