@echo off
::menu de inicio
:inicio
cls
echo.
echo Creacion de nuevo agente:
echo.
echo Ingrese la cedula del nuevo agente (ingrese 0 para cancelar):
set /p ci=
if %ci% equ 0 ( goto :EOF )
::se asegura de si existe un admin, agente, o cliente con esa cedula...
::si ya existe un agente con esa cedula
if exist .\principal\usuario\agentes\%ci%.txt (
	cls
	echo No se puede crear un agente que ya exista.
	echo Presione una tecla para continuar.
	pause>nul
	goto inicio
	)
::si ya existe un admin con esa cedula
if exist .\principal\usuario\administrador\%ci%.txt (
	cls
	echo No se puede crear un agente que sea administrador.
	echo Presione una tecla para continuar..
	pause>nul
	goto inicio
	)
::si ya existe un cliente con esa cedula
if exist .\principal\usuario\clientes\%ci%.txt (
	cls
	echo No se puede crear un agente que sea cliente de la inmobiliaria.
	echo Presione una tecla para continuar...
	pause>nul
	goto inicio
	)
::ingreso de la clave del agente
cls
echo.
echo Creacion de nuevo agente:
echo.
echo Ingrese la clave:
set /p clave=
::nombre del agente
cls
echo.
echo Creacion de nuevo agente:
echo.
echo Ingrese el nombre:
set /p nombre=
::apellido del agente
cls
echo.
echo Creacion de nuevo agente:
echo.
echo Ingrese el apellido
set /p apellido=
::mail del agente
cls
echo.
echo Creacion de nuevo agente:
echo.
echo Ingrese el mail de contacto
set /p mail=
::
::crea el archivo de usuario del agente con su contraseña, es el archivo que se usara para iniciar sesion
echo %clave% > .\principal\usuario\agentes\%ci%.txt
::
::crea el archivo de sistema con la info del agente sistema\agentes\cedulaagente\cedulaagente.txt
::1. nombre
::2. apellido
::3. mail
::4. cantidad de propiedades que maneja (0 cuando se crea)
md .\principal\sistema\agentes\%ci%
md .\principal\sistema\agentes\%ci%\infoprop
echo %nombre% >> .\principal\sistema\agentes\%ci%\%ci%.txt
echo %apellido% >> .\principal\sistema\agentes\%ci%\%ci%.txt
echo %mail% >> .\principal\sistema\agentes\%ci%\%ci%.txt
echo 0 >> .\principal\sistema\agentes\%ci%\%ci%.txt
cls
echo Agente nuevo creado exitosamente.
pause