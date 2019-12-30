@echo off
::pide que propiedad se modificara
:inicio
set propiedad=nada
set agente=nada
cls
echo.
echo Modificacion de propiedad:
echo.
echo Ingrese la propiedad a modificar (0 para cancelar):
set /p propiedad=
if %propiedad% equ 0 ( goto :EOF )
::se asegura que exista la propiedad
if not exist .\principal\sistema\propiedades\%propiedad%.txt (
	echo.
	echo Tal propiedad no existe, ingrese el padron de nuevo.
	pause
	goto inicio
	)


:menu
set opc=10
cls
SETLOCAL EnableDelayedExpansion
::muestra en pantalla la informacion sobre esa propiedad
set contador=1
echo Informacion sobre la propiedad:
echo.
for /f %%i in ( .\principal\sistema\propiedades\%propiedad%.txt ) do (
	if !contador! equ 1 ( echo -Direccion )
	if !contador! equ 2 ( echo -Barrio )
	if !contador! equ 3 ( echo -Tipo de propiedad )
	if !contador! equ 4 ( echo -Cantidad de dormitorios )
	if !contador! equ 5 ( echo -Agente asignado )
	if !contador! equ 6 ( echo -Si posee propietario - 1. Si / 0. No )
	if !contador! equ 7 ( echo -Propietario asignado / 0 significa que no posee ninguno )
	echo %%i
	echo.
	set /a contador=!contador!+1
)
::opciones de las cosas que puede modificar
echo.
echo Que desea modificar?
echo 1. Direccion
echo 2. Barrio
echo 3. Tipo de propiedad
echo 4. Cantidad de dormitorios
echo 5. Agente asignado
echo 0. Volver
set /p opc=
if %opc% equ 0 goto :EOF
::se asegura que se ingresen valores incorrectos
if %opc% lss 1 (
	cls
	echo.
	echo Valor incorrecto ingresado
	pause
	goto menu
	)
if %opc% gtr 5 (
	cls
	echo.
	echo Valor incorrecto ingresado
	pause
	goto menu
	)
::para ir a las etiquetas
if %opc% equ 1 goto cambiardireccion
if %opc% equ 2 goto barrio
if %opc% equ 3 goto tipoprop
if %opc% equ 4 goto cantdormitorios
if %opc% equ 5 goto agenteasignar
::
::OPC1 cambiar direccion
:cambiardireccion
cls
echo.
echo Cambiar direccion de...
echo 1. Direccion de la sucursal
echo 2. Direccion de la propiedad
echo 0. Volver
set /p opcdireccion=
if %opcdireccion% equ 0 goto menu
if %opcdireccion% lss 1 (
	cls
	echo.
	echo Valor incorrecto ingresado
	pause
	goto cambiardireccion
	)
if %opcdireccion% gtr 2 (
	cls
	echo.
	echo Valor incorrecto ingresado
	pause
	goto cambiardireccion
	)
