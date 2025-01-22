#!/bin/sh

#  ci_post_clone.sh
#  Harubee
#
#  Created by 이정동 on 1/22/25.
#

# GoogleService-Info.plist 파일 생성
echo "환경변수 참조 GoogleService-Info.plist file 생성시작"

# Boolean 값 변환
convert_bool() {
    if [ "$1" == "true" ]; then
        echo "<true/>"
    else
        echo "<false/>"
    fi
}

cat <<EOF > "/Volumes/workspace/repository/Harubee/Resources/GooglePlists/GoogleService-Info.plist"
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>API_KEY</key>
    <string>$(API_KEY)</string>
    <key>GCM_SENDER_ID</key>
    <string>$(GCM_SENDER_ID)</string>
    <key>PLIST_VERSION</key>
    <string>$(PLIST_VERSION)</string>
    <key>BUNDLE_ID</key>
    <string>$(BUNDLE_ID)</string>
    <key>PROJECT_ID</key>
    <string>$(PROJECT_ID)</string>
    <key>STORAGE_BUCKET</key>
    <string>$(STORAGE_BUCKET)</string>
    <key>IS_ADS_ENABLED</key>
    `convert_bool ${IS_ADS_ENABLED}`
    <key>IS_ANALYTICS_ENABLED</key>
    `convert_bool ${IS_ANALYTICS_ENABLED}`
    <key>IS_APPINVITE_ENABLED</key>
    `convert_bool ${IS_APPINVITE_ENABLED}`
    <key>IS_GCM_ENABLED</key>
    `convert_bool ${IS_GCM_ENABLED}`
    <key>IS_SIGNIN_ENABLED</key>
    `convert_bool ${IS_SIGNIN_ENABLED}`
    <key>GOOGLE_APP_ID</key>
    <string>$(GOOGLE_APP_ID)</string>
</dict>
</plist>
EOF
echo "환경변수 참조 GoogleService-Info.plist file 생성완료"
