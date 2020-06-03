#!/usr/bin/env bash


echo "1 : sql";
echo "2 : file";

read -p 'Input Recover Type: ' type

BACKUPPATH=/home/$USER/backups
cnt=0
case $type in
	"1") 
		# 복구파일 리스트를 배열화 
		for f in $(find ${BACKUPPATH} -type f | grep "sql.gz" | sort -n)
		do
			file_list[$cnt]=$f
                        echo $(($cnt+1)) : ${file_list[cnt]}
                        let cnt++;
		done
		
		# 복구파일 리스트를 보여주고 입력받는다 
		read -p 'Input Recovery File Number : ' file_index
                source=${file_list[$(($file_index-1))]}
	
		# 소스파일이 없으면 exit
                if [ -z $source ]
               	then 
                	echo "source is non exists"
                        exit 
                fi 
		
		# 소스/타겟 파일을 반환
		file="$(basename -- $source)"

		# 복구방식
                echo "1 : only sql copy"
                echo "2 : import"
                read -p 'Input Recovery Type : ' recovery_type
		
		# wordpress 루트에 파일 복원후 IMPORT 
		target="/home/$USER/www/wordpress"

		# 파일복사 > 압축해제 > IMPORT
                cp $source $target/$file
           	cd $target
		gzip -d $file
		
		if [ ${recovery_type} -eq 2 ]
		then
			# 복원 
	                wp db import ${file/.gz/}

	                # 파일삭제
			rm ${file/.gz/}
		fi

	;;

	"2") 
		# 복구파일 리스트를 배열화
                for f in $(find ${BACKUPPATH} -type f | grep "tar.gz" | sort -n)
                do
                        file_list[$cnt]=$f
                        echo $(($cnt+1)) : ${file_list[cnt]}
                        let cnt++;
                done

                # 복구파일 리스트를 보여주고 입력받는다
                read -p 'Input Recovery File Number : ' file_index
                source=${file_list[$(($file_index-1))]}

                # 소스파일이 없으면 exit
                if [ -z $source ]
                then    
                        echo "source is non exists" 
                        exit    
                fi

		# 복구방식
		echo "1 : backups/tmp 디렉토리에 복원"
		echo "2 : 프로덕션에 덮어쓰기"
		echo "3 : 프로덕션 모두 제거하고 덮어쓰기"	
		read -p '복구타입을 선택하세요 : ' recovery_type
		
		case $recovery_type in
			"1")
				# backups/tmp 디렉토리에 파일 복원 
				if [ ! -d "${BACKUPPATH}/tmp" ];then
					mkdir ${BACKUPPATH}/tmp
				fi
				rm -rf ${BACKUPPATH}/tmp/*
				target="${BACKUPPATH}/tmp"
				tar -xvzf $source -C $target
			;;

			"2")
				# 워드프레스 설치 경로에 덮어쓰기
				target="/home/$USER/www/wordpress"
				tar -xvzf $source -C $target
			;;

			"3")
				# 워드프레스 설치 경로의 모든파일제거하고 복원
				target="/home/$USER/www/wordpress"
				rm -rf $target/*
				tar -xvzf $source -C $target
			;;
		esac
	;;
esac	
