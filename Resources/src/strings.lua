strings_general = {
	g_nick_name_nil_w = '昵称不能为空',
	g_email_err_w  = '请输入正确的邮箱地址',
	g_connect_server_ing = '连接服务器...',
	g_pswd_format_w = '密码不能小于8位',
	g_connect_server_w = '连接服务器失败',
	g_login_w = '登录失败',
	g_connect_hall_w = '连接大厅服务器失败',
	g_pswd_nil_w = '密码不能为空',
	g_register_ing = '注册用户...',
	g_connect_hall_ing = '连接大厅服务器...',
	g_zaixianyouli = '在线有礼：您已在线满minutes分钟，获得了beans个豆子',
	
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
ii_pswd_nil_w = strings_general.g_pswd_nil_w,
ii_pswd_format_w = strings_general.g_pswd_format_w,
ii_email_nil_w = '邮箱地址不能为空，否则在您忘记密码时无法从系统获得密码.',
ii_email_format_w = strings_general.g_email_err_w,
ii_update_info_ing = '更新资料...',
ii_update_info_w = '更新资料失败',
ii_update_info_s = '更新资料成功',

--LandingScene
ls_connect_server_ing = strings_general.g_connect_server_ing,
ls_load_data_ing = '加载数据...',
ls_login_w = strings_general.g_login_w,
ls_connect_hall_w = strings_general.g_connect_hall_w,
ls_connect_server_w = strings_general.g_connect_server_w,

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
hsp_connect_hall_ing = strings_general.g_connect_hall_ing,
hsp_get_room_info_ing = '请求房间信息...',
hsp_connect_game_server_w = '连接游戏服务器失败.',

--HallServerConnectionPlugin
hscp_check_connection_w = '与服务器连接认证失败',
hscp_get_rooms_w = '获取房间列表失败',
hscp_get_today_activity_w = '获取今日活动失败',
hscp_zaixianyouli = strings_general.g_zaixianyouli,--'在线有礼：您已在线满minutes分钟，获得了beans个豆子',
hscp_get_player_info_w = '获取玩家信息失败',
hscp_update_pswd_w = '更改密码失败',
hscp_request_room_w = '请求房间失败',
hscp_get_vip_salary_w = '领取工资失败',
hscp_feedback_w = '保存反馈信息失败',
hscp_get_props_list_w = '获取商品列表失败',
hscp_purchase_prop_w = '购买道具失败',
hscp_get_my_props_list_w = '获取道具列表失败',
hscp_use_prop_w = '使用道具失败',
hscp_restore_connection_ing = '正在恢复与服务器的连接，请稍候.',
hscp_restore_connection_w = '恢复与服务器连接失败.',

--LoginHallConnectionPlugin
lhcp_check_hall_connection_w = '与大厅服务器连接认证失败',
lhcp_enter_hall_ing = '进入大厅...',

--LoginSceneUIPlugin
lsp_register_ing = strings_general.g_register_ing,
lsp_login_id_pswd_format_w = '请输入正确的账号，密码信息',
lsp_connect_hall_ing = '登录大厅服务器...',
lsp_login_w = strings_general.g_login_w,
lsp_connect_server_w = strings_general.g_connect_server_w,
lsp_connect_hall_server_w = strings_general.g_connect_hall_w,

--MarketSceneUPlugin
msp_purchase_no_code_w = '此道具无消息代码，无法完成购买.',
msp_purchase_not_cmcc_w = '尊敬的客户，非中国移动客户暂不支持购买道具.',
msp_purchase_notify = '尊敬的客户，您即将购买的是\n游戏名：我爱斗地主\n道具名：name\n道具数量：1\n服务提供商：深圳市新中南实业有限公司\n资费说明：\nprice 点（即消费rmb元人民币）\n点击确认按钮确认购买，中国移动\n客服电话400-6788456',
msp_purchase = '购买道具',
msp_purchase_pay_ing = '正在发送付款请求...',
msp_get_props_w = '获取商品列表',

--PlayerProductsUIPlugin
ppp_get_my_props_ing = '获取道具列表...',
ppp_use_props_ing = '发送道具使用请求...',

--RegisterSceneUIPlugin
rsp_nick_name_nil_w = strings_general.g_nick_name_nil_w,
rsp_pswd_nil_w = strings_general.g_pswd_nil_w,
rsp_pswd_formt_w = strings_general.g_pswd_format_w,
rsp_two_pswd_not_same_w = '两次密码输入不一致',
rsp_register_ing = strings_general.g_register_ing,
rsp_connect_hall_ing = strings_general.g_connect_hall_ing,
rsp_register_w = '注册失败',

--ServerNotifyPlugin
snp_bankrupt = '您获得了破产补助：beans个豆子',
snp_plays = '今天您已经玩了count局，再接再厉，恭喜您获得了beans豆子。',
snp_wins = '今天您已经赢了count局，再接再厉，恭喜您获得了beans豆子。',
snp_continue_wins = '今天您已经连赢count局，再接再厉，恭喜您获得了beans豆子。',
snp_logins = '达成连续登录count天成就，恭喜您获得了beans豆子。',
snp_info_complete = '达成完善资料成就，恭喜您获得了beans豆子。',
snp_zaixianyouli = strings_general.g_zaixianyouli,

--PromotionItem
pi_duration = '活动时间：begin～end',
--PromotionScenePlugin
psp_fetch_promotion = '正在获取活动列表...',
psp_fetch_promotion_w = '获取活动列表失败',
psp_fetch_promotion_nil = '当前没有活动',
--MatchResult
mr_next_time = '下一轮比赛将在 time 开始，请密切关注',
--Diploma
dp_msg = '\b\b\b\b\b\b\b\b敬爱的玩家\b\bnick_name，恭喜您在room_name的《match_name》活动中获得：',
dp_award_msg = 'order\b\b\b\baward',
--MatchLogic
ml_no_match_w = '当前没有比赛',
ml_join_fail_w = '报名比赛失败',
ml_joining = '正在报名...',
}

