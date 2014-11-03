local dirMusic = "res/Music/"
local dirImage = "ccbResources/"
local dirParticle = "res/ParticleRes/"

Res = {
	s_landing_scene = "LandingScene.ccbi",
	common_plist = "ccbResources/common.plist",
	common3_plist = "ccbResources/common3.plist",
	common2_plist = "ccbResources/common2.plist",
	dialog_plist = "ccbResources/dialogs.plist",
	info_plist = "ccbResources/info.plist",
	s_cards_plist = "ccbResources/poke_cards.plist",
 	hall_plist = "ccbResources/hall.plist",
 	props_plist = "ccbResources/props.plist",
 	jiesuan_plist = "ccbResources/jiesuan.plist",
 	dating_plist = "ccbResources/dating.plist",
 	ui_wenzi_plist = "ccbResources/ui_wenzi.plist",
 	geren_ziliao_plist = "ccbResources/res/geren_ziliao.plist",
 	youxi_zhong_plist = "ccbResources/res/youxi_zhong.plist",
 	shangchen_jianjie_plist = "ccbResources/res/shangchen_jianjie.plist",
 	huo_dong_plist = "ccbResources/res/huo_dong.plist",

-- 背景音乐
 s_music_bg = dirMusic .. "bg/1.mp3",
 
--商城背景音乐
 s_music_market_bg = dirMusic.."bg/2.mp3",
 
 s_anim_plist = dirImage .. "animation.plist",

-- 背景音乐列表
 --s_music_bg_arr = {dirMusic .. "bg/1.mp3", dirMusic .. "bg/3.mp3",dirMusic .. "bg/4.mp3",dirMusic .. "bg/5.mp3",
 --	dirMusic .. "bg/7.mp3",dirMusic .. "bg/8.mp3",dirMusic .. "bg/9.mp3",dirMusic .. "bg/10.mp3"},
   s_music_bg_arr = {dirMusic .. "bg/1.mp3"},

-- 按键点击音效
 s_music_button_click = dirMusic .. "click/button_click.ogg",
 
-- 游戏引导音效
 s_music_introduce = dirMusic .. "introduce/",
 
 s_music_vip = dirMusic .. "vip_sounds/",

-- 抽牌
 s_effect_pick_card = dirMusic .. "pick/discard.ogg",

-- 发牌音效
 s_effect_deliver_poke_cards = dirMusic .. "deliver_cards/start.wav",

-- 结算
 s_effect_win = dirMusic .. "game_over/win.mp3",
 s_effect_lost = dirMusic .. "game_over/lost.mp3",

-- 叫地主
 s_effect_grab_lord_path = dirMusic .. "grab_lord/",

-- 爆炸声
 s_effect_boom = dirMusic .. "boom/boom.wav",
-- 炸弹女声
 s_effect_bomb_female = dirMusic .. "boom/zhadan_f.wav",
-- 火箭（王炸）女声
 s_effect_rocket_female = dirMusic .. "boom/wangzha_f.wav",
--不出
 s_effect_pass_path = dirMusic .. "pass/",
-- 单张路径
 s_effect_single_path = dirMusic .. "single/",
-- 对子
 s_effect_pairs_path = dirMusic .. "pairs/",
-- 一张牌两张牌报警
 s_effect_tips_path = dirMusic .. "tips/",

-- 牌型
 s_effect_card_type_path = dirMusic .. "card_type/",
--首充大礼包动画
 s_shouchonglibao_plist = dirImage .. "shouchonglibao.plist",
 
 --飞机粒子特效plist
 s_ddz_plane_plist = dirParticle .. "feiji.plist",
--飞机粒子特效plist
 s_ddz_rocket_plist = dirParticle .. "huojian.plist",
 
}