#!/bin/bash

PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin:~/bin
export PATH

work_path=/Users/jeffcao/workspace
code_path=$work_path/doudizhu
deploy_script_path=$code_path/game_utility/admin_tools/deploy_ddz_r.sh
now_day=$(date +%Y%m%d)
dest_path=$work_path/$now_day
tar_pkg_name=$now_day'.tar.gz' 

echo $dest_path
echo $deploy_script_path

echo 'copy source code to naother path'
rm -rf $dest_path
cp -R $code_path $dest_path

echo 'delete useless files'
cd $dest_path
find . -type d  -name '.idea' -exec rm -rf {} \; 
find . -type d  -name '.git'  -exec rm -rf {} \; 
find . -type d  -name '.metadata'  -exec rm -rf {} \;

find . -type f  -name '*.log' -exec rm -f {} \; 

cd $work_path

echo 'create tar package'
rm -f $tar_pkg_name 
tar -czvf $tar_pkg_name $now_day

echo 'use scp to copy source code package to game host'
scp $tar_pkg_name rtddz@gamehost:/home/rtddz/
scp $deploy_script_path rtddz@gamehost:/home/rtddz/

echo 'ssh to game host'
ssh rtddz@gamehost












