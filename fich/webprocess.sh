#!/bin/bash
DIRVIRTPYTHON='Introduce el path donde esta el entorno virtual de python3'
source $DIRVIRTPYTHON/bin/activate
cd /var/www/html
python3 ./complejidadtextual.py $1
deactivate


