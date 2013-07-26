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
	local user_id = tonumber(info.user_id)
	if gaming_layer.next_user and user_id == gaming_layer.next_user.user_id then
		player = gaming_layer.next_user
	 elseif  gaming_layer.prev_user and user_id == gaming_layer.prev_user.user_id then
		player = gaming_layer.prev_user
	 else 
		player = gaming_layer.self_user
	end
	local avatarFrame = Avatar.getUserAvatarFrame(player)
	self.user_info_avatar:setDisplayFrame(avatarFrame)
	local win = info.win_count
	local lost = info.lost_count
	local percent = 100
	if lost > 0 then percent = 100 * win / (win + lost) end
	local max_l = 4
	if percent < 10 then max_l = 3 end
	percent = tostring(percent)
	if string.len(percent) > max_l then percent = string.sub(percent, 1, max_l - string.len(percent)) end
	self.lbl_info_achievement:setString(percent .. "%  " .. win .. "胜" .. lost .. "负")
	
	self.props_layer:removeAllChildrenWithCleanup(true)
	if gaming_layer.using_props and user_id == gaming_layer.self_user.user_id then
		cclog("gaming_layer.using_props user_id == gaming_layer.self_user.user_id")
		local x = 10
		local step = 50
		for _, prop in pairs(gaming_layer.using_props) do
			local sprite = CCSprite:createWithSpriteFrameName(prop.icon_name)
			sprite:setTag(1000)
			x = x + step
			sprite:setPosition(ccp(x, 22))
			self.props_layer:addChild(sprite)
		end
	end
	
	scaleNode(self.rootNode, GlobalSetting.content_scale_factor)
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