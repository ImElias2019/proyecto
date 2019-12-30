@echo off
:inicio
cls
::Se guardan todos los datos para la creacion del cliente dentro de variables para al
::final crear un archivo de texto que contenga la informacion ingresada

::ingreso de la cedula, se ingresa 0 para cancelar
echo Ingrese los siguientes datos del cliente:
echo Ingrese la cedula (ingrese 0 para cancelar):
echo.
echo (Al digitar la cedula, no ingrese ningun guion)
set /p ci=
if %ci% equ 0 goto :EOF

::se asegura que no existe un agente/admin/cliente con esa cedula (en el orden mencionado)
if exist .\principal\usuario\agentes\%ci%.txt (
	cls
	echo No se puede crear un cliente que sea agente de la inmobiliaria.
	echo Presione una tecla para continuar.
	pause>nul
	goto inicio
	)
if exist .\principal\usuario\admin\%ci%.txt (
	cls
	echo No se puede crear un cliente que sea administrador de la inmobiliaria.
	echo Presione una tecla para continuar..
	pause>nul
	goto inicio
	)
if exist .\principal\usuario\clientes\%ci%.txt (
	cls
	echo No se puede crear un cliente que ya exista.
	echo Presione una tecla para continuar...
	pause>nul
	goto inicio
	)

::ingreso de la clave del cliente
cls
echo Ingrese la clave del cliente (ingrese 0 para cancelar)
echo.
echo (sin espacios, sustituya el espacio por un
echo guion bajo. Tampoco tildes, o la letra "enie")
set /p clave=
if %clave% equ 0 goto :EOF

::Le pide el nombre
cls
echo Ingrese el nombre del cliente (ingrese 0 para cancelar)
echo.
echo (sin espacios, sustituya el espacio por un
echo guion bajo. Tampoco tildes, o la letra "enie")
set /p nombre=
if %nombre% equ 0 goto :EOF

::Le pide el apellido
cls
echo Apellido del cliente (ingrese 0 para cancelar)
echo.
echo (sin espacios, sustituya el espacio por un
echo guion bajo. Tampoco tildes, o la letra "enie")
set /p apellido=
if %apellido% equ 0 goto :EOF

::Le pide la fecha de ingreso del cliente
cls
echo Fecha de ingreso del cliente (DD/MM/AAAA) (ingrese 0 para cancelar)
echo.
echo (sin espacios, sustituya el espacio por un
echo guion bajo. Tampoco tildes, o la letra "enie")
set /p fechaingreso=
if %fechaingreso% equ 0 goto :EOF

::Le pide la edad
cls
echo Edad del cliente (ingrese 0 para cancelar)
echo.
echo (sin espacios, sustituya el espacio por un
echo guion bajo. Tampoco tildes, o la letra "enie")
set /p edad=
if %edad% equ 0 goto :EOF

::Le pide el telefono
cls
echo Telefono del cliente (ingrese 0 para cancelar)
echo.
echo (sin espacios, sustituya el espacio por un
echo guion bajo. Tampoco tildes, o la letra "enie")
set /p telefono=
if %telefono% equ 0 goto :EOF

::Le pide que propiedad quiere darle al cliente.
::La etiqueta existe para casos donde la propiedad no exista o que ya posea un propietario
:propiedadalquilaetiqueta
cls
echo Propiedad que alquila (ingrese 0 para cancelar)
echo.
echo (sin espacios, sustituya el espacio por un
echo guion bajo. Tampoco tildes, o la letra "enie")
set /p propiedad=
if %propiedad% equ 0 ( goto :EOF )
::Se asegura que tal propiedad exista
if not exist .\principal\sistema\propiedades\%propiedad%.txt (
	echo Esa propiedad no existe, eliga una que exista.
	pause
	goto propiedadalquilaetiqueta
	)
::Confirma si la propiedad posee propietario o no.
::Busca si la linea 6 del archivo txt de la propiedad
::tiene valor 1 por medio de un FOR, esto sirve
::para identificar si posee propietario (1) o no (0)
set contador=1
SETLOCAL EnableDelayedExpansion
for /f %%i in ( .\principal\sistema\propiedades\%propiedad%.txt ) do (
	if !contador! equ 6 (
		if %%i equ 1 (
			echo Esa propiedad ya tiene propietario, eliga otra
			pause
			goto propiedadalquilaetiqueta
		)
	)
	set /a contador=!contador!+1
)
ENDLOCAL

::Le pide el precio monto del alquiler
cls
echo Precio del alquiler de la propiedad alquilada
echo (ingrese 0 para cancelar)
echo.
echo (sin espacios, sustituya el espacio por un
echo guion bajo. Tampoco tildes, o la letra "enie")
set /p precioalquiler=
if %precioalquiler% equ 0 goto :EOF

::Crea el archivo txt del cliente en "usuario"
::Redirige la clave en un archivo txt con la cedula del cliente
echo %clave% >> .\principal\usuario\clientes\%ci%.txt

::Crea el archivo txt del cliente en "sistema"
::Redirige toda la informacion sobre el cliente a un archivo txt
echo %nombre% >> .\principal\sistema\clientes\%ci%.txt
echo %apellido% >> .\principal\sistema\clientes\%ci%.txt
echo %fechaingreso% >> .\principal\sistema\clientes\%ci%.txt
echo %edad% >> .\principal\sistema\clientes\%ci%.txt
echo %telefono% >> .\principal\sistema\clientes\%ci%.txt
echo %propiedad% >> .\principal\sistema\clientes\%ci%.txt

::asigna a la propiedad un valor 1 en la linea 6 para que se pueda identificar que la propiedad posee un propietario
SETLOCAL EnableDelayedExpansion
set contador=1
for /f %%i in ( .\principal\sistema\propiedades\%propiedad%.txt ) do (
	if !contador! neq 6 (
		echo %%i >> auxi.txt
	) else (
		echo 1 >> auxi.txt
	)
	set /a contador=!contador!+1
)
ENDLOCAL
type auxi.txt > .\principal\sistema\propiedades\%propiedad%.txt
del auxi.txt

::Esto hace lo mismo, redirigir la informacion, solo que quedo separado de los otros
echo %precioalquiler% >> .\principal\sistema\clientes\%ci%.txt

::asigna al archivo de propiedad un cliente (linea 7)
set contador=1
SETLOCAL EnableDelayedExpansion
for /f %%i in ( .\principal\sistema\propiedades\%propiedad%.txt ) do (
	if !contador! neq 7 (
		echo %%i >> auxi.txt
	) else (
		echo !ci! >> auxi.txt
	)
set /a contador=!contador!+1
)
type auxi.txt > .\principal\sistema\propiedades\%propiedad%.txt
del auxi.txt

cls
echo Nuevo cliente ingresado correctamente
pause