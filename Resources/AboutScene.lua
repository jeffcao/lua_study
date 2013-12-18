require "FullMubanStyleLayer"
require "src.UIControllerPlugin"
require "src.Stats"
require 'src.ToastPlugin'
require 'src.MarqueePlugin'
require 'MatchResult'
require 'Diploma'
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
	
	local user_default = CCUserDefault:sharedUserDefault()
	local version = "版本： " .. resource_version
		.. " build:" .. user_default:getStringForKey("pkg_build")
	
	layer:setContent(node)
	self.version_lbl:setString(version)
	
	--[[
	local result = createMatchResult()
	local data = {time='18:00', beans_win=4500, order=300}
	data.list = {}
	for index=1,50 do
		--id, nick_name, beans_win, award
		local item = {id=index,nick_name='user'..tostring(math.random(10000)),beans_win=math.random(20000),award='award'..tostring(math.random(100000000))}
		item.award='6元话费'
		table.insert(data.list, item)
	end
	result:set_result(data)
	self.rootNode:addChild(result)
	--result:attach_to(self.rootNode)
	result:show()
	]]
	
	--[[
	local diploma = createDiploma()
	diploma:init({nick_name='王尼玛', room_name='话费房', match_name='人人都有话费送', order='第一名', award='10元话费奖励'})
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


UIControllerPlugin.bind(AboutScene)
