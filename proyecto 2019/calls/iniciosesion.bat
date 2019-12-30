@echo off
::Aqui con el parametro que entra al hacer call para el inicio de sesion que se hace en el batch principal,
::se asigna que tipo de usuario es para identificar la ruta que el programa debe revisar
::cuando se inicie sesion 
if %1 equ 1 (
set tipousuario=clientes
)
if %1 equ 2 (
set tipousuario=agentes
)
if %1 equ 3 (
set tipousuario=administrador
)
::
::Pide la cedula del usuario
:ingresodatos
cls
echo.
echo Inicio de sesion:
echo.
echo Ingrese la cedula (ingrese 0 para volver):
set ci=1
set /p ci=
::En vez de ir a la linea final, se usa este condicional para volver, ya que de otra manera se saltearia el
::inicio de sesion en el batch principal y accederian a las opciones sin importar si inicio sesion o no.
::Lo que hace es: iniciar de nuevo el programa y cerrar la ventana actual.
if %ci% equ 0 (
	start .\inmo.bat
	exit
	)
::
::Se asegura que existe el usuario (su archivo en su respectivo tipo), en caso de que no, le pide que reingrese la cedula
if not exist .\principal\usuario\%tipousuario%\%ci%.txt (
	echo No existe un usuario con tal cedula.
	pause>nul
	goto ingresodatos
	)

::si existe el usuario, le pide la clave
set clave=nada
cls
echo.
echo Ahora ingrese su clave de ingreso (0 para cancelar)
set /p clave=
if %clave% equ 0 (
	start .\inmo.bat
	exit
	)
::Ahora revisa que la clave sea correcta en el archivo del usuario.
::Este for permite recorrer el archivo de texto, y como la primer linea sera la clave, no hay necesidad de contador
::ya que automaticamente la identifica al ser la unica linea.
::Si la clave ingresada no es la misma que la del archivo, le pide que reingrese la cedula y la clave,
::pero de ser correcta, el programa simplemente termina, eliminando la "barrera" en el batch principal para acceder a las
::funciones del usuario respectivo
for /f %%i in ( .\principal\usuario\%tipousuario%\%ci%.txt ) do (
	if %%i equ %clave% (
		cls
		echo.
		echo Inicio de sesion exitoso
		pause
	) else (
		echo Clave incorrecta
		pause
		goto ingresodatos
	)
)