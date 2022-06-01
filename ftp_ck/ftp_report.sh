#!/bin/bash

### VARS ###

USER='ftpuser'
#PASSWD='Global2021'
PASSWD='Global2022'
HOST='192.168.0.8'
FILE='test.txt'
DATENOW=$(date "+%d/%m/%Y %H:%M:%S")
LOGS='./logs/proceso.log'
#DATECOPY=$(head -16 ./logs/proceso.log | tail -2 | awk -F " " '{ print $9 " "  $10 }')
#DATECREATE=$(head -2 ./logs/proceso.log | awk -F " " '{ print $9 " "  $10 }')
CK_REMOTE_FILE=''
CK_LOCAL_FILE=''
#NO_ENVIADO=$(zabbix_sender -z $HOST -s 'COPIA_REPORTE' -k application.status -o 'NO_ENVIADO')
#ENVIADO=$(zabbix_sender -z $HOST -s 'COPIA_REPORTE' -k application.status -o 'ENVIADO')
#CREADO=$(zabbix_sender -z $HOST -s 'REPORTE' -k application.status -o 'CREADO')
#NO_CREADO=$(zabbix_sender -z $HOST -s 'REPORTE' -k application.status -o 'NO_CREADO')



### FUNCIONES ###

CHECK_FILE(){
	if [ -f "$FILE" ];then
		zabbix_sender -z $HOST -s 'REPORTE' -k application.status -o 'CREADO'		
	else		
		zabbix_sender -z $HOST -s 'REPORTE' -k application.status -o 'NO_CREADO'
	fi
}



SEND_SFTP(){
	echo "======================================================="
	CK_LOCAL_FILE=$(cksum $FILE)
	sshpass -v -p $PASSWD sftp   $USER@$HOST<<EOF
	cd /home/ftpuser/Reporte
	pwd
	put ./$FILE
	bye > $LOGS
EOF

if [ $? -eq 0 ];then
	zabbix_sender -z $HOST -s 'COPIA_REPORTE' -k application.status -o 'ENVIADO'
else
	zabbix_sender -z $HOST -s 'COPIA_REPORTE' -k application.status -o 'NO_ENVIADO'
fi

}

REMOTE_CHECK(){
	echo "======================================================="
	CK_REMOTE_FILE=$(cksum $FILE)
	sshpass -p $PASSWD sftp -v $USER@$HOST<<EOF
	cd /home/ftpuser/Reporte
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

#STATUS_CHECK(){
#zabbix_sender -z 192.168.0.8 -s 'Custom Application' -k application.status -o 'vamooo'

#if [ $? -eq 0 ];then
#	ALERTA_1='$(zabbix_sender -c /etc/zabbix/zabbix_agentd.conf -s "$HOSt" -k $2 -o $1 >/dev/null 2>&1)'
#else
#	ALERTA_2='1'
#fi

#}


#notify_zabbix () {

#zabbix_sender -c /etc/zabbix/zabbix_agentd.conf -s "$HOSt" -k $2 -o $1 >/dev/null 2>&1

#}





PROCESO(){
	CHECK_FILE
	SEND_SFTP
#	REMOTE_CHECK
}


### MAIN ###


PROCESO > $LOGS 2>&1



