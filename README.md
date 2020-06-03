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
- 일반유저는 로컬백업이 가능하며 --remote 옵션을 통해 원격백업을 요청할 수 있습니다 
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
- 아래는 30분 주기로 원격백업을 수행하는 크론탭 예제입니다
<pre>
<code>
</code>
</pre>
3. 자체정책에 맞게 백업 / 업데이트를 크론탭에 등록합니다 
- 아래는 새벽 4시에 백업을 수행하는 크론탭 예제입니다 
<pre>
<code>
</code>
</pre>
- 아래는 새벽 6시에 업데이트를 수행하는 크론탭 예제입니다
- 자동업데이트는 워드프레스 권장사항이지만 예기지 않은 결과를 만들 수 있습니다 미러사이트에서 완벽하게 테스트후 실행하는 것을 권장합니다 
<pre>
<code>
</code>
</pre>
4. 복원이 필요한 경우 원하는 유저로 로그인하여 아래 코드를 실행합니다 
