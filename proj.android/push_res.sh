#!/bin/sh

serials=`adb devices | grep -v List | awk '{print $1;}'`

#echo $serials
for sid in $serials
do

  adb -s $sid push ../Resources/cui /sdcard/fungame/ruitong/cui
done


