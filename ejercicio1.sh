#!/bin/bash
#CASE para evaluar si quiere buscar o crear
#Comprobar con un while
#FOR para crear


set -o errexit  # the script ends if a command fails
set -o pipefail # the script ends if a command fails in a pipe
set -o nounset  # the script ends if it uses an undeclared variable
set -o xtrace # if you want to debug




#####VARIABLES####

FOLDER_NAME=''
NEW_FOLDER='ARGENTO'

####FUNCIONES####

CREAR_CARPETA(){
        for dir in $@
                if [ -d $NEW_FOLDER ];then
                        echo " la carpeta $NEW_FOLDER existe "
                else
                        mkdir $NEW_FOLDER
                        if [ $? -eq 0 ];then
                                echo " $NEW_FOLDER se ha creado con exito"
                        else
                                echo "Error en creacion de carpeta"
                        fi
                fi
        done



}

####MAIN####

CREAR_CARPETA



