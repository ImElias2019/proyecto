@echo off
cls
echo.
echo Advertencia antes de iniciar:
echo.
echo Tenga en cuenta que al eliminar una propiedad que posea propietario,
echo el cliente propietario de ella sera eliminado del sistema.
pause
::menu inicial, se ingresa la propiedad
:inicio
cls
echo.
echo Eliminacion de propiedad:
echo.
echo Ingrese el padron de la propiedad (0 para cancelar)
set /p propiedad=
if %propiedad% equ 0 goto :EOF
::se asegura que exista tal propiedad
if not exist .\principal\sistema\propiedades\%propiedad%.txt (
	echo.
	echo Propiedad ingresada inexistente
	pause
	goto inicio
	)
::obtiene el agente a traves de un call
SETLOCAL EnableDelayedExpansion
set contador=1
for /f %%i in ( .\principal\sistema\propiedades\%propiedad%.txt ) do (
	if !contador! equ 5 (
		::hace call a la etiqueta para darle como parametro la linea 5, de esta manera
		::se obtiene cual es el agente en una variable. Hecho esto lo del agente, va a la etiqueta
		::donde estan las funciones que realiza sobre el cliente
		call :agenteeti %%i
		goto clienteeti
		)
	set /a contador=!contador!+1
)
::cambios sobre el agente que manejaba esa propiedad
::Elimina el archivo de infoprop
::ajusta el numero de propiedades que el agente ahora posee
:agenteeti
set agente=%1
::elimina el archivo de la propiedad en infoprop
del .\principal\sistema\agentes\%agente%\infoprop\%propiedad%.txt
::Establece el numero de propiedades que ahora posee
dir /b .\principal\sistema\agentes\%agente%\infoprop > .\principal\propasignar.txt
set cantprop=0
for /f %%i in ( .\principal\propasignar.txt ) do (
	set /a cantprop=!cantprop!+1
)
::cambia en el archivo del agente el numero de propiedades que maneja (linea 4 del archivo txt del agente)
set contador=1
for /f %%i in ( .\principal\sistema\agentes\%agente%\%agente%.txt ) do (
	if !contador! neq 4 (
		echo %%i >> auxi.txt
	) else (
		echo !cantprop! >> auxi.txt
	)
	set /a contador=!contador!+1
)
type auxi.txt > .\principal\sistema\agentes\%agente%\%agente%.txt
del auxi.txt
del .\principal\propasignar.txt
exit /b 0
::
::Elimina al cliente que alquilaba la propiedad
:clienteeti
::obtiene el cliente a traves del call, ya que le envia como parametro la linea 7 del txt de la propiedad
::despues va a la etiqueta final
set contador=1
for /f %%i in ( .\principal\sistema\propiedades\%propiedad%.txt ) do (
	if !contador! equ 7 (
		call :clienteeti2 %%i
		goto final
		)

	set /a contador=!contador!+1
)
:clienteeti2
set cliente=%1
::se asegura que posea un cliente, si no posee el cliente (0), sale del "call" que se hizo en el anterior for y va a la
::etiqueta "final"
if %cliente% equ 0 (
	exit /b 0
	)
::elimina al cliente si lo posee
del .\principal\sistema\clientes\%cliente%.txt
del .\principal\usuario\clientes\%cliente%.txt
exit /b 0

::elimina el archivo de la propiedad en sistema\propiedades y desplega un mensaje
:final
cls
del .\principal\sistema\propiedades\%propiedad%.txt
echo La propiedad fue eliminada exitosamente.
pause
exit /b 0