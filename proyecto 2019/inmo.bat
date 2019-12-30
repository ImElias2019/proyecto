@echo off
::mensaje de bienvenida y pone titulo al CMD
title "Inmobiliaria - La casita feliz"
cls
echo.
echo Antes de empezar, se advierte que para que el
echo programa corra con normalidad, no se deben ingresar los siguientes
echo caracteres a menos que se lo solicite:
echo.
echo -Letra "enie"
echo -Caracteres especiales (tildes, simbolos, etc)
echo -Espacios (sustituyalos por un guion bajo)
echo.
pause
cls
::se asegura de la creacion de la estructura de carpetas.
if not exist principal (
	md principal
	cd principal && md sistema usuario
	cd sistema && md agentes clientes propiedades
	cd ..\usuario && md administrador clientes agentes && cd ..\..
	)
::carpetausuario
if not exist .\principal\usuario (
	cd .\principal && md usuario && cd usuario
	md clientes agentes administrador && cd ..
	)
::carpetasistema
if not exist .\principal\sistema (
	cd .\principal && md sistema && cd sistema
	md agentes clientes propiedades && cd ..
	)

::menu de inicio
:inicio
set tipousuario=0
set ci=0
set clave=0
set opc=4
cls
echo.
echo Inicio de sesion:
echo.
echo Ingrese el tipo de usuario:
echo 1. Cliente
echo 2. Agente
echo 3. Administrador
echo 0. Salir
set /p opc=
set tipousuario=%opc%
::se asegura de que ingrese un numero correcto con respecto a una opcion del menu,
::si es incorrecto vuelve a desplegarlo 
if %opc% neq 1 (
if %opc% neq 2 (
if %opc% neq 3 (
if %opc% neq 0 (
echo.
echo Valor ingresado incorrecto, presione una tecla para continuar.
pause>nul
goto inicio
) ) ) )
::opciones goto
if %opc% EQU 1 goto cliente
if %opc% EQU 2 goto agente
if %opc% EQU 3 goto admin
if %opc% EQU 0 goto salir
::cuando se ingresa la opcion de salir, se pide una confirmacion por parte del usuario
::1 es para confirmar la salida, 2 para volver
:salir
cls
echo Estas seguro que deseas salir?
echo 1. Si      2. No
set /p opc=
::se asegura que se ingrese la opcion correcta
if %opc% neq 1 (
if %opc% neq 2 (
echo Valor ingresado incorrecto, presione una tecla para continuar
pause>nul 
goto salir
) )
::instrucciones para la confirmacion de salida / 1 sale, 2 vuelve
if %opc% equ 1 ( exit )
if %opc% equ 2 goto inicio
::
::todo lo relacionado a cliente
:cliente
cls
echo Bienvenido, cliente!
::call para hacer el inicio de sesion. El parametro sirve para poder identificar luego al usuario con el que se trata
call .\calls\iniciosesion.bat %opc%
::si logro iniciar sesion, este sera el menu desplegado para el usuario cliente
:iniciosesioncliente
cls
set opc=0
echo.
echo Cliente:
echo.
echo 1. Ver datos.
echo 2. Informacion sobre la propiedad que alquila
echo 0. Volver al inicio.
set /p opc=
if %opc% equ 0 ( goto inicio )
cls
::se asegura que los valores ingresados sean los correctos
if %opc% neq 1 (
if %opc% neq 2 (
	echo Valor incorrecto ingresado.
	pause>nul
	goto iniciosesioncliente
) )
if %opc% equ 1 goto Copc1
if %opc% equ 2 goto Copc2
:Copc1
::Usa un for para desplegar la informacion del cliente. Una vez el contador aumenta, es porque aumenta la linea, cambiando lo que va a escribir
SETLOCAL EnableDelayedExpansion
echo Datos del cliente - %ci%
echo.
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
echo Presione una tecla para continuar
pause>nul
goto iniciosesioncliente
ENDLOCAL
::
::muestra la info de la propiedad del cliente
:Copc2
SETLOCAL EnableDelayedExpansion
set contador=1
for /f %%i in ( .\principal\sistema\clientes\%ci%.txt ) do (
	if !contador! equ 6 (
		call :obtenerpropiedad %%i
		goto iniciosesioncliente
		)
	set /a contador=!contador!+1
)
ENDLOCAL
:obtenerpropiedad
cls
set propiedadinfo=%1
echo.
echo Informacion de la propiedad alquilada - %propiedadinfo%
echo.
SETLOCAL EnableDelayedExpansion
set cont=1
for /f %%i in ( .\principal\sistema\propiedades\%propiedadinfo%.txt ) do (
	if !cont! equ 1 echo -Direccion:
	if !cont! equ 2 echo -Barrio:
	if !cont! equ 3 echo -Tipo de propiedad:
	if !cont! equ 4 echo -Cantidad de dormitorios:
	if !cont! equ 5 echo -Agente asignado:
	if !cont! lss 6 (
	echo %%i
	)
	echo.
	set /a cont= !cont!+1
)
echo.
pause
exit /b 0
ENDLOCAL
::
::
::todo lo relacionado al agente
:agente
cls
echo Bienvenido, agente!
::call para hacer el inicio de sesion. El parametro sirve para poder identificar luego al usuario con el que se trata
call .\calls\iniciosesion.bat %opc%
::si lograron pasar por el inicio de sesion, este es el menu desplegado con todas las funciones de agente
:iniciosesionagente
cls
set ci=0
set opc=0
set clave=0
set datoscliente=0
echo Menu de agente:
echo.
echo Que desea hacer?
echo 1. Agregar nuevo cliente
echo 2. Modificar cliente
echo 3. Eliminar cliente
echo 4. Listado de clientes
echo 5. Listado de propiedades
echo 0. Volver al inicio
set /p opc=
::Se asegura que los valores ingresados sean correctos
if %opc% lss 0 (
	echo.
	echo Valor incorrecto ingresado
	pause
	goto iniciosesionagente
	)
