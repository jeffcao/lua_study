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
for param in $*
do
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
COCOS2DX_ROOT="$DIR/../.."
APP_ROOT="$DIR/.."
APP_ANDROID_ROOT="$DIR"

echo "NDK_ROOT = $NDK_ROOT"
echo "COCOS2DX_ROOT = $COCOS2DX_ROOT"
echo "APP_ROOT = $APP_ROOT"
echo "APP_ANDROID_ROOT = $APP_ANDROID_ROOT"

# make sure assets is exist
if [ -d "$APP_ANDROID_ROOT"/assets ]; then
    rm -rf "$APP_ANDROID_ROOT"/assets
fi

mkdir "$APP_ANDROID_ROOT"/assets

# copy resources
for file in "$APP_ROOT"/Resources/*
do
if [ -d "$file" ]; then
    cp -rf "$file" "$APP_ANDROID_ROOT"/assets
fi

if [ -f "$file" ]; then
    cp "$file" "$APP_ANDROID_ROOT"/assets
fi
done

if [[ "$luac" ]]; then
	if [[ -z "$LUA_COMPILER" ]]; then
		echo "ERROR: please define LUA_COMPILER for compiling lua script"
		exit 1
	fi
	
	current_path=`pwd`
	cd "$APP_ANDROID_ROOT/assets"
	
	for lua_src_file in `find "$APP_ROOT/Resources" -iname "*.lua"`
	do
		lua_file=`echo "$lua_src_file" | sed 's/\(.*\/Resources\)\/\(.*\)$/\2/'`
		lua_obj_file=`echo "$lua_file" | sed 's/\(.*\).lua/\1/'`
		lua_obj_file=${lua_obj_file}.lo
		lua_dst_file="$APP_ANDROID_ROOT/assets/$lua_file"
		if [[ $lua_file =~ ^main\.lua$ ]]; then
			echo "got main.lua"
			cp $lua_src_file $lua_dst_file
		else
			# echo "compiling: $LUA_COMPILER $luac_opts $lua_file $lua_obj_file"	
			$LUA_COMPILER $luac_opts "$lua_file" "$lua_obj_file"
			rm $lua_file
		fi
	done
	cd $current_path
fi

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
    "$NDK_ROOT"/ndk-build -C "$APP_ANDROID_ROOT" $* \
        "NDK_MODULE_PATH=${COCOS2DX_ROOT}:${COCOS2DX_ROOT}/cocos2dx/platform/third_party/android/prebuilt"
fi

cp ../cmcc/libmegjb.so libs/armeabi
cp ../anzhi/anzhi_sdk_pay.jar libs
