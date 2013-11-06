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
	--require "banana"
end

UIControllerPlugin.bind(AboutScene)