if %opc% gtr 5 (
	echo.
	echo Valor incorrecto ingresado
	pause
	goto iniciosesionagente
	)
::para ir a las etiquetas e iniciar las funciones
if %opc% EQU 1 goto nuevoclienteAg
if %opc% EQU 2 goto modificarclienteAg
if %opc% EQU 3 goto eliminarclienteAg
if %opc% EQU 4 goto listarclienteAg
if %opc% EQU 5 goto listarpropsAg
if %opc% EQU 0 goto inicio
::
::ABML CLIENTE (lo desarrolla el agente)
::Entra al batch de crear cliente
:nuevoclienteAg
call .\calls\nuevocliente.bat
goto iniciosesionagente
::Entra al batch de modificacion de cliente
:modificarclienteAg
call .\calls\modificarcliente.bat
goto iniciosesionagente
::Entra al batch de eliminacion de cliente
:eliminarclienteAg
call .\calls\eliminarcliente.bat
goto iniciosesionagente
::Entra al batch de listado de clientes
:listarclienteAg
call .\calls\listarcliente.bat
goto iniciosesionagente
::Entra al batch de listado de propiedades
:listarpropsAg
call .\calls\listarprop.bat
goto iniciosesionagente
::
::
::
::
::todo lo relacionado al admin
:admin
cls
echo Bienvenido, administrador!
::call para hacer el inicio de sesion. El parametro sirve para poder identificar luego al usuario con el que se trata
call .\calls\iniciosesion.bat %opc%
::menu desplejado con las distintas opciones para el administrador
:iniciosesionadmin
cls
echo Menu de administrador:
echo.
echo.
echo 1. Crear nuevo administrador
echo 2. Modificar clave de un administrador
echo 3. Eliminar a un administrador
echo 4. Listar todos los administradores
echo.
echo 5. Nuevo cliente
echo 6. Modificar cliente
echo 7. Eliminar cliente
echo 8. Listar cliente
echo.
echo 9. Nuevo agente
echo 10. Modificar agente
echo 11. Eliminar agente
echo 12. Listar agente
echo.
echo 13. Nueva propiedad
echo 14. Modificar propiedad
echo 15. Eliminar propiedad
echo 16. Listado de propiedades
echo.
echo 0. Volver al inicio
set /p opc=
::se asegura que los valores ingresados sean correctos
if %opc% lss 0 (
echo.
echo Valor incorrecto ingresado
pause
goto iniciosesionadmin
)
if %opc% gtr 16 (
echo.
echo Valor incorrecto ingresado
pause
goto iniciosesionadmin
)
::para ir a las distintas opciones con su respectiva etiqueta
::opciones admin
if %opc% equ 1 goto crearadmin
if %opc% equ 2 goto modificaradmin
if %opc% equ 3 goto eliminaradmin
if %opc% equ 4 goto listaradmin
::opciones cliente
if %opc% equ 5 goto nuevoclienteAd
if %opc% equ 6 goto modificarclienteAd
if %opc% equ 7 goto	eliminarclienteAd
if %opc% equ 8 goto listarclienteAd
::opciones agente
if %opc% equ 9 goto crearagente
if %opc% equ 10 goto modificaragente
if %opc% equ 11 goto eliminaragente
if %opc% equ 12 goto listaragente
::opciones propiedad
if %opc% equ 13 goto crearpropiedad
if %opc% equ 14 goto modificarpropiedad
if %opc% equ 15 goto eliminarpropiedad
if %opc% equ 16 goto listarpropAd
::para ir al inicio se ingresa 0
if %opc% equ 0 goto inicio
::
::ABML ADMIN
::cada etiqueta informa para que sirven las siguientes dos lineas
::(call para llamar a la funcion, y el goto para volver al menu)
:crearadmin
call .\calls\crearadmin.bat
goto iniciosesionadmin
:modificaradmin
call .\calls\modificaradmin.bat
goto iniciosesionadmin
:eliminaradmin
call .\calls\eliminaradmin.bat
goto iniciosesionadmin
::aqui no hace ningun call porque era innecesario otro batch
:listaradmin
cls
echo.
echo Listado de TODOS los administradores:
echo.
dir /b .\principal\usuario\administrador
echo.
echo.
pause
goto iniciosesionadmin
::
::
::ABML CLIENTE...
::cada etiqueta informa para que sirven las siguientes dos lineas
::(call para llamar a la funcion, y el goto para volver al menu)
:nuevoclienteAd
call .\calls\nuevocliente.bat
goto iniciosesionadmin
:modificarclienteAd
call .\calls\modificarcliente.bat
goto iniciosesionadmin
:eliminarclienteAd
call .\calls\eliminarcliente.bat
goto iniciosesionadmin
:listarclienteAd
call .\calls\listarcliente.bat
goto iniciosesionadmin
::
::
::ABML AGENTE... cada etiqueta informa para que sirven las siguientes
::dos lineas (call para llamar a la funcion, y el goto para volver al menu)
:crearagente
call .\calls\crearagente.bat
goto iniciosesionadmin
:modificaragente
call .\calls\modificaragente.bat
goto iniciosesionadmin
:eliminaragente
call .\calls\eliminaragente.bat
goto iniciosesionadmin
:listaragente
call .\calls\listaragente.bat
goto iniciosesionadmin
::
::
::ABML PROPIEDADES...
::cada etiqueta informa para que sirven las siguientes dos lineas
::(call para llamar a la funcion, y el goto para volver al menu)
:crearpropiedad
call .\calls\crearpropiedad.bat
goto iniciosesionadmin
:modificarpropiedad
call .\calls\modificarpropiedad.bat
goto iniciosesionadmin
:eliminarpropiedad
call .\calls\eliminarpropiedad.bat
goto iniciosesionadmin
:listarpropAd
call .\calls\listarprop.bat
goto iniciosesionagente