@echo off
::mensaje de inicio, es solo una advertencia
cls
echo.
echo Advertencia.
echo.
echo Antes de empezar, se advierte que una vez empieza el proceso
echo de eliminacion de un agente, debe terminarlo sin cancelarlo,
echo ya que este proceso no se cancela.
echo.
echo Tambien, en caso de un cierre forzoso antes de terminar el proceso
echo de eliminacion del agente, lo unico que se modificara sera el numero
echo de propiedades de cada agente, incluyendo el que se va a eliminar
echo dependiendo cuantas propiedades transfirio a cada uno de esos agentes.
echo.
pause
::paso 1: agente a eliminar - variable usada: cieliminar
:inicio
cls
echo.
echo Eliminacion de agente:
echo.
echo Ingrese la cedula del agente a eliminar (0 para cancelar):
set /p cieliminar=
if %cieliminar% equ 0 ( goto :EOF )
::se asegura que existe tal agente
if not exist .\principal\usuario\agentes\%cieliminar%.txt (
	cls
	echo No existe un agente con tal cedula
	pause
	goto inicio
	)
::se asegura que existan propiedades asignadas a ese agente a eliminar, si no las tiene,
::simplemente elimina al agente (va a la etiqueta siguiente)
if not exist .\principal\sistema\agentes\%cieliminar%\infoprop\*.txt (
	echo No hay ninguna propiedad asignada a este agente.
	echo Eliminando directamente el agente...
	pause
	goto :siguiente
	)



::paso 2 - obtener el numero de props y cuales son
::- numero prop: cantprop
::- cuales son dentro de: .\principal\propasignar.txt - es un archivo auxiliar que se usa para contar las propiedades que posee con un for
::
::el dir pone cuales son las propiedades que maneja el agente a eliminar dentro del archivo propasignar
dir /b .\principal\sistema\agentes\%cieliminar%\infoprop > .\principal\propasignar.txt
::a traves de este for con el archivo creado con DIR, se obtiene el numero de propiedades.
SETLOCAL EnableDelayedExpansion
set cantprop=0
for /f %%i in ( .\principal\propasignar.txt ) do (
	set /a cantprop=!cantprop!+1
	)
::
::paso 3 - asignarles otro agente a las propiedades.
::BUCLE que se produce hasta que todas las propiedades del agente a eliminar sean asignadas a otros.
set contador=1
:repetir
set propiedad=nada
set nuevoagente=nada
::
::3.1 elegir agente a asignarle
:repetirpaso1
cls
echo Asignar propiedad a otro agente:
echo.
echo Propiedades que se le asignaron al agente a eliminar
echo aun por asignarle a un agente distinto:
echo.
::en pantalla muestra cuales son las propiedades que faltan por ser asignadas (dir /b)
dir /b .\principal\sistema\agentes\%cieliminar%\infoprop
echo.
echo Ingrese el agente a asignarle una propiedad:
set /p nuevoagente=
::se asegura que exista tal agente
if not exist .\principal\usuario\agentes\%nuevoagente%.txt (
	cls
	echo No existe un agente con tal cedula
	pause
	goto repetirpaso1
	)
::se asegura que el agente a eliminar no sea el mismo que el agente al que se le asignara esa propiedad
if %cieliminar% equ %nuevoagente% (
	cls
	echo No puede ingresar el agente que va a eliminar
	pause
	goto repetirpaso1
	)


::3.2 - elegir propiedad que se le asignara a ese agente
:repetirpaso2
cls
echo Asignar propiedad a otro agente:
echo.
echo Propiedades que se le asignaron al agente a eliminar
echo aun por asignarle a un agente distinto:
echo.
::muestra las propiedades que faltan por asignar (dir /b)
dir /b .\principal\sistema\agentes\%cieliminar%\infoprop
echo.
echo Ingrese que propiedad desea asignarle a ese agente ( %nuevoagente% ):
set /p propiedad=
::se asegura que tal propiedad exista
if not exist .\principal\sistema\agentes\%cieliminar%\infoprop\%propiedad%.txt (
	echo.
	echo Esa propiedad no existe o ya fue asignada a otro agente.
	pause
	goto repetirpaso2
	)
