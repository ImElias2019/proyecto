@echo off
::menu inicial, las variables declaradas al inicio estan asi a causa de unos errores que pude solucionar de esa forma
:ingresodedatos
set ci=1
set opc=100
set propiedad=1
set modificacion=nada
cls
echo.
echo Modificacion de los datos de un cliente:
echo.
echo Ingrese la cedula del cliente a modificar (ingrese 0 para volver)
set /p ci=
if %ci% equ 0 (
goto :EOF
)
::se asegura que exista el cliente ingresado
if not exist .\principal\usuario\clientes\%ci%.txt (
	echo El usuario no existe
	pause
	goto ingresodedatos
	)

::muestra el menu con opciones de modificacion asi como la informacion del cliente
:datoscliente
cls
echo Datos del cliente:
echo.
::sirve para mostrar la info con su respectivo tipo de dato
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
echo.
::menu con opciones de modificacion
echo Eliga que dato desea modificar:
echo 1. Nombre
echo 2. Apellido
echo 3. Edad
echo 4. Telefono
echo 5. Propiedad alquilada
echo 6. Precio del alquiler
echo 7. Clave
echo 0. Volver al menu de agente 
set /p opc=
if %opc% equ 0 ( goto :EOF )
::como la linea 3 pertenece a la fecha de ingreso en el archivo txt del cliente en sistema, cuando es mayor o igual a 3,
::la variable aumenta en 1, permitiendo facilitar encontrar cual es la linea a modificar mas adelante
if %opc% geq 3 (
	set /a opc=%opc%+1
	)

::se asegura ingresen valores correctos
if %opc% lss 1 (
	echo Valor incorrecto ingresado
	pause
	goto datoscliente
	)
if %opc% gtr 8 (
	echo Valor incorrecto ingresado
	pause
	goto datoscliente
	)
::menu con la info del cliente y opciones con que cosas puede modificar
:ingresardenuevo
cls
echo.
echo Modificacion de datos:
if %opc% equ 1 ( echo Nombre )
if %opc% equ 2 ( echo Apellido )
if %opc% equ 4 ( echo Edad )
if %opc% equ 5 ( echo Telefono )
if %opc% equ 6 ( echo Propiedad alquilada )
if %opc% equ 7 ( echo Precio del alquiler )
if %opc% equ 8 ( echo Clave )
echo.
echo Ingrese la nueva informacion (ingrese 0 si quiere volver)
set /p modificado=
if %modificado% equ 0 ( goto datoscliente )
::en caso que no sean las opciones 5+1 y 7+1, va a la etiqueta modificacionotrosdatos, ya que las opciones
::6 y 8 son mas complicadas de realizar, por lo que tienen lugares apartados para si.
if %opc% neq 6 (
if %opc% neq 8 (
goto modificacionotrosdatos
) )

::si es la opcion 7+1 (clave) modifica la clave del cliente
if %opc% equ 8 (
	echo %modificado% > .\principal\usuario\clientes\%ci%.txt
	echo Nueva clave creada con exito.
	pause
	exit /b 0
	)

::si es la opcion 5+1 (propiedades) entra a esto para asegurarse de que existan las propiedades y que no tengan
::propietario
SETLOCAL EnableDelayedExpansion
if %opc% equ 6 (
	::si no existe, le pide que reingrese otra vez
	if not exist .\principal\sistema\propiedades\%modificado%.txt (
		echo Tal propiedad no existe, ingrese otra
		pause
		goto ingresardenuevo
	::en caso de que si exista tal propiedad, se asegura que no tenga propietario
	) else (
		set contador=1
		for /f %%i in ( .\principal\sistema\propiedades\%modificado%.txt ) do (
			if !contador! equ 6 (
				if %%i equ 1 (
				echo Esa propiedad ya tiene propietario, eliga otra
				pause
				goto ingresardenuevo
				) else (
				goto modificarpropiedad
				)
			)
			set /a contador=!contador!+1
		)
		ENDLOCAL

	)
)

::modificacion de datos en el archivo txt de sistemas en caso no sean la opcion 6 y 8
:modificacionotrosdatos
set contador=1
::modifica dependiendo que dato es, su respectiva linea en el archivo
::(se usa la variable opc para esto, de esa manera identifica la linea)
SETLOCAL EnableDelayedExpansion
for /f %%i in ( .\principal\sistema\clientes\%ci%.txt ) do (
	if !opc! neq !contador! (
		echo %%i >> auxi.txt
	) else (
		echo !modificado! >> auxi.txt
	)
	set /a contador=!contador!+1
)
ENDLOCAL
type auxi.txt > .\principal\sistema\clientes\%ci%.txt
del auxi.txt
echo Modificacion completada. Pulse una tecla para continuar
pause>nul
exit /b 0




::si se ingreso la opcion de propiedad, viene aqui
:modificarpropiedad
cls
set propiedad=%modificado%
set contador=1
SETLOCAL EnableDelayedExpansion
::obtiene la propiedad que poseia con un call, esto sirve para obtener la linea 6
for /f %%i in ( .\principal\sistema\clientes\!ci!.txt ) do (
	if !contador! equ 6 (
		call :sub %%i
		)
	set /a contador=!contador!+1
)
ENDLOCAL
exit /b 0
:sub
set propiedadantigua=%1
set contador=1
::le asigna sin propietario a la propiedad antigua con un valor 0 en la linea 6
SETLOCAL EnableDelayedExpansion
for /f %%i in ( .\principal\sistema\propiedades\%propiedadantigua%.txt ) do (
	if !contador! neq 6 (
		echo %%i >> auxi.txt
	) else (
		echo 0 >> auxi.txt
	)
	set /a contador=!contador!+1
)
ENDLOCAL
type auxi.txt > .\principal\sistema\propiedades\%propiedadantigua%.txt
del auxi.txt
::para la propiedad antigua...
::le asigna a la linea 7 un 0, para que se muestre que claramente no tiene ningun propietario ya que esta linea
::es para identificar cual es el propietario (CI propietario)
SETLOCAL EnableDelayedExpansion
set contador=1
for /f %%i in ( .\principal\sistema\propiedades\%propiedadantigua%.txt ) do (
	if !contador! neq 7 (
		echo %%i >> auxi.txt
	) else (
		echo 0 >> auxi.txt
	)
set /a contador=!contador!+1
)
type auxi.txt > .\principal\sistema\propiedades\%propiedadantigua%.txt
del auxi.txt
ENDLOCAL
::
::a la nueva propiedad
::le asigna propietario en la linea 6 (1) a la propiedad que se le asigna al cliente
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
::le asigna cual es el propietario de la nueva propiedad (para identificarlo, linea 7)
SETLOCAL EnableDelayedExpansion
set contador=1
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
ENDLOCAL
::en el archivo del cliente en sistema
::le asigna la nueva propiedad al cliente
set contador=1
SETLOCAL EnableDelayedExpansion
for /f %%i in ( .\principal\sistema\clientes\!ci!.txt ) do (
	if !opc! neq !contador! (
		echo %%i >> auxi.txt
	) else (
		echo !modificado! >> auxi.txt
	)
	set /a contador=!contador!+1
)
ENDLOCAL
type auxi.txt > .\principal\sistema\clientes\%ci%.txt
del auxi.txt

cls
echo.
echo Cliente con nueva propiedad
pause


exit /b 0