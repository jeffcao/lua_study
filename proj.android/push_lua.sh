#!/bin/sh

serials=`adb devices | grep -v List | awk '{print $1;}'`

#echo "pkg => " $1

#zip -r lua.zip luaScripts/*

#echo $serials
for sid in $serials
do

  adb -s $sid push ../Resources/ /sdcard/fungame/ruitong
done


