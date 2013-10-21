require "CCBReaderLoad"
require "src.SoundEffect"

GuifanEndScene = class("GuifanEndScene", function()
	return display.newScene("GuifanEndScene")
end)

function createGuifanEndScene()
	return GuifanEndScene.new()
end

function GuifanEndScene:ctor()
	self.ccbproxy = CCBProxy:create()
	self.ccbproxy:retain()
	self.onExitConfirmClicked = __bind(self.onExitConfirmClicked, self)
	self.onExitCancelClicked = __bind(self.onExitCancelClicked, self)
	self.onGameCenterConfirmClicked = __bind(self.onGameCenterConfirmClicked, self)
	self.onGameCenterExitClicked = __bind(self.onGameCenterExitClicked, self)
	ccb.GuifanEnd = self
	local node = CCBReaderLoad("GuifanEndScene.ccbi", self.ccbproxy, true, "GuifanEnd")
	self.rootNode = tolua.cast(node, "CCLayer")
	self:addChild(self.rootNode)
	scaleNode(self.rootNode, GlobalSetting.content_scale_factor)
	
	self.rootNode:setKeypadEnabled(true)
	self.rootNode:registerScriptKeypadHandler(function(key)
		if key == "backClicked" then
			CCDirector:sharedDirector():popScene()
		end
	end)
end

function GuifanEndScene:onEnter() 
	self:play_vip_voice("4.mp3")
end

function GuifanEndScene:onExitConfirmClicked()
	self.layer_exit:setVisible(false)
	self.layer_game_center:setVisible(true)
end

function GuifanEndScene:onExitCancelClicked()
	CCDirector:sharedDirector():popScene()
end

function GuifanEndScene:onGameCenterConfirmClicked()
	CCDirector:sharedDirector():endToLua()
	local jni = DDZJniHelper:create()
	jni:messageJava("on_open_url_intent_g.10086.cn")
end

function GuifanEndScene:onGameCenterExitClicked()
	CCDirector:sharedDirector():endToLua()
end

 SoundEffect.bind(GuifanEndScene)