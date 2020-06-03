#!/usr/bin/env bash
# Source: https://guides.wp-bullet.com
# ref: https://guides.wp-bullet.com/automatically-back-wordpress-dropbox-wp-cli-bash-script/
# ref: https://guides.wp-bullet.com/restoring-managewp-backup-with-wp-cli/


echo "WP BACKUP : $(date +%H:%M:%S)"

#리모트업로드 여부 
remote_save=0
if [ "$1" = "--remote-save" ]
then
	remote_save=1
fi

#백업경로
BACKUPPATH=/home/$USER/backups

#워드프레스경로
SITESTORE=/home/$USER/www/wordpress

#날짜 프리픽스
DATEFORM=$(date +"%Y-%m-%dT%H%M")


#보관기간
DAYSKEEP=7

#보관일로부터 경과기간
DAYSKEPT=$(date +"%Y-%m-%d" -d "-$DAYSKEEP days")

#백업폴더생성
mkdir -p $BACKUPPATH

#워드프레스 설치경로로 이동
cd $SITESTORE


# 파일백업
tar -czf $BACKUPPATH/$DATEFORM.tar.gz .

# 디비백업& 압축  
/usr/local/bin/wp db export $BACKUPPATH/$DATEFORM.sql --all-tablespaces --single-transaction --quick --lock-tables=false --skip-themes --skip-plugins
cat $BACKUPPATH/$DATEFORM.sql | gzip > $BACKUPPATH/$DATEFORM.sql.gz
rm $BACKUPPATH/$DATEFORM.sql


# 파일삭제
find $BACKUPPATH -type f -name "*.gz" -mtime +$DAYSKEEP -exec rm -rf {} \;

# 권한
chmod 400 $BACKUPPATH/$DATEFORM.tar.gz
chmod 400 $BACKUPPATH/$DATEFORM.sql.gz

# REMOTE UPLOAD DIRECTORY로 이동
if [ $remote_save -eq 1 ]
then

        remote_upload_dir="/tmp/backups/$USER"
        upload_sql=$BACKUPPATH/$DATEFORM.sql.gz
        upload_sql_name=$DATEFORM.sql.gz
        upload_file=$BACKUPPATH/$DATEFORM.tar.gz
        upload_file_name=$BACKUPPATH/$DATEFORM.sql.gz

        # DIRECTORY MAKE
        mkdir -p $remote_upload_dir

        # SQL MOVE
        if [ -e $remote_upload_dir/$upload_sql_name ]; then
                rm -f $remote_upload_dir/$upload_sql_name
        fi
        cp $upload_sql $remote_upload_dir

        # FILE MOVE
        if [ -e $remote_upload_dir/$upload_file_name ]; then
                 rm -f $remote_upload_dir/$upload_file_name
        fi
        cp $upload_file $remote_upload_dir
fi
