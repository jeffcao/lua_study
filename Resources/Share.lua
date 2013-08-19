require "CCBReaderLoad"
require "src.DialogInterface"

Share = class("Share", function() return display.newLayer("Share") end)

function createShare() return Share.new() end

function Share:ctor()
	self.ccbproxy = CCBProxy:create()
	self.ccbproxy:retain()
	self.on_share_close = function() self:dismiss() end
	self.on_tencent_share = function() DDZJniHelper:create():messageJava('share_intent_'..GlobalSetting.tencent_share_url) self:dismiss() end
	self.on_sina_share = function() DDZJniHelper:create():messageJava('share_intent_'..GlobalSetting.sina_share_url) self:dismiss() end
	ccb.Share = self
	local node = CCBReaderLoad("Share.ccbi", self.ccbproxy, true, "Share")
	self.rootNode = tolua.cast(node, "CCLayer")
	self:addChild(self.rootNode)
	scaleNode(self.rootNode, GlobalSetting.content_scale_factor)
	
    self:init()
end

function Share:init()

	local menus = CCArray:create()
	menus:addObject(self.menu_tencent_share)
	menus:addObject(self.menu_sina_share)
	menus:addObject(self.menu_close_share)
	menus:addObject(self.rootNode)
	self:swallowOnTouch(menus)
	self:setVisible(false)
	
	self:swallowOnKeypad()
	self:setOnKeypad(function(key)
		if key == "backClicked" then
			print("share dialog on key pad")
			if self:isShowing()  then
				self:dismiss()
			end
		end
	end)
	self.rootNode:registerScriptTouchHandler(__bind(self.onTouch, self))
    self.rootNode:setTouchEnabled(true)
    
	scaleNode(self.rootNode, GlobalSetting.content_scale_factor)
end

function Share:onTouch(eventType, x, y)
	cclog("touch event Share:%s,x:%d,y:%d", eventType, x, y)
	if eventType == "began" then
		return self:onTouchBegan(ccp(x, y))
	elseif eventType == "moved" then
		return self:onTouchMoved(ccp(x, y))
	else
		return self:onTouchEnded(ccp(x, y))
	end
end

function Share:onTouchBegan(loc)
	return true
end

function Share:onTouchMoved(loc)
end

function Share:onTouchEnded(loc)
print('self.bg', self.bg)
	if not self.bg:boundingBox():containsPoint(loc) then
		self:dismiss()
	end
end

DialogInterface.bind(Share)