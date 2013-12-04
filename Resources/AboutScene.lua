require "FullMubanStyleLayer"
require "src.UIControllerPlugin"
require "src.Stats"
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
	
	local user_default = CCUserDefault:sharedUserDefault()
	local version = "版本： " .. resource_version
		.. " build:" .. user_default:getStringForKey("pkg_build")
	
	layer:setContent(node)
	self.version_lbl:setString(version)
	
	package.loaded["Version"] = nil
	require "Version"
	
	print('self.rootNode ', self)
	
	require 'TestBackMessageBoxLayer'
	local s = createTestBackMessageBoxLayer(self)
	s:init_r()
	
	Timer.add_timer(3, function() 
	local s2 = createTestBackMessageBoxLayer(self)
	s2.msg_text:setString("box 2")
	s2:setScale(s2:getScaleX() * 1.5)
	s2:init_r()
	end, 'marquee2')
	
	Timer.add_timer(6, function() 
	local s3 = createTestBackMessageBoxLayer(self)
	s3.msg_text:setString("box 3")
	s3:init_r()
	end, 'marquee3')
	
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
	marquee:init(my_layer, my_layer:getContentSize().width/2, my_layer:getContentSize().height/2)
	Timer.add_timer(10, function() marquee:setText("changed to new text, in this way, hahha, now play it") end, 'marquee')
	Timer.add_timer(25, function() marquee:setText("在走马灯里显示汉字，。。。。以及富豪》》》符号") end, 'marquee')
	Timer.add_timer(40, function() marquee:setText("local my_layer = CCLayer:create() my_layer:setAnchorPoint(ccp(0.5,0.5)) my_layer:setContentSize(node:getContentSize()) my_layer:setPosition(node:getContentSize().width/2, node:getContentSize().height/2) my_layer:ignoreAnchorPointForPosition(false) node:addChild(my_layer)") end, 'marquee')
	]]
end

UIControllerPlugin.bind(AboutScene)
