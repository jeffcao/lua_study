#!/bin/bash

APPNAME="DouDiZhu_Lua"

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
done


# paths

if [ -z "${NDK_ROOT+aaa}" ];then
echo "please define NDK_ROOT"
exit 1
fi

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

# make sure assets is exist
if [ -d "$APP_ANDROID_ROOT"/assets_bak ]; then
    rm -rf "$APP_ANDROID_ROOT"/assets_bak
fi
mkdir "$APP_ANDROID_ROOT"/assets_bak
cp -rf "$APP_ANDROID_ROOT"/assets/zipres "$APP_ANDROID_ROOT"/assets_bak/
cp -rf "$APP_ANDROID_ROOT"/assets/cui "$APP_ANDROID_ROOT"/assets_bak/

if [ -d "$APP_ANDROID_ROOT"/assets ]; then
    rm -rf "$APP_ANDROID_ROOT"/assets
fi

mkdir "$APP_ANDROID_ROOT"/assets

cp -rf "$APP_ANDROID_ROOT"/assets_bak/* "$APP_ANDROID_ROOT"/assets/

rm -rf "$APP_ANDROID_ROOT"/assets_bak

# copy resources
s_file="$APP_ROOT"/Resources/ZYF_ChannelID
cp -rf "$s_file" "$APP_ANDROID_ROOT"/assets/
# s_file="$APP_ROOT"/Resources/cui
# cp -rf "$s_file" "$APP_ANDROID_ROOT"/assets/
s_file="$APP_ROOT"/Resources/OpeningAnimation
cp -rf "$s_file" "$APP_ANDROID_ROOT"/assets/
s_file="$APP_ROOT"/Resources/res
cp -rf "$s_file" "$APP_ANDROID_ROOT"/assets/


# if [[ "$luac" ]]; then
# 	if [[ -z "$LUA_COMPILER" ]]; then
# 		echo "ERROR: please define LUA_COMPILER for compiling lua script"
# 		exit 1
# 	fi
	
# 	current_path=`pwd`
# 	cd "$APP_ANDROID_ROOT/assets"
	
# 	for lua_src_file in `find "$APP_ROOT/Resources" -iname "*.lua"`
# 	do
# 		lua_file=`echo "$lua_src_file" | sed 's/\(.*\/Resources\)\/\(.*\)$/\2/'`
# 		lua_obj_file=`echo "$lua_file" | sed 's/\(.*\).lua/\1/'`
# 		lua_obj_file=${lua_obj_file}.lo
# 		lua_dst_file="$APP_ANDROID_ROOT/assets/$lua_file"
# 		if [[ $lua_file =~ ^main\.lua$ ]]; then
# 			echo "got main.lua"
# 			cp $lua_src_file $lua_dst_file
# 		else
# 			# echo "compiling: $LUA_COMPILER $luac_opts $lua_file $lua_obj_file"	
# 			$LUA_COMPILER $luac_opts "$lua_file" "$lua_obj_file"
# 			rm $lua_file
# 		fi
# 	done
# 	cd $current_path
# fi

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
   
# cp ../sdklibs/cmcc/libmegjb.so libs/armeabi
# cp ../sdklibs/anzhi/anzhi_sdk_pay.jar libs
# cp ../sdklibs/leyifu/libbsjni.so libs/armeabi
# cp ../sdklibs/leyifu/astep.jar libs
# cp ../sdklibs/leyifu/huafubao_sdk.jar libs
# cp ../sdklibs/weipai/wpay-sdk4.7.jar libs
# cp ../sdklibs/umeng/umeng_sdk.jar libs
# cp ../sdklibs/umeng/cocos2dx2_libMobClickCpp.a libs
# cp ../miliSDKV1.14/android-support-v4.jar libs
# cp ../miliSDKV1.14/jsoup-1.7.2.jar libs
# cp ../miliSDKV1.14/milipay_sms.jar libs
# cp ../letuSDK/lyhtghPayJar.jar libs
# cd ..
# ruby pkg.rb