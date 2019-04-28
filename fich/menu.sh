##Instalacion y Mantenimiento de una Aplicacion Web
#Importar funciones de otros ficheros

###########################################################
#                 SUBPROGRAMAS ADICIONALES                #
###########################################################

function checkStatus()
{
    echo -e "Comprobando el estado de $1 \n"
    aux=$(aptitude show $1 | grep "State: installed")
	aux2=$(aptitude show $1 | grep "Estado: instalado")
	aux3=$aux$aux2
	aux4=0
	if [[ -z "$aux3" ]]
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
    fi
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
    echo "instalando..."
    sudo apt-get --assume-yes install php
    sudo apt install php libapache2-mod-php
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
#                  5) CREAR PYTHON3                       #
###########################################################
function createPython()
{
    dir=$(pwd | grep fich)
    if [ -n dir ]
    then 
        sudo apt-get --assume-yes install python-virtualenv virtualenv
        if checkStatus python3 
        then
            echo -e "instalando python3... \n"
            sudo apt-get --asume-yes install python3
        fi
    fi
    user=$(whoami)
    root="root"
    if [ "$user" == "$root" ]
    then
        echo "Como eres usuario root, se hace un log out para volver a ser un usuario"
        exit
        user=$(whoami)
    fi
    echo -e " \n"
    #Creamos entorno virtual 
    virtualenv env --python=python3
    dir="/home/$user/env"
    
    #Activamos entorno virtual
    echo "Se va ha activar el entorno virtual en $dir"
    cd $dir
    source bin/activate
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
	echo -e "3 Instalar el modulo php \n"
	echo -e "4 Testear PHP \n"
	echo -e "5 Crear un entorno para Python3 \n"
	echo -e "6 Instalar los paquetes para la aplicación \n"
	echo -e "7 Probar programa.py \n"
	echo -e "8 Instalar la aplicación \n"
	echo -e "9 Visualizar la aplicación \n"
	echo -e "10 Visualizar logs y errores de apache \n"
	echo -e "11 Controlar los intentos de conexióm de Apache \n"
	echo -e "12 Salir \n"
	echo -e "\n \n"
	read -p "Elige una opcion:" opcionmenuppal
	case $opcionmenuppal in
			1) 
                if checkStatus apache2
                then 
                    apacheInstall
                else
                    echo "apache ya estaba instalado"
                fi
                ;;
            2)
                if checkStatus apache2
                then 
                    apacheInstall
                else
                    apacheAction
                fi 
                ;;
            3)
                if checkStatus php
                then 
                    phpInstall
                else
                    echo "php ya estaba instalado"
                fi
                ;;
            4)
                if checkStatus php
                then
                    phpInstall
                else
                    phpTest
                fi
                ;;
            5)
                createPython;;
			12) 
                fin;;
			*) 
                ;;
	esac 
done 

echo "Fin del Programa" 
exit 0 
