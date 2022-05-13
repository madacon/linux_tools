#!/bin/bash

### VARS ###

USER='ftpuser'
PASSWD='Global2021'
#PASSWD='Global2022'
HOST='192.168.0.59'
FILE='test.txt'
DATENOW=$(date "+%d/%m/%Y %H:%M:%S")
LOGS='./logs/proceso.log'
#DATECOPY=$(head -16 ./logs/proceso.log | tail -2 | awk -F " " '{ print $9 " "  $10 }')
#DATECREATE=$(head -2 ./logs/proceso.log | awk -F " " '{ print $9 " "  $10 }')
CK_REMOTE_FILE=''
CK_LOCAL_FILE=''
ESTADO=''

### FUNCIONES ###

CHECK_FILE(){
	if [ -f "$FILE" ];then
		#echo "Creado a las $DATENOW"
		ESTADO=0
	else
		#echo "No se encuentra el archivo"

		ESTADO=1
	fi
	
	echo "$ESTADO"
}



SEND_SFTP(){
	echo "======================================================="
	CK_LOCAL_FILE=$(cksum $FILE)
	sshpass -v -p $PASSWD sftp   $USER@$HOST<<EOF
	cd ftp/Reporte
	pwd
	put ./$FILE
	bye > $LOGS
EOF

if [ $? -eq 0 ];then
	echo "Enviado a las $DATENOW"
else
	echo "Error en copia de archivo"
fi

}

REMOTE_CHECK(){
	echo "======================================================="
	CK_REMOTE_FILE=$(cksum $FILE)
	sshpass -p $PASSWD sftp -v $USER@$HOST<<EOF
	cd ftp/Reporte
	ls $FILE
	bye
EOF
	echo "$CK_LOCAL_FILE"
	echo "$CK_REMOTE_FILE"

	if [[ "$CK_LOCAL_FILE" == "$CK_REMOTE_FILE" ]];then
                  echo "EL ARCHIVO DESTINO ES IGUAL AL ORIGEN"
                  else
                  echo "EL ARCHIVO DESTINO NO ES IGUAL AL ORIGEN"
                  exit 1
          fi


}


#notify_zabbix () {

#zabbix_sender -c /etc/zabbix/zabbix_agentd.conf -s "$HOSt" -k $2 -o $1 >/dev/null 2>&1

#}





PROCESO(){
	CHECK_FILE
#	notify_zabbix
	SEND_SFTP
#	notify_zabbix
	REMOTE_CHECK
}


### MAIN ###

echo "$ESTADO"

PROCESO > $LOGS 2>&1



