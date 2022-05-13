#!/bin/bash
directorio=$(pwd)
seleccion=''
carpeta_nueva=''
carpeta_busqueda=''

#####FUNCIONES####


INFORMACION(){
read -p "Para crear una nueva carpeta seleccione la opcion 1, si queres buscar una carpeta opcion 2 [1-2]: " seleccion

if [ "$seleccion" == "1" ];then
	read -p "Ingrese el nombre de la nueva carpeta: " carpeta_nueva
fi

if [ "$seleccion" == "2" ];then
	read -p "Ingrese el nombre de la nueva a buscar: " carpeta_busqueda
fi
}

CREAR_CARPETA(){
	for dir in $@
		if [ -d $carpeta_nueva ];then
			echo " la carpeta $carpeta_nueva existe "
		else
			mkdir $carpeta_nueva
			if [ $? -eq 0 ];then
				echo " $carpeta_nueva se ha creado con exito"
			else
				echo "Error en creacion de carpeta"
			fi
		fi
	done



}





#case "$seleccion" in
#	"1") echo "Se creara la nueva carpeta en el direcctorio $directorio"
#	       mkdir $carpeta_nueva;;
#	"2") echo "Se buscara la carpeta en el direcctorio $directorio"
#		find -name $carpeta_busqueda;;
#esac
#echo "finalizado"
