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

function AboutScene:ctor()
	Stats:on_start("fda")
	ccb.about_scene = self
	
	local ccbproxy = CCBProxy:create()
 	local node = CCBReaderLoad("About.ccbi", ccbproxy, false, "")
	
	local layer = createFullMubanStyleLayer()
	self:addChild(layer)
	layer:setTitle("biaoti07.png")
	
	local user_default = CCUserDefault:sharedUserDefault()
	local version = "版本： " .. user_default:getStringForKey("pkg_version_name") 
		.. " build:" .. user_default:getStringForKey("pkg_build")
	self.version_lbl:setString(version)
	layer:setContent(node)

	--test 9sprite
	
	--local scale9 = CCScale9Sprite:create("ccbResources/yinyingkuang.png")
	--scale9:setPosition(ccp(400,240))
	--local size = CCSizeMake(700,340)
	--dump(size, "size is")
	--scale9:setPreferredSize(size)
 	--self:addChild(scale9)
end

UIControllerPlugin.bind(AboutScene)
