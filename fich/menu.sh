##Instalacion y Mantenimiento de una Aplicacion Web
#Importar funciones de otros ficheros

###########################################################
#                  1) INSTALL APACHE                     #
###########################################################
function apacheInstall()
{
	aux=$(aptitude show apache2 | grep "State: installed")
	aux2=$(aptitude show apache2 | grep "Estado: instalado")
	aux3=$aux$aux2
	if [ -z "$aux3" ]
	then 
 	  echo "instalando ..."
 	  sudo apt-get install apache2
	else
   	  echo "apache ya estaba instalado"
    
	fi 
}

###########################################################
#                  2) ACTIVAR APACHE                      #
###########################################################
function apacheAction()
{

}
###########################################################
#                  3) INSTALAR PHP                        #
###########################################################
function phpInstall()
{
}
###########################################################
#                  4) TESTEAR PHP                         #
###########################################################
function phpTest()
{
}
###########################################################
#                  5) CREAR PYTHON3                       #
###########################################################
function createPython()
{
}
###########################################################
#                  6) INSTALAR PAQUETES                   #
###########################################################
function installPackages()
{
}
###########################################################
#                  7) TESTEAR PY VM                       #
###########################################################
function testPython()
{
}
###########################################################
#                  8) PROBAR COMPLEJIDAD                  #
###########################################################
function testComplejidad()
{
}
###########################################################
#                  9) VISUALIZAR COMPLEJIDAD              #
###########################################################
function viewContent()
{
}
###########################################################
#                  10) LOGS Y ERRORES                     #
###########################################################
function logsErrors()
{
}
###########################################################
#                  11) CONTROLA SSH                       #
###########################################################
function controlSSH()
{
}
###########################################################
#                     12) SALIR                          #
###########################################################

function fin()
{
	echo -e "¿Quieres salir del programa?(S/N)\n"
        read respuesta
	if [ $respuesta == "N" ] 
		then
			opcionmenuppal=0
		fi	
}

### MAIN ###
opcionmenuppal=0
while test $opcionmenuppal -ne 12
do
	#Muestra el menu
	echo -e "1 Instala Apache \n"
	echo -e "12 Salir \n"
	read -p "Elige una opcion:" opcionmenuppaltraductor
	case $opcionmenuppal in
			1) apacheInstall;;
			2) apacheAction;;
			3) 
			12) fin;;
			*) ;;

	esac 
done 

echo "Fin del Programa" 
exit 0 
