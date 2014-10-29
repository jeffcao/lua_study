#!/bin/sh

serials=`adb devices | grep -v List | awk '{print $1;}'`

pkg="cn.com.m123.TMS"
apk="runtime/android/TMS-debug.apk"

#echo "pkg => " $1

#zip -r lua.zip luaScripts/*

#echo $serials
for sid in $serials
do
  #echo "adb -s $sid uninstall $pkg"
  #adb -s $sid push luaScripts/ /sdcard/fungame/DDZ/lua
  #adb -s $sid push lua.zip /sdcard/tblin/TMS/
  #adb -s $sid shell "cd /sdcard/tblin/TMS ; busybox unzip -o lua.zip"
  adb -s $sid push ../Resources/ /sdcard/fungame/tuitong
done


