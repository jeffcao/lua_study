require "FullMubanStyleLayer"
require "src.UIControllerPlugin"
require "src.Stats"
require 'src.ToastPlugin'
require 'src.MarqueePlugin'
require 'MatchResult'
require 'Diploma'
require 'InputMobile'
require 'src.strings'
AboutScene = class("AboutScene", function()
	print("new about scene")
	return display.newScene("AboutScene")	
end
)

function createAboutScene()
	print("create about scene")
	return AboutScene.new()
end

function AboutScene:onEnter()
	Stats:on_start("about")
	--ss
end

function AboutScene:onExit()
	Stats:on_end("about")
end

function AboutScene:ctor()
	ccb.about_scene = self
	local ccbproxy = CCBProxy:create()
 	local node = CCBReaderLoad("About.ccbi", ccbproxy, false, "")
	
	local layer = createFullMubanStyleLayer()
	self:addChild(layer)
	layer:setTitle("biaoti07.png")
	--layer:setTitleLeft()
	--layer:showTitleBg()
	--layer:setDecorationHuawen()
	--layer:removeRepeatBg()
	local company_name = GlobalSetting.company_name[GlobalSetting.app_id] or GlobalSetting.company_name.default
	company_name = string.gsub(strings.as_company, 'company', company_name)
	company_name = string.gsub(company_name, 'app_name', app_name())
	print('company_name is', company_name)
	self.company_name:setString(company_name)
	local user_default = CCUserDefault:sharedUserDefault()
	local version = "版本： " .. resource_version
		.. " build:" .. user_default:getStringForKey("pkg_build")
	
	layer:setContent(node)
	self.version_lbl:setString(version)
	--[[
	local jni_helper = DDZJniHelper:create()
	local data = {price=1.0,which=2,desc='记牌器',cpparam='1066960011123'}
	local cjson = require("cjson")
	local status, s = pcall(cjson.encode, data)
	local str = 'on_pay_anzhi_' .. s
	print('pay:', str)
	jni_helper:messageJava(str)
	]]
	--[[
	local dialog = createInputMobile(function() end)
	self.rootNode:addChild(dialog)
	dialog:show()
	]]
	--[[
	self:test_slot(0)
	Timer.add_timer(1,function()
	self:test_slot(1) end, 'a')
	Timer.add_timer(3, function()
	self:test_slot(2) end , 'b')
	]]
	
	--[[
	local result = createMatchResult()
	local data = {time='18:00', win_score=4500, me_rank=300}
	data.match_rank = {}
	for index=1,5 do
		--id, nick_name, beans_win, award
		local item = {rank=index,nick_name='user'..tostring(math.random(10000)),scores=math.random(20000),bonus='award'..tostring(math.random(100000000))}
		item.award='6元话费'
		table.insert(data.match_rank, item)
	end
	table.sort(data.match_rank, function(a,b)
			return tonumber(a.rank) > tonumber(b.rank)
		end
		)
	result:set_result(data)
	self.rootNode:addChild(result)
	--result:attach_to(self.rootNode)
	result:show()
	]]
	
	--[[
	local diploma = createDiploma()
	diploma:init({
	dp_msg="\\b\\b\\b\\b\\b\\b\\b\\b敬爱的玩家\\b\\b夏汐，恭喜您在送话费的《天天送话费》活动中获得：",
	dp_award_msg = "第1名\\b\\b\\b\\b"
	})
	diploma:attach_to(self.rootNode)
	diploma:show()
	]]
	--[[
	Timer.add_timer(1,function()
	add_scale9sprite(self.rootNode, CCSizeMake(600,400),ccp(400,240)) end, 'a')
	Timer.add_timer(5,function()
	add_scale9sprite(self.rootNode, CCSizeMake(480,320),ccp(400,240)) end, 'b')
	]]
	--Timer.add_timer(3, function() ToastPlugin.show_message_box_suc("123") end, 'toast')
	--Timer.add_timer(6, function() ToastPlugin.show_message_box("fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff456") end, 'toast')
	
	
	--[[
	package.loaded["Version"] = nil
	require "Version"
	]]
	--MarqueePlugin.addMarquee(self)
	--[[
	local my_layer = CCLayer:create()
	my_layer:setAnchorPoint(ccp(0.5,0.5))
	my_layer:setContentSize(node:getContentSize())
	my_layer:setPosition(node:getContentSize().width/2, node:getContentSize().height/2)
	my_layer:ignoreAnchorPointForPosition(false)
	node:addChild(my_layer)
	local marquee = Marquee:create()
	--marquee:setText("hahahahhhhhhhhhhhhhhhhhhhhhhhhhhh")
	marquee:enableStroke()
	marquee:setSize(500, 32)
	marquee:setTextProvider(function() return "agmn" end)
	marquee:init(my_layer, my_layer:getContentSize().width/2, my_layer:getContentSize().height/2)
	]]
	--Timer.add_timer(10, function() marquee:setText("changed to new text, in this way, hahha, now play it") end, 'marquee')
	--Timer.add_timer(25, function() marquee:setText("在走马灯里显示汉字，。。。。以及富豪》》》符号") end, 'marquee')
	--Timer.add_timer(40, function() marquee:setText("local my_layer = CCLayer:create() my_layer:setAnchorPoint(ccp(0.5,0.5)) my_layer:setContentSize(node:getContentSize()) my_layer:setPosition(node:getContentSize().width/2, node:getContentSize().height/2) my_layer:ignoreAnchorPointForPosition(false) node:addChild(my_layer)") end, 'marquee')
	