if %opcdireccion% equ 1 goto dirsucursaleti
if %opcdireccion% equ 2 goto dirpropiedadeti
::para cambiar la direccion de la sucursal
:dirsucursaleti
cls
echo.
echo Ingrese la direccion de la sucursal donde se iniciara
echo el viaje a ella (0 para cancelar)
echo.
set /p dirsucursal=
if %dirsucursal% equ 0 ( goto cambiardireccion )
::obtiene cual es el agente para usarlo como una variable e identificarlo en la ruta
::el call a una etiqueta dentro del if es para enviar la linea 5 a una variable, ya que de otra manera no se obtendria
set contador=1
for /f %%i in ( .\principal\sistema\propiedades\!propiedad!.txt ) do (
	if !contador! equ 5 (
		call :sub %%i
		goto menu
		)	
	set /a contador=!contador!+1
)
:sub
set agente=%1
::se cambia la linea 1 del archivo txt en infoprop (direccion sucursal)
set contador=1
for /f %%i in ( .\principal\sistema\agentes\%agente%\infoprop\%propiedad%.txt ) do (
	if !contador! neq 1 (
		echo %%i >> auxi.txt
	) else (
		echo !dirsucursal! >> auxi.txt
	)
	set /a contador=!contador!+1
)
type auxi.txt > .\principal\sistema\agentes\%agente%\infoprop\%propiedad%.txt
del auxi.txt
cls
echo Direccion de la sucursal cambiada con exito.
exit /b 0
::
::cambiar direccion de la propiedad
:dirpropiedadeti
cls
echo.
echo Ingrese la direccion propiedad (0 para cancelar)
echo.
set /p dirpropiedad=
if %dirpropiedad% equ 0 ( goto cambiardireccion )
::obtiene cual es el agente para usarlo como una variable e identificarlo en la ruta
::el call hace lo mismo que en el anterior for de cambiar direccion sucursal
set contador=1
for /f %%i in ( .\principal\sistema\propiedades\!propiedad!.txt ) do (
	if !contador! equ 5 (
		call :sub %%i
		goto menu
		)	
set /a contador=!contador!+1
)
:sub
set agente=%1
::se cambia la linea 2 del archivo txt en infoprop 
set contador=1
for /f %%i in ( .\principal\sistema\agentes\%agente%\infoprop\%propiedad%.txt ) do (
	if !contador! neq 2 (
		echo %%i >> auxi.txt
	) else (
		echo !dirpropiedad! >> auxi.txt
	)
	set /a contador=!contador!+1
)
type auxi.txt > .\principal\sistema\agentes\%agente%\infoprop\%propiedad%.txt
del auxi.txt
::cambia la direccion de la propiedad en el archivo de sistema\propiedades --- linea 1
set contador=1
for /f %%i in ( .\principal\sistema\propiedades\%propiedad%.txt ) do (
	if !contador! neq 1 (
		echo %%i >> auxi.txt
	) else (
		echo !dirpropiedad! >> auxi.txt
	)
	set /a contador=!contador!+1
)
type auxi.txt > .\principal\sistema\propiedades\%propiedad%.txt
del auxi.txt
cls
echo Direccion de la propiedad cambiada con exito.
exit /b 0
::
::OPC2 - cambia el barrio
:barrio
cls
echo.
echo Modificacion del barrio de
echo la propiedad (0 para cancelar)
echo.
echo Ingrese el barrio:
set /p barrio=
if %barrio% equ 0 goto menu
::cambia la linea 2 en el archivo de sistema\propiedades - es la que contiene el barrio
set contador=1
for /f %%i in ( .\principal\sistema\propiedades\%propiedad%.txt ) do (
	if !contador! neq 2 (
		echo %%i >> auxi.txt
	) else (
		echo !barrio! >> auxi.txt
	)
	set /a contador=!contador!+1
)
type auxi.txt > .\principal\sistema\propiedades\%propiedad%.txt
del auxi.txt
cls
echo.
echo Barrio modificado con exito
pause
goto menu
::
::OPC3 - cambia el tipo de propiedad
:tipoprop
cls
echo.
echo Modificacion del tipo de
echo propiedad (0 para cancelar)
echo.
echo Ingrese que tipo de propiedad es:
set /p tipo=
if %tipo% equ 0 goto menu
::cambia la linea 3 en el archivo de sistema\propiedades - es la que contiene el tipo de propiedad
set contador=1
for /f %%i in ( .\principal\sistema\propiedades\%propiedad%.txt ) do (
	if !contador! neq 3 (
		echo %%i >> auxi.txt
	) else (
		echo !tipo! >> auxi.txt
	)
	set /a contador=!contador!+1
)
type auxi.txt > .\principal\sistema\propiedades\%propiedad%.txt
del auxi.txt
cls
echo.
echo Tipo de propiedad modificado con exito
pause
goto menu
::
::OPC4 - cantidad de dormitorios
:cantdormitorios
cls
echo.
echo Modificacion de la cantidad de dormitorios
echo de la propiedad (0 para cancelar)
echo.
echo Ingrese cuantos dormitorios posee:
set /p dormitorios=
if %dormitorios% equ 0 goto menu
::cambia la linea 4 en el archivo de sistema\propiedades - es la que contiene la cantidad de dormitorios
set contador=1
for /f %%i in ( .\principal\sistema\propiedades\%propiedad%.txt ) do (
	if !contador! neq 4 (
		echo %%i >> auxi.txt
	) else (
		echo !dormitorios! >> auxi.txt
	)
	set /a contador=!contador!+1
)
type auxi.txt > .\principal\sistema\propiedades\%propiedad%.txt
del auxi.txt
cls
echo.
echo Cantidad de dormitorios modificado con exito
pause
goto menu
::
::
::
:: OPC5
::modificacion del agente de la propiedad
:agenteasignar
::1 - elegir agente a asignarle
cls
echo Asignar propiedad a otro agente:
echo.
echo Ingrese el agente a asignarle la propiedad (0 para cancelar):
set /p nuevoagente=
if %nuevoagente% equ 0 goto menu
::se asegura que exista tal agente
if not exist .\principal\usuario\agentes\%nuevoagente%.txt (
	cls
	echo No existe un agente con tal cedula
	pause
	goto agenteasignar
	)
