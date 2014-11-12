#!/bin/bash

PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin:~/bin
export PATH

now_day=$(date +%Y%m%d)

g_h_work_path=/data/local/game/ddz_server
g_h_code_source_path=/home/doudizhu/$now_day'.tar.gz'
g_h_code_path=$g_h_work_path/$now_day
g_h_tar_pkg_name=$g_h_code_path'.tar.gz'
g_h_old_code_path=/data/local/game/deploy/source_code
g_h_new_deploy_path=/data/local/game/deploy_new
g_h_old_deploy_path=/data/local/game/deploy
g_h_game_config=$g_h_code_path/model_module/lib/game_config.rb

echo 'copy source code package to ddz_server'
rm -f $g_h_tar_pkg_name
cp $g_h_code_source_path $g_h_work_path/

# echo 'chown doudizhu to source code package'
# sudo chown doudizhu.doudizhu $g_h_tar_pkg_name

cd $g_h_work_path

# echo 'changed to doudizhu user'
# su doudizhu

echo 'unpackage source code package'
rm -rf $g_h_code_path
tar -xzvf $g_h_tar_pkg_name 

echo 'copy config file to new deploy'
cp -r $g_h_old_code_path/config $g_h_code_path/

echo 'modify to product env in game config'
sed -i 's/SERVER_RUN_EVN = \"dev\"/SERVER_RUN_EVN = \"prod\"/g' $g_h_game_config 

echo 'cd deploy_new'
cd $g_h_new_deploy_path

echo 'create link for new server'
rm -rf $g_h_new_deploy_path/*
ln -s $g_h_code_path/charge_server charge_server
ln -s $g_h_code_path/config config
ln -s $g_h_code_path/game_server ddz_game_server
ln -s $g_h_code_path/hall_server ddz_hall_server
ln -s $g_h_code_path/login_server login_server
ln -s $g_h_code_path/sms_simulator mock_sim_server
ln -s $g_h_code_path/game_utility game_job
ln -s $g_h_code_path/game_push_message message_server
ln -s $g_h_code_path source_code


ln -s ../source/20141111001/admin_server admin
ln -s ../source/20141111001/charge_server charge_server
ln -s ../source/20141111001/config config
ln -s ../source/20141111001/game_utility game_job
ln -s ../source/20141111001/hall_server hall_server
ln -s ../source/20141111001/game_server game_server
ln -s ../source/20141111001/login_server login_server
ln -s ../source/20141111001/game_push_message message_server
ln -s ../source/20141111001/sms_simulator mock_server
ln -s ../source/20141111001/model_module model
ln -s ../source/20141111001/god god


echo 'copy startup.sh and shutdown.sh to new code path'
cp $g_h_old_deploy_path/charge_server/dev-startup.sh charge_server/
cp $g_h_old_deploy_path/charge_server/shutdown.sh charge_server/

cp $g_h_old_deploy_path/ddz_game_server/dev-startup.sh ddz_game_server/
cp $g_h_old_deploy_path/ddz_game_server/shutdown.sh ddz_game_server/

cp $g_h_old_deploy_path/ddz_hall_server/dev-startup.sh ddz_hall_server/
cp $g_h_old_deploy_path/ddz_hall_server/shutdown.sh ddz_hall_server/

cp $g_h_old_deploy_path/login_server/dev-startup.sh login_server/
cp $g_h_old_deploy_path/login_server/shutdown.sh login_server/

cp $g_h_old_deploy_path/mock_sim_server/dev-startup.sh mock_sim_server/
cp $g_h_old_deploy_path/mock_sim_server/shutdown.sh mock_sim_server/

cp $g_h_old_deploy_path/message_server/dev-startup.sh message_server/
cp $g_h_old_deploy_path/message_server/shutdown.sh message_server/



















