##Instalacion y Mantenimiento de una Aplicacion Web
#Importar funciones de otros ficheros

###########################################################
#                 SUBPROGRAMAS ADICIONALES                #
###########################################################

function checkApacheStatus()
{
    aux=$(aptitude show apache2 | grep "State: installed")
	aux2=$(aptitude show apache2 | grep "Estado: instalado")
	aux3=$aux$aux2
	aux4=0
	if [ -z "$aux3" ]
	then #el if devuelve 0 si es true y 1 si es false
        let aux4=0
    else
        let aux4=1
    fi
    return $aux4
}

###########################################################
#                  1) INSTALL APACHE                      #
###########################################################
function apacheInstall()
{
	echo "instalando ..."
    sudo apt-get --assume-yes install apache2
    echo "realizando prueba de conexión..."
    aux=$(sudo netstat -anp | grep apache)
    if [[ -z aux ]]
    then 
        echo "¡PROBLEMAS CON LA CONEXIÓN"
        
    
}

###########################################################
#                  2) ACTIVAR APACHE                      #
###########################################################
function apacheAction()
{
    echo "activado apache..."
    sudo service apache2 start
    aux=$( sudo service apache2 status | grep "● apache2.service - The Apache HTTP Server")
    echo $aux
}

###########################################################
#                  3) INSTALAR PHP                        #
###########################################################
function phpInstall()
{
    aux=$(aptitude show php | grep "State: installed")
	aux2=$(aptitude show php | grep "Estado: instalado")
	aux3=$aux$aux2
	aux4=0
	if [ -z "$aux3" ]
	then
        echo "instalando..."
        sudo apt-get --assume-yes install php
        sudo apt install php libapache2-mod-php
    else
        echo "php ya estaba instalado"
    fi
    echo "reiniciando apache" 
    sudo service apache2 restart
}

###########################################################
#                  4) TESTEAR PHP                         #
###########################################################
function phpTest()
{
    echo "creando el archivo test.php"
    sudo sh -c 'echo "<?php phpinfo(); ?>" ?> /var/www/html/test.php'
    firefox-esr http://localhost/test.php
    
    #FALTA COMPROBAR PERMISOS
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
	echo -e "\n \n"
	echo -e "1 Instala Apache \n"
	echo -e "2 Activar Apache \n"
	echo -e "12 Salir \n"
	echo -e "\n \n"
	read -p "Elige una opcion:" opcionmenuppal
	case $opcionmenuppal in
			1) 
                if checkApacheStatus
                then 
                    apacheInstall
                else
                    echo "apache ya estaba instalado"
                fi
                ;;
            2)
                if checkApacheStatus
                then 
                    apacheInstall
                else
                    apacheAction
                fi 
                ;;
            3)
                
			12) 
                fin;;
			*) 
                ;;
	esac 
done 

echo "Fin del Programa" 
exit 0 
