#!/bin/bash

#nota: per il backup si prega di creare un utente apposito che abbia solo i seguenti permessi: LOCK TABLES e SELECT

PATH=/bin:/usr/bin:/usr/local/bin:/usr/sbin:/usr/local/sbin

USER=backup_db
PASS=
# non mettere lo slash finale!
DIR=/root/dest

/bin/mv ${DIR}/*.tar.bz2 ${DIR}/old/

echo "show databases;" | mysql -u $USER -p$PASS | while read db; do
        echo $(date "+%Y-%m-%d")"--inizio dump ${db}" >> /root/backup_db.log

        cd ${DIR}/old
	#teniamo 10 copie di ciascun db
	/bin/ls -t *_${db}.tar.bz2 | tail -n +10 | while read line; do 
        	echo $(date "+%Y-%m-%d")"  cancellato vecchio backup ${line}" >> /root/backup_db.log
		rm -f $line; 
	done


        cd ${DIR}

        mysqldump --add-locks -u $USER -p$PASS $db > $DIR/${db}.sql
        mysqldump --add-locks -ct -u $USER -p$PASS $db > $DIR/${db}_solo_dati.sql
        mysqldump --add-locks -d -u $USER -p$PASS $db > $DIR/${db}_struttura.sql

        
        tar cfj $(date "+%Y-%m-%d")_${db}.tar.bz2 $DIR/${db}.sql $DIR/${db}_solo_dati.sql $DIR/${db}_struttura.sql

        /bin/rm -f $DIR/${db}.sql $DIR/${db}_solo_dati.sql $DIR/${db}_struttura.sql

        echo $(date "+%Y-%m-%d")"++fine dump ${db}" >> /root/backup_db.log
done

