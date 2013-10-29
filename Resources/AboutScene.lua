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
	local version = "版本： " .. user_default:getStringForKey("pkg_version_name") 
		.. " build:" .. user_default:getStringForKey("pkg_build")
	
	layer:setContent(node)
	self.version_lbl:setString(version)
	--set_stroke(self.version_lbl, 1.5, ccc3(255,255,255))
	--set_string_with_stroke(self.version_lbl, version)
	local path = CCFileUtils:sharedFileUtils():getWritablePath()
	local name = "res.zip"
	local downloader = Downloader:create("http://adproject.u.qiniudn.com/ccbResources8.zip",path, name)
	
	--name = "dxzjh.apk"
	--local downloader = Downloader:create("http://adproject.u.qiniudn.com/dxzjh.apk",path, name)
	self.hdlr = function(type, data)
		print("download listen=>", type, data)
		if type == "success" then
		--  安装APK
		--	local jni_helper = DDZJniHelper:create()
		--	jni_helper:messageJava("on_install_"..path.."/"..name)
			local result = downloader:uncompress()
		print("umcompress result is " .. tostring(result))
		end
	end
	downloader:setDownloadScriptHandler(self.hdlr)
	downloader:update()
end

UIControllerPlugin.bind(AboutScene)
