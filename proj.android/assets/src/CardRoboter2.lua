--[[
记牌器
1. 游戏开始的时候，服务器通知是否开启记牌器，如果有开启，显示记牌器并初始化
2. 游戏结束的时候，查看记牌器是否处于显示状态，如果显示，隐藏记牌器并重置
3. 游戏中，接收到服务器打牌通知，将打的牌加入到记牌器
]]
CardRoboter2 = class("CardRoboter2")

function CardRoboter2:ctor()
	print("CardRoboter2:ctor()")
end

function CardRoboter2:init(parent, z_order)
	if self.parent then
		print("don't init again")
		return
	end
	self.ccbproxy = CCBProxy:create()
	self.ccbproxy:retain()
	ccb.card_roboter = self
	
	--[[
	self.on_button_clicked = function() 
		self.recorder:setVisible(not self.recorder:isVisible()) 
		self:playButtonEffect()
	end
	]]
	local node = CCBReaderLoad("CardRoboter.ccbi", self.ccbproxy, true, "card_roboter")
	self.layer = node
	
	z_order = z_order or 9999
	self.parent = parent
	self:reset()
	self.button:setVisible(false)
	print("self.layer", self.layer)
	self.layer:setVisible(false)
	self.layer:setPosition(ccp(0, 0))
	self.parent:addChild(self.layer, z_order)
	scaleNode(self.layer, GlobalSetting.content_scale_factor)
end

function CardRoboter2:isShowing()
	return self.layer:isVisible()
end

function CardRoboter2:dismiss()
	self.layer:setVisible(false)
end

function CardRoboter2:show()
	self.layer:setVisible(true)
end

function CardRoboter2:reset()
	self.cards_played = {}
	for value = 3, 15 do
		self.cards_played[value] = 4
	end
	self.cards_played[16] = 1
	self.cards_played[17] = 1
	self.stats_layer:removeAllChildrenWithCleanup(true)
	self:updateCards()
end

function CardRoboter2:onCardPlay(cards)
	for _, poke in pairs(cards) do
		local value = tonumber(poke.poke_value)
		print("card poke value is:", poke.poke_value)
		print("self value is:", self.cards_played[poke.poke_value])
		self.cards_played[value] = self.cards_played[value] - 1
	end
	self:updateCards()
end

function CardRoboter2:updateCards()
	self.stats_layer:removeAllChildrenWithCleanup(true)
	for value = 3, 17 do
		local label = CCLabelTTF:create()
		label:setFontSize(18)
		label:setString(self.cards_played[value])
		label:setPosition(ccp((17 - value + 1)*29, 11))
		self.stats_layer:addChild(label)
	end
end

function CardRoboter2:setJipaiqiShow(show)
	if show then self:show() else self:dismiss() end
end

function CardRoboter2:onServerStartGame(data)
	if data.show_jipaiqi == 1 then
		self:show()
	else
		self:dismiss()
	end
end

function CardRoboter2:onServerPlayCard(data)
	self:onCardPlay(data)
end

function CardRoboter2:onServerGameOver(data)
	self:reset()
	self:dismiss()
end

SoundEffect.bind(CardRoboter2)