::
::2 - cambiar en el archivo encontrado en sistema\propiedades el agente asignado
::tambien se asegura de pasar a una variable cual es el agente antiguo de la propiedad
set contador=1
for /f %%i in ( .\principal\sistema\propiedades\!propiedad!.txt ) do (
	if !contador! equ 5 (
		call :sub %%i
		exit /b 0
		)	
	set /a contador=!contador!+1
)
:sub
set antiguoagente=%1
::a la propiedad le asigna la cedula del agente nuevo que se le asigno
set contador=1
for /f %%i in ( .\principal\sistema\propiedades\!propiedad!.txt ) do (
	if !contador! neq 5 (
		echo %%i >> auxi.txt
	) else (
		echo !nuevoagente! >> auxi.txt
	)
	set /a contador=!contador!+1
)
type auxi.txt > .\principal\sistema\propiedades\%propiedad%.txt
del auxi.txt
::
::3 - mover el archivo de la propiedad que esta en infoprop del agente antiguo, al agente que se le asigna la propiedad
move>nul ".\principal\sistema\agentes\%antiguoagente%\infoprop\%propiedad%.txt" ".\principal\sistema\agentes\%nuevoagente%\infoprop"
::
::
::4 - cambiar el numero de propiedades de los agentes
::Agente antiguo...
::se guarda el numero de propiedades que posee, con el dir /b guarda en un archivo cuantas propiedades hay,
::cada linea es una propiedad, y por cada linea, el contador del for aumenta en 1
dir /b .\principal\sistema\agentes\%antiguoagente%\infoprop > .\principal\propasignar.txt
set cantprop=0
for /f %%i in ( .\principal\propasignar.txt ) do (
	set /a cantprop=!cantprop!+1
	)
::cambia en el archivo del agente el numero de propiedades que maneja (linea 4 del archivo txt con su info)
set contador=1
for /f %%i in ( .\principal\sistema\agentes\%antiguoagente%\%antiguoagente%.txt ) do (
	if !contador! neq 4 (
		echo %%i >> auxi.txt
	) else (
		echo !cantprop! >> auxi.txt
	)
	set /a contador=!contador!+1
)
type auxi.txt > .\principal\sistema\agentes\%antiguoagente%\%antiguoagente%.txt
del auxi.txt
del .\principal\propasignar.txt
::
::para el nuevo agente
::se guarda el numero de propiedades que posee, con el dir /b guarda en un archivo cuantas propiedades hay,
::cada linea es una propiedad, y por cada linea, el contador del for aumenta en 1
dir /b .\principal\sistema\agentes\%nuevoagente%\infoprop > .\principal\propasignar.txt
set cantprop=0
for /f %%i in ( .\principal\propasignar.txt ) do (
	set /a cantprop=!cantprop!+1
	)
::cambia en el archivo del agente el numero de propiedades que maneja (linea 4 archivo txt con su info)
set contador=1
for /f %%i in ( .\principal\sistema\agentes\%nuevoagente%\%nuevoagente%.txt ) do (
	if !contador! neq 4 (
		echo %%i >> auxi.txt
	) else (
		echo !cantprop! >> auxi.txt
	)
	set /a contador=!contador!+1
)
type auxi.txt > .\principal\sistema\agentes\%nuevoagente%\%nuevoagente%.txt
del auxi.txt
del .\principal\propasignar.txt

cls
echo Propiedad asignada a otro agente correctamente
pause