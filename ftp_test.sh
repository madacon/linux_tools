#!/bin/bash

##### Vars #####

USER='ftpuser'
PASSWD='Global2021'
#PASSWD='Global2022'
HOST='192.168.100.250'
FILE='envia.txt'
ALERTA_1=''
ALERTA_2=''



SEND_SFTP(){
	echo "======================================================="
	sshpass -v -p $PASSWD sftp   $USER@$HOST<<EOF
	cd ftp/Reporte
	pwd
	put ./$FILE
	bye > $LOGS
EOF


}

STATUS_CHECK(){

if [ $? -eq 0 ];then
	ALERTA_1='0'
else
	ALERTA_2='1'
fi

}



##### MAIN #####

SEND_SFTP
STATUS_CHECK


echo $ALERTA_1
echo $ALERTA_2
