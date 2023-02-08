#!/bin/bash

FOLDER='/home/mconceicao/Downloads/Compucalitv'
PASSWORD='www.compucalitv.com'

for file in $FOLDER/*.rar; do
  unrar x -p$PASSWORD $file

  if [ $? -eq 0 ]; then
    rm *.rar
    echo "Se descomprimio el archivo $file correctamente y se borraron los archivos .rar"
  else
    echo "Error al descomprimir"
  fi
done