end

function AboutScene:follow_sprite(follower, to_follow)
	local y = to_follow:getPositionY() - to_follow:getContentSize().width*to_follow:getScaleY()
	local x = to_follow:getPositionX()
	follower:setPosition(ccp(x,y))
end

function AboutScene:follow(follower, total)
	local to_follow = follower:getParent():getChildByTag((follower:getTag()+2)%total)
	self:follow_sprite(follower, to_follow)
end

function AboutScene:getNext(node,total)
	local to_follow = node:getParent():getChildByTag((node:getTag()+1)%total)
	return to_follow
end

function AboutScene:create_sprite(name, tag, node, total)
	local sprite = CCSprite:createWithSpriteFrameName(name)
	sprite:setScale(GlobalSetting.content_scale_factor)
	sprite:setAnchorPoint(ccp(0.5,1))
	node:addChild(sprite, 0, tag)
	if tag ~= 1 then
		local last = node:getChildByTag((tag-1)%total)
		self:follow_sprite(sprite, last)
	end
end

function AboutScene:test_slot(i)
	require 'src.resources'
	CCSpriteFrameCache:sharedSpriteFrameCache():addSpriteFramesWithFile(Res.props_plist)
	local layer = CCLayer:create()
	local frames = {"common_jewelry_box_06.png", "libao_024_liujin_small.png", "dj_012_jipaiqi.png"}
	for index=1,#frames do
		self:create_sprite(frames[index], index, layer, #frames)
	end
	self.rootNode:addChild(layer)
	layer:setPosition(300+i*80,300)
	
	local seq = nil
	local pos = 1
	local after = CCCallFuncN:create(function(sender)
		local cur_tag = pos%3
		if cur_tag == 0 then cur_tag = 3 end
		local next_tag = (pos+2) % 3
		if next_tag == 0 then next_tag =3 end
		self:follow_sprite(sender:getChildByTag(cur_tag), sender:getChildByTag(next_tag))
		pos = pos+1
	end)
	local move = CCMoveBy:create(0.3, ccp(0,layer:getChildByTag(1):getContentSize().width*layer:getChildByTag(1):getScaleY()))
	local toarr=function(table)
	local array = CCArray:create()
	if not table then return array end
	for _, _v in pairs(table) do
		array:addObject(_v)
	end
	return array
	end
	seq = CCSequence:create(toarr({move,after}))
	layer:runAction(CCRepeatForever:create(seq))
end

UIControllerPlugin.bind(AboutScene)
