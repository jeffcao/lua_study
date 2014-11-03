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
end

function AboutScene:onExit()
	Stats:on_end("about")
end

function AboutScene:showConfig()
	local user_default = CCUserDefault:sharedUserDefault()
	local local_env = user_default:getStringForKey("env")
	local local_url = user_default:getStringForKey("url")
	local local_dbg = user_default:getStringForKey("debug")
	local_dbg = (local_dbg and local_dbg == "true")
	if (not local_dbg) and is_blank(local_url) and is_blank(local_env) then return end
	
	local str = "使用本地配置:\nenv:" .. (local_env or "") .. "\nurl:" .. (local_url or "")
	if local_dbg then
		str = '本地log已打开\n' .. str
	else
		str = '本地log尚未打开\n' .. str
	end 
	local ttf = CCLabelTTF:create(str, "Arial", 23)
	ttf:setHorizontalAlignment(kCCTextAlignmentLeft)
	ttf:setAnchorPoint(ccp(0,0))
	self:addChild(ttf)
end

function AboutScene:ctor()
	CCSpriteFrameCache:sharedSpriteFrameCache():addSpriteFramesWithFile(Res.shangchen_jianjie_plist)
	ccb.about_scene = self
	local ccbproxy = CCBProxy:create()
 	local node = CCBReaderLoad("About.ccbi", ccbproxy, false, "")
	
	local layer = createFullMubanStyleLayer()
	self:addChild(layer)
	layer:setTitle("youxi_jianjie/yxjj-xiaotu/yx-jianjie.png")
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
	
	self:showConfig()

	scaleNode(node, GlobalSetting.content_scale_factor)
	
end



UIControllerPlugin.bind(AboutScene)
SceneEventPlugin.bind(AboutScene)