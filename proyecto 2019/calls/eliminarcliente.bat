@echo off
::menu de inicio
:eliminar
cls
echo.
echo Eliminacion de cliente:
echo.
echo Ingrese que cliente desea eliminar (ingrese 0 para volver):
set /p ci=
if %ci% equ 0 ( goto :EOF )
::se asegura que exista tal cliente
if not exist .\principal\usuario\clientes\%ci%.txt (
	echo.
	echo No puede eliminar un cliente inexistente.
	pause
	goto eliminar
	)






::busca cual es la propiedad que posee el cliente y la manda a una variable a traves de un call
set contador=1
SETLOCAL EnableDelayedExpansion
for /f %%i in ( .\principal\sistema\clientes\!ci!.txt ) do (
	if !contador! equ 6 (
		call :sub %%i
	)
	set /a contador=!contador!+1
)
::el exit /b 0 sirve para cuando se elimino ya al cliente, el programa no prosiga con su ejecucion luego del call anterior
exit /b 0
::le asigna a la variable propiedad el parametro que se le envio en el call a la etiqueta
:sub
set propiedad=%1
::le asigna sin propietario (0) a la propiedad (linea 6)
set contador=1
for /f %%i in ( .\principal\sistema\propiedades\%propiedad%.txt ) do (
	if !contador! neq 6 (
		echo %%i >> auxi.txt
	) else (
		echo 0 >> auxi.txt
	)
	set /a contador=!contador!+1
)
type auxi.txt > .\principal\sistema\propiedades\%propiedad%.txt
del auxi.txt

::le asigna 0 (linea 7) ya que no hay propietario a identificar
set contador=1
for /f %%i in ( .\principal\sistema\propiedades\%propiedad%.txt ) do (
	if !contador! neq 7 (
		echo %%i >> auxi.txt
	) else (
		echo 0 >> auxi.txt
	)
set /a contador=!contador!+1
)
ENDLOCAL
type auxi.txt > .\principal\sistema\propiedades\%propiedad%.txt
del auxi.txt

::elimina los archivos del cliente y desplega un mensaje
del .\principal\sistema\clientes\%ci%.txt
del .\principal\usuario\clientes\%ci%.txt
cls
echo Cliente eliminado con exito
pause