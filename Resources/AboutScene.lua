require "FullMubanStyleLayer"
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

end

