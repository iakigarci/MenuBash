#!/bin/bash
DIRVIRPYHTON='/var/www/html/python3envmetrix'
source $DIRVIRPYHTON/bin/activate
cd /var/www/html
python3 ./complejidadtextual.py $1
deactivate


