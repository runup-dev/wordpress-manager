#!/usr/bin/env bash
#Description : 워드프레스 코어 / 테마 / 플러그인 업데이트 
#Ref : https://guides.wp-bullet.com/automating-woocommerce-and-wordpress-updates-with-wp-cli-script/
#Author : Runup. Kim Tae Oh

echo "WP UPDATE : $(date +%H:%M:%S)"

cd /home/$USER/www/wordpress

# WP CORE UPDATE
/usr/local/bin/wp core update
/usr/local/bin/wp core update-db

# WP THEME UPDATE
/usr/local/bin/wp theme update --all

# WP PLUGIN UPDATE
/usr/local/bin/wp plugin update --all

# WC DATABASE UPDATE
is_woocommerce=$(/usr/local/bin/wp plugin list | grep woocommerce)
if [[ -n "${is_woocommerce}" ]]; then
	/usr/local/bin/wp wc update
fi 

#CACHE CLEAR
/usr/local/bin/wp cache flush
/usr/local/bin/wp rewrite flush


# 워드프레스 WP ROCKET을 사용중이라면 아래주석을 제거하세요 
# ROCKET CACHE CLEAR
#echo "ROCKET CACHE CLEAR"
# 파일생성
#echo "<?php
#// 워드 프레스를로드합니다.
#require ( 'wp-load.php');
#
#// 캐시를 지 웁니다.
#if (function_exists ( 'rocket_clean_domain')) {
#        rocket_clean_domain ();
#}
#
#// 캐시를 미리로드합니다.
#if (function_exists ( 'run_rocket_sitemap_preload')) {
#        run_rocket_sitemap_preload ();
#}" > rocket-clean-domain.php
#
#SITE=$(/usr/local/bin/wp db query "SELECT option_value FROM $(/usr/local/bin/wp db prefix)options WHERE option_name='home'" --skip-column-names)
#ROCKET_CLEAR_URL=$SITE"/rocket-clean-domain.php"
#
#파일호출
#wget -q -O $ROCKET_CLEAR_URL &>/dev/null

#파일삭제
#rm rocket-clean-domain.php
