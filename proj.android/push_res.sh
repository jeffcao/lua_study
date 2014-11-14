#!/bin/sh

serials=`adb devices | grep -v List | awk '{print $1;}'`

#echo $serials
for sid in $serials
do
  #echo "adb -s $sid uninstall $pkg"
  #adb -s $sid push luaScripts/ /sdcard/fungame/DDZ/lua
  #adb -s $sid push lua.zip /sdcard/tblin/TMS/
  #adb -s $sid shell "cd /sdcard/tblin/TMS ; busybox unzip -o lua.zip"
  adb -s $sid push ../Resources/cui /sdcard/fungame/ruitong/cui
done


