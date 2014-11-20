#!/bin/bash

APPNAME="WZDDZ"

# options

buildexternalsfromsource=

usage(){
cat << EOF
usage: $0 [options]

Build C/C++ code for $APPNAME using Android NDK

OPTIONS:
-s	Build externals from source
-h	this help
EOF
}

while getopts "sh" OPTION; do
case "$OPTION" in
s)
buildexternalsfromsource=1
;;
h)
usage
exit 0
;;
esac
done

luac=
luac_opts=
is_clean=
for param in $*
do
	if [[ $param =~ ^clean$ ]];then
		is_clean=true
	fi
	if [[ $param =~ ^luac=debug$ ]];then
		luac=1
		luac_opts="-bg"		
	fi
	if [[ $param =~ ^luac=release$ ]]; then
		luac=1
		luac_opts="-b"
	fi
  if [[ $param =~ ^DDZ_DEBUG=1$ ]]; then
    DDZ_DEBUG=1
  else
    DDZ_DEBUG=0
  fi
done


# paths

if [ -z "${NDK_ROOT+aaa}" ];then
echo "please define NDK_ROOT"
exit 1
fi

now_t=$(date +"%Y%m%d%H%M")

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
# ... use paths relative to current directory
#COCOS2DX_ROOT="$DIR/../../.."
COCOS2DX_ROOT=$QUICK_COCOS2DX_ROOT/lib/cocos2d-x

APP_ROOT="$DIR/.."
APP_ANDROID_ROOT="$DIR"

echo "NDK_ROOT = $NDK_ROOT"
echo "COCOS2DX_ROOT = $COCOS2DX_ROOT"
echo "APP_ROOT = $APP_ROOT"
echo "APP_ANDROID_ROOT = $APP_ANDROID_ROOT"

if [[ "$is_clean" ]]; then
	if [ -d "$APP_ANDROID_ROOT"/bin ]; then
	    rm -rf "$APP_ANDROID_ROOT"/bin
	fi	
	if [ -d "$APP_ANDROID_ROOT"/obj ]; then
	    rm -rf "$APP_ANDROID_ROOT"/obj
	fi
	if [ -d "$APP_ANDROID_ROOT"/libs/armeabi ]; then
	    rm -rf "$APP_ANDROID_ROOT"/libs/armeabi
	fi
	exit 0
fi

echo $now_t > $APP_ROOT/Resources/cui_ver.txt

# make sure assets is exist
if [ -d "$APP_ANDROID_ROOT"/assets ]; then
    rm -rf "$APP_ANDROID_ROOT"/assets
fi
mkdir "$APP_ANDROID_ROOT"/assets
mkdir "$APP_ANDROID_ROOT"/assets/zipres
cp "$APP_ROOT"/framework_precompiled.zip "$APP_ANDROID_ROOT"/assets/zipres/
cp $APP_ROOT/Resources/cui_ver.txt "$APP_ANDROID_ROOT"/assets

if [[ $DDZ_DEBUG -ne "1" ]]; then
  echo "DDZ_DEBUG ===> false "
  source "$QUICK_COCOS2DX_ROOT"/bin/compile_scripts.sh -i "$APP_ROOT"/Resources -o "$APP_ANDROID_ROOT"/assets/zipres/slogic.dat -ek hahaleddz -es hahaleddz -q
  source "$QUICK_COCOS2DX_ROOT"/bin/pack_files.sh -i "$APP_ROOT"/Resources/cui -o "$APP_ANDROID_ROOT"/assets/zipres/cui.dat -m zip -q
  source "$QUICK_COCOS2DX_ROOT"/bin/pack_files.sh -i "$APP_ROOT"/Resources/res -o "$APP_ANDROID_ROOT"/assets/zipres/res.dat -m zip -q

  cd "$APP_ROOT"/Resources/cui
  rm -rf .DS_Store
  zip -rq -P hahaled "$APP_ANDROID_ROOT"/assets/zipres/cui.dat .
  cd "$APP_ROOT"/Resources/res
  rm -rf .DS_Store
  zip -rq -P hahaled "$APP_ANDROID_ROOT"/assets/zipres/res.dat .
  cd "$APP_ANDROID_ROOT"  
fi

find "$APP_ROOT"/Resources/ -name *.tmp -exec rm {} \;


# copy icons (if they exist)
file="$APP_ANDROID_ROOT"/assets/Icon-72.png
if [ -f "$file" ]; then
	cp "$file" "$APP_ANDROID_ROOT"/res/drawable-hdpi/icon.png
fi
file="$APP_ANDROID_ROOT"/assets/Icon-48.png
if [ -f "$file" ]; then
	cp "$file" "$APP_ANDROID_ROOT"/res/drawable-mdpi/icon.png
fi
file="$APP_ANDROID_ROOT"/assets/Icon-32.png
if [ -f "$file" ]; then
	cp "$file" "$APP_ANDROID_ROOT"/res/drawable-ldpi/icon.png
fi

   
cp ../sdklibs/umeng/umeng_sdk.jar libs
cp ../sdklibs/umeng/cocos2dx2_libMobClickCpp.a libs



if [[ "$buildexternalsfromsource" ]]; then
    echo "Building external dependencies from source"
    "$NDK_ROOT"/ndk-build -C "$APP_ANDROID_ROOT" $* \
        "NDK_MODULE_PATH=${COCOS2DX_ROOT}:${COCOS2DX_ROOT}/cocos2dx/platform/third_party/android/source"
else
    echo "Using prebuilt externals"
    "$NDK_ROOT"/ndk-build -j8 -C "$APP_ANDROID_ROOT" $* \
        "NDK_MODULE_PATH=${QUICK_COCOS2DX_ROOT}:${COCOS2DX_ROOT}:${COCOS2DX_ROOT}/cocos2dx/platform/third_party/android/prebuilt"
fi

if [ ! -d libs ]; then
    mkdir -p libs/armeabi
fi
