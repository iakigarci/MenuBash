##Instalacion y Mantenimiento de una Aplicacion Web
#Importar funciones de otros ficheros

###########################################################
#                 SUBPROGRAMAS ADICIONALES                #
###########################################################

#!/bin/bash

dirMenu=$(pwd)
dirPython=$dirMenu
function checkStatus()
{
    echo -e ">>Comprobando el estado de $@... \n"
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

function checkStatusPY()
{
    echo -e ">>Comprobando el estado de $@... \n"
    aux=$(pip show $@)
    aux1=0
    if [[ -z "$aux" ]]
    then
        let aux1=0
    else
        let aux1=1
    fi
    return $aux1
}

function installAplication()
{
    if checkStatus $@
    then
        echo -e ">>Iinstalando $@ ... \n"
        sudo apt-get --assume-yes install $@ > /dev/null
    else 
        echo -e "$@ ya estaba instalado \n"
    fi
}

function installAplicationPY()
{
    if checkStatusPY $@ 
    then
        echo -e ">>Instalando $@... \n"
        pip install $@ > /dev/null
    else
        echo -e "$@ ya estaba instalado \n"
    fi
}


function checkEnvStatus
{
    aux=$(pip -V)
    aux2=0
    if [[ -z "$aux" ]]
    then
        let aux2=0
    else    
        let aux2=1
    fi
    return $aux2
}

function acticateEnv()
{
    echo -e ">>Activando entorno python... \n"
    if checkEnvStatus
    then
        createPython python3envmetrix
    fi
    source python3envmetrix/bin/activate
    aux=$(pip -V)
    if [[ -n "$aux" ]]
    then
        echo -e "ACTIVADO EL ENTORNO VIRTUAL \n"
        pip -V
    fi
}
    
###########################################################
#                  0) DESINSTALAR                         #
###########################################################

function unistall()
{
    sudo service apache2 stop
    sudo apt-get update
    sudo apt-get purgeapache2 apache2-utils apache2-data
    sudo apt-get purge php libapache2-mod-php
    sudo apt-get autoremove
    sudo rm -rf /var/www/html/*
}

###########################################################
#                  1) INSTALL APACHE                      #
###########################################################
function apacheInstall()
{
    #Instalamos Apache
    installAplication apache2
    
    #Realizamos pruebas de conexión
    echo "realizando prueba de conexión..."
    aux=$(sudo netstat -anp | grep apache)
    if [[ -z aux ]]
    then 
        echo "¡PROBLEMAS CON LA CONEXIÓN!"
    else
        sudo netstat -anp | grep apache | awk 'BEGIN{print "PUERTO\n------"} {printf $4,$2} {printf "\n"}'
    fi
}

###########################################################
#                  2) ACTIVAR APACHE                      #
###########################################################
function apacheAction()
{
    echo "activado apache..."
    sudo service apache2 start
    aux=$( sudo service apache2 status | grep active)
    echo $aux
    
    #Instalamos net-tools
    installAplication net-tools
    netstat -l | grep http
    sleep 1
}

###########################################################
#                  3) INSTALAR PHP                        #
###########################################################
function phpInstall()
{
    #Instalamos php y su dependencia
    installAplication php
    installAplication libapache2-mod-phpç
    
    #Reiniciamos apache
    echo -e ">>Reiniciando apache... \n" 
    sudo service apache2 restart
}

###########################################################
#                  4) TESTEAR PHP                         #
###########################################################
function phpTest()
{
    #Creamos el fichero test.php"
    echo "creando el archivo test.php"
    sudo sh -c 'echo "<?php phpinfo(); ?>" ?> /var/www/html/test.php'
    
    #Comprobamos los permisos
    user1=$(ls -l | grep test.php | awk '{printf $3}')
    user2=$(ls -l | grep index.html | awk '{printf $3}')
    if [[ "$user1" == "$user2" ]]
    then
        echo -e "Los ficheros tienene el user igual \n"
        sleep 2
        
        #Abrimos la pagina de información en firefox
        firefox-esr http://localhost/test.php
    else
        echo -e "¡Los usuarios de los fichero son diferentes! \n"
    fi
}

###########################################################
#                  5) CREAR PYTHON3                       #
###########################################################
function createPython()
{
    echo -e "COMPROBANDO PYTHON \n"
    cd dirMenu
    rm -d -rf $1
    installAplication python-virtualenv virtualenv
    installAplication python3
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
    virtualenv $1 --python=python3
    dirPython=$(pwd)
}   

###########################################################
#                  6) INSTALAR PAQUETES                   #
###########################################################
function installPackages()
{
    echo -e "INSTALANDO PAQUETES \n"
    #Instalamos los paquetes de Linux
    installAplication python3-pip
    installAplication dos2unix
    
    #Activamos el entorno virtual
    source python3envmetrix/bin/activate
    
    #Instalamos los paquetes de Python
    installAplicationPY numpy
    installAplicationPY nltk
    installAplicationPY argparse
    
    #Descativamos el entorno virtual
    deactivate
}

###########################################################
#                  7) TESTEAR PY VM                       #
###########################################################
function testPython()
{
    cd $dirPython
    
    #Activamos el entorno
    source python3envmetrix/bin/activate
    
    #Ejecutamos el programa de Python
    echo -e ">>Iniciando el script de Pyhton... \n"
    python3 complejidadtextual.py textos/english.doc.txt
    deactivate python3envmetrix
}

###########################################################
#                  8) PROBAR COMPLEJIDAD                  #
###########################################################
function complexAplicationInstall()
{
    #Copiamos todos los archivos a la carpeta /var/www/html
    cd $dirMenu
    echo "directorio actual $(pwd)"
    sudo rm -rf /var/www/html/index.php /var/www/html/webprocess.sh /var/www/html/complejidadtextual.py
    sleep 2
    sudo cp {index.php,webprocess.sh,complejidadtextual.py,textos/english.doc.txt} /var/www/html
    
    #Creamos el entorno virtual en la carpeta fich y lo pasamos a /var/www/html
    createPython python3envmetrix 
    sudo cp python3envmetrix /var/www/html
    dirPython = /var/www/html
    
    #Asignamos permisos
    sudo chown -R www-data:www-data /var/www
    sudo usermod -a -G www-data iakigarci
    sudo chmod -R 777 /var/www/html 

    #Cambiamos la variable VIRTUAL_ENV para que funcione todo correctamente
    cd /var/www/html
    sudo sed -i "s/^VIRTUAL_ENV=.*/VIRTUAL_ENV=\"\/var\/www\/html\/python3envmetrix\"/g" /var/www/html/
    acticateEnv
    sudo sed -i "s/^DIRVIRTPYTHON=.*/DIRVIRTPYTHON=\'\/var\/www\/html\/python3envmetrix\'/g" /var/www/html/
    installPackages
    ./webprocess.sh english.doc.txt
    
    #Volvemos a asignar permisos
    sudo chown -R www-data:www-data /var/www
    sudo usermod -a -G www-data iakigarci
    sudo chmod -R 777 /var/www/html 
    
}


###########################################################
#                  9) VISUALIZAR COMPLEJIDAD              #
###########################################################
function viewContent()
{
    #Mostramos el contenido en el buscador
    firefox-esr http://localhost/index.php
}

###########################################################
#                  10) LOGS Y ERRORES                     #
###########################################################
function logsErrors()
{
    cd $dirMenu
    #Cojemos 100 errores para mostrarlos
    tail -n 100 /var/log/apache2/error.log > errores.txt
    cat errores.txt | awk '{split($0,a,"ImportError:"); print a[2]}'
}

###########################################################
#                  11) Control de ssh                    #
###########################################################

function controlSSH()
{
	echo "Comprobando si SSH esta instalado ..."
	aux=$(aptitude show ssh | grep "State: installed")
	aux2=$(aptitude show ssh | grep "Estado: instalado")
	aux3=$aux$aux2
	if [ -z "$aux3" ]
	then
		echo "Instalando SSh ..."
		sudo aptitude install ssh
	else
		echo "SSH ya esta instalado"
	fi
	#Redirijo todos los logs fallidos al fichero fail.txt
	less /var/log/auth.log* | grep "Failed password" > /home/$(whoami)/fail.txt
	#Redirijo todos los logs aceptados al fichero accept.txt
	less /var/log/auth.log* | grep "Accepted password" > /home/$(whoami)/accept.txt



	input="/home/$(whoami)/fail.txt"
	while IFS= read -r var
	do
		imprimirFail "$var"
	done < "$input"

	input="/home/$(whoami)/accept.txt"
	while IFS= read -r var
	do
		imprimirAccept "$var"
	done < "$input"

	rm /home/$(whoami)/fail.txt
	rm /home/$(whoami)/accept.txt

	sleep 5
}

function imprimirFail()
{
	#En la variable IFS(INTERNAL FIELD SEPARATOR) guardo los " " que quiero splitear.
	#En resto de valores los guardo en la variable array.
  IFS=' ' read -r -a array <<< "$1"

	#Al hacer ${array} hago que con las llaves, me interprete la variable array como un string.
	echo "Status: [fail] Account name: ${array[10]}  Date: ${array[0]}, ${array[1]}, ${array[2]} "
}

function imprimirAccept()
{
	#En la variable IFS(INTERNAL FIELD SEPARATOR) guardo los " " que quiero splitear.
	#En resto de valores los guardo en la variable array.
  IFS=' ' read -r -a array <<< "$1"

	#Al hacer ${array} hago que con las llaves, me interprete la variable array como un string.
	echo "Status: [accept] Account name: ${array[8]}  Date: ${array[0]}, ${array[1]}, ${array[2]} "
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
installAplication aptitude 
while test $opcionmenuppal -ne 12
do
	#Muestra el menu
	echo -e " \n"
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
                apacheInstall
                ;;
            2)
                apacheInstall
                apacheAction
                ;;
            3)
                phpInstall
                ;;
            4)
                phpInstall
                phpTest
                ;;
            5)
                read -p "Introduce el nombre del entorno virtual:" rdo
                createPython $rdo
                ;;
            6)
                installPackages
                ;;
            7)
                installPackages
                testPython
                ;;
            8)
                complexAplicationInstall
                ;;
            9)
                viewContent
                ;;
            10)
                logsErrors
                ;;
			12) 
                fin
                ;;
			*) 
                ;;
	esac 
done 

echo "Fin del Programa" 
exit 0 