::
::3.3 - cambiar en el archivo de esa propiedad encontrado en sistema\propiedades el agente asignado
set contadorsecundario=1
for /f %%i in ( .\principal\sistema\propiedades\!propiedad!.txt ) do (
	if !contadorsecundario! neq 5 (
		echo %%i >> auxi.txt
	) else (
		echo !nuevoagente! >> auxi.txt
	)
	set /a contadorsecundario=!contadorsecundario!+1
)
type auxi.txt > .\principal\sistema\propiedades\%propiedad%.txt
del auxi.txt
::
::3.4 - mover el archivo de la propiedad que esta en infoprop del agente a eliminar al que se le asigna la propiedad
move>nul ".\principal\sistema\agentes\%cieliminar%\infoprop\%propiedad%.txt" ".\principal\sistema\agentes\%nuevoagente%\infoprop"
::
::3.5 - cambia el numero de propiedades que el agente al que se le asigno una propiedad maneja
::obtiene cuales son las propiedades en un archivo auxiliar
dir /b .\principal\sistema\agentes\%nuevoagente%\infoprop > .\principal\propasignarsecundario.txt
::a traves de este for y con el archivo creado con DIR, se obtiene cual es el numero de propiedades que ahora posee
set cantpropsecundario=0
for /f %%i in ( .\principal\propasignarsecundario.txt ) do (
	set /a cantpropsecundario=!cantpropsecundario!+1
	)
::cambia la cantidad de propiedades que el nuevo agente ahora posee
set contadorsecundario=1
for /f %%i in ( .\principal\sistema\agentes\%nuevoagente%\%nuevoagente%.txt ) do (
	if !contadorsecundario! neq 4 (
		echo %%i >> auxi.txt
	) else (
		echo !cantpropsecundario! >> auxi.txt
	)
	set /a contadorsecundario=!contadorsecundario!+1
)
type auxi.txt > .\principal\sistema\agentes\%nuevoagente%\%nuevoagente%.txt
del auxi.txt
del .\principal\propasignarsecundario.txt
::
::3.6 - En caso de cierre forzoso, solo se modifique el numero de
::propiedades del agente a eliminar para que no haya errores.
::
::se guarda el numero de props que maneja
dir /b .\principal\sistema\agentes\%cieliminar%\infoprop > .\principal\propasignar.txt
set cantprop=0
for /f %%i in ( .\principal\propasignar.txt ) do (
	set /a cantprop=!cantprop!+1
	)
::cambia en el archivo del agente el numero de propiedades que maneja
set contador=1
for /f %%i in ( .\principal\sistema\agentes\%cieliminar%\%cieliminar%.txt ) do (
	if !contador! neq 4 (
		echo %%i >> auxi.txt
	) else (
		echo !cantprop! >> auxi.txt
	)
	set /a contador=!contador!+1
)
type auxi.txt > .\principal\sistema\agentes\%cieliminar%\%cieliminar%.txt
del auxi.txt
del .\principal\propasignar.txt
::
::3.7 - se asegura que ya no haya mas propiedades a asignar en el agente a eliminar.
::En caso de que aun falten, va a la etiqueta repetir y repite el proceso, en caso de que ya no,
::pasa la etiqueta siguiente
cls
echo Propiedad asignada a otro agente correctamente
pause
if %cantprop% equ %contador% ( goto :siguiente )
set /a contador=!contador!+1
goto :repetir
::
::3.8 - terminado de asignar a las props un agente o al no tener propiedades, elimina toda la informacion del agente.
:siguiente
cls
rd /S /Q .\principal\sistema\agentes\%cieliminar%
del /Q .\principal\usuario\agentes\%cieliminar%.txt
::si el agente no poseia propiedades, este archivo auxiliar no existiria, por lo tanto el if exist es solo para asegurarse
::de que no muestre ningun mensaje de error al decir que no existe tal ruta cuando tal archivo auxiliar no fue usado
if exist .\principal\propasignar.txt (
	del .\principal\propasignar.txt
	)
echo.
echo Agente eliminado exitosamente
pause
exit /b 0