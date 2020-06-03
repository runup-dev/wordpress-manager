#!/usr/bin/env bash
#dropboxUpload
#author : runup. Kim Tae Oh
#ref : https://guides.wp-bullet.com/automatically-back-wordpress-dropbox-wp-cli-bash-script/

echo "DROPBOX UPLOAD : $(date +%H:%M:%S)"

BACKUPPATH=/tmp/backups

mkdir -p $BACKUPPATH
sudo chown $USER:wheel $BACKUPPATH
sudo chmod 1777 $BACKUPPATH


#Days to retain
DAYSKEEP=7
DAYSKEPT=$(date +"%Y-%m-%d" -d "-$DAYSKEEP days")



#Get Upload List
SITELIST=($(ls -d $BACKUPPATH/* | awk -F '/' '{print $NF}'))

#start the loop
for SITE in ${SITELIST[@]}; do
	
	#remove old file via remote 
	REMOTELIST=($(dropbox_uploader list /$SITE | awk -F ' ' '{print $NF}' | grep '.gz')) 
	for REMOTE_FILE in ${REMOTELIST[@]}; do
	        REMOTE_FILE_DATE=${REMOTE_FILE:0:10}

        	remote_val=$(date -d $REMOTE_FILE_DATE +%s)
	        condition_val=$(date -d $DAYSKEPT +%s)

        	if [ $remote_val -lt $condition_val ] 
	        then    
                	/usr/bin/dropbox_uploader delete /$SITE/$REMOTE_FILE
        	fi      
	done
	
	# file upload 
	FILELIST=($(ls -d $BACKUPPATH/$SITE/* | awk -F '/' '{print $NF}'))
        for LOCAL_FILE in ${FILELIST[@]}; do
		if [ -e $BACKUPPATH/$SITE/$LOCAL_FILE -a ${BACKUPPATH:0:12} = '/tmp/backups' ]
		then
			sudo /usr/bin/dropbox_uploader upload $BACKUPPATH/$SITE/$LOCAL_FILE /$SITE/
			sudo rm -f $BACKUPPATH/$SITE/$LOCAL_FILE
		fi
	done
done
