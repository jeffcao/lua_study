strings_general = {
	g_nick_name_nil_w = '昵称不能为空',
	g_email_err_w  = '请输入正确的邮箱地址',
	g_connect_server_ing = '连接服务器...',
	g_pswd_format_w = '密码不能小于8位',
}
strings = {
--AvatarListLayer
update_avatar_ing = '更新头像...',

--FeedbackScene
feedback_nil_w = '反馈信息不能为空',
feedback_ing = '保存反馈信息',
feedback_s = '反馈成功',

--ForgetPasswordScene
forget_pswd_id_nil_w = '帐号不能为空',
forget_pswd_email_nil_w = '邮箱地址不能为空',
forget_pswd_email_err_w = strings_general.g_email_err_w,
forget_pswd_submit_ing = '提交取回密码信息...',
forget_pswd_find_s = '提交信息成功, 请注意查收邮件.',
forget_pswd_find_w = '取回密码失败, 请检查您输入的帐号与绑定邮箱是否正确.',

--InfoLayer
update_gender_ing = '更改性别...',
nick_name_nil_w = strings_general.g_nick_name_nil_w,
update_nick_name_ing = '更改昵称...',
update_w = '更改失败',

--InitPlayerInfoLayer
ii_nick_name_nil_w = strings_general.g_nick_name_nil_w,
ii_pswd_nil_w = '密码不能为空',
ii_pswd_format_w = strings_general.g_pswd_format_w,
ii_email_nil_w = '邮箱地址不能为空，否则在您忘记密码时无法从系统获得密码.',
ii_email_format_w = strings_general.g_email_err_w,
ii_update_info_ing = '更新资料...',
ii_update_info_w = '更新资料失败',
ii_update_info_s = '更新资料成功',

--LandingScene
ls_connect_server_ing = strings_general.g_connect_server_ing,
ls_load_data_ing = '加载数据...',
ls_login_w = '登录失败',
ls_connect_hall_w = '连接大厅服务器失败',
ls_connect_server_w = '连接服务器失败',

--LoginScene
lgs_login_server_ing = '登录服务器...',

--RegisterScene
rs_connect_server_ing = strings_general.g_connect_server_ing,

--UpdatePasswordLayer
upl_input_old_pswd_t = '请输入旧密码',
upl_input_new_pswd_t = '请输入新密码',
upl_pswd_format_w = strings_general.g_pswd_format_w,
upl_pswd_not_same_w = '两次输入的新密码不一致',
upl_update_pswd_ing = '更改密码...',
upl_update_pswd_s = '更改密码成功',

--ConnectivityPlugin
cp_network_w = '网络连接已断开，请设置网络！',

--GUIUpdatePlugin
gup_mand_exit = '强制退出',
gup_mand_eixt_w = '您正在游戏中，此时强退系统将最大输赢扣除您的豆子。',

--HallGameConnectionPlugin
hgcp_check_connection_w = '与游戏服务器连接认证失败',
hgcp_enter_room_ing = '进入房间...',

--HallSceneUPlugin
hsp_connect_hall_ing = '连接大厅服务器...',
hsp_get_room_info_ing = '请求房间信息...',
hsp_connect_game_server_w = '连接游戏服务器失败.'

--HallServerConnectionPlugin
hscp_check_connection_w = '与服务器连接认证失败',
hscp_get_rooms_w = '获取房间列表失败',
hscp_get_today_activity_w = '获取今日活动失败',
}

