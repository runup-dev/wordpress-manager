# 소개
워드프레스 호스팅 관리 스크립트 모음입니다 

백업 / 복원 / 업데이트 스크립트로 구성되어 있습니다 

로컬 / 리모트 백업은 모두 최근 일주일치만 보관합니다 

이 정책은 일반 사용자에게 FTP접속을 허용하지 않은 경우로 권장합니다 

# 시스템 요구사항 
- WP-CLI
- DropboxUploader 

# 원격백업 프로세스
- 원격백업 권한은 SUDO 권한이 있는 유저로 제한합니다 
- 일반유저는 로컬백업이 가능하며 --remote-save 옵션을 통해 원격백업을 요청할 수 있습니다 
- SUDO 유저는 주기적으로 원격백업 폴더를 업로드하고 제거합니다 ( 백업용도가 아닌 파일은 업로드 하지 않습니다 )  

# 사용방법

1. SUDO 유저로 스크립트를 배포합니다 
<pre>
<code>
# 실행권한 부여 및 배포 
chmod 755 ./*.sh
cp ./backup.sh /usr/local/bin/wp-backup
cp ./recovery.sh /usr/local/bin/wp-recovery
cp ./update.sh /usr/local/bin/wp-update

# dropbox upload 권한 조정 및 배포 
chmod 700 ./drobox_upload.sh
cp ./dropbox_upload.sh /usr/local/bin/dropbox-upload-wpbackup
</code>
</pre>

2. SUDO 유저로 원격백업을 활성화하고, 크론탭에 등록합니다 
<pre>
<code>

# 드롭박스 업로드 ( 최초 1회 연동 ) 

# 드롭박스 API TOKEN을 연동합니다 ( 최초1회 ) 
cd ~/
dropbox_uploader

# 매시간 원격백업을 실행하는 크론탭 예제
0 * * * * dropbox-upload-wpbackup >> ./log/`date +\%Y\%m\%d`.log 2>&1
</code>
</pre>
3. 자체정책에 맞게 백업 / 업데이트를 크론탭에 등록합니다 
- 아래는 새벽 4시에 로컬 및 원격 백업을  수행하는 크론탭 예제입니다 
<pre>
<code>
0 5 * * * wp-backup --remote-save >> ./log/`date +\%Y\%m\%d`.log 2>&1
</code>
</pre>
- 아래는 새벽 7시에 업데이트를 수행하는 크론탭 예제입니다
<pre>
<code>
0 7 * * * wp-update >> ./log/`date +\%Y\%m\%d`.log 2>&1
</code>
</pre>
코어 / 테마 / 플러그인의 최신버전 유지는 워드프레스 권장사항이지만 예기치 않은 상황이 발생할 수 있습니다 미러사이트를 통해 완벽하게 테스트후 적용하시기를 권장드립니다 

4. 복원이 필요한 경우 원하는 유저로 로그인하여 아래 코드를 실행합니다
<pre>
<code>
wp-recovery
</code>
</pre>

