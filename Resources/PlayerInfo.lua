require "CCBReaderLoad"
--require "src.DialogInterface"

PlayerInfo = class("PlayerInfo", function() return display.newLayer("PlayerInfo") end)

function createPlayerInfo() return PlayerInfo.new() end

function PlayerInfo:ctor()
	self.ccbproxy = CCBProxy:create()
	self.ccbproxy:retain()
	ccb.PlayerInfo = self
	local node = CCBReaderLoad("PlayerInfo.ccbi", self.ccbproxy, true, "PlayerInfo")
	self.rootNode = tolua.cast(node, "CCLayer")
	self:addChild(self.rootNode)
	scaleNode(self.rootNode, GlobalSetting.content_scale_factor)
	--local menus = CCArray:create()
	--self:swallowOnTouch(menus)
	--self:swallowOnKeypad()
	
	self.rootNode:registerScriptTouchHandler(__bind(self.onTouch, self))
    self.rootNode:setTouchEnabled(true)
end

function PlayerInfo:initWithInfo(gaming_layer, info)
	self.lbl_info_name:setString(info.nick_name)
	local gender = "男"
	if info.gender and info.gender ~=1 then gender = "女" end
	self.lbl_info_gender:setString(gender)
	self.lbl_info_beans:setString(info.score)
	local player = nil
	if gaming_layer.next_user and user_id == gaming_layer.next_user.user_id then
		player = gaming_layer.next_user
	 elseif  gaming_layer.prev_user and user_id == gaming_layer.prev_user.user_id then
		player = gaming_layer.prev_user
	 else 
		player = gaming_layer.self_user
	end
	local avatarFrame = Avatar.getUserAvatarFrame(player)
	self.user_info_avatar:setDisplayFram(avatarFrame)
	local win = info.win_count
	local lost = info.lost_count
	local percent = 100
	if lost > 0 then percent = 100 * win / (win + lost) end
	self.lbl_info_achievement:setString(tonumber(percent) .. "%  " .. win .. "胜" .. lost .. "负")
end

function PlayerInfo:onTouch(eventType, x, y)
	cclog("touch event PlayerInfo:%s,x:%d,y:%d", eventType, x, y)
	if eventType == "began" then
		return self:onTouchBegan(ccp(x, y))
	elseif eventType == "moved" then
		return self:onTouchMoved(ccp(x, y))
	else
		return self:onTouchEnded(ccp(x, y))
	end
end

function PlayerInfo:onTouchBegan(loc)
	return true
end

function PlayerInfo:onTouchMoved(loc)
end

function PlayerInfo:onTouchEnded(loc)
	--loc = self.bg:convertToNodeSpace(loc)
	if not self.bg:boundingBox():containsPoint(loc) then
		self:setVisible(false)
	end
end

--DialogInterface.bind(PlayerInfo)