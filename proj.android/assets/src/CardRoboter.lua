--[[
记牌器
1. 游戏开始的时候，服务器通知是否开启记牌器，如果有开启，显示记牌器并初始化
2. 游戏结束的时候，查看记牌器是否处于显示状态，如果显示，隐藏记牌器并重置
3. 游戏中，接收到服务器打牌通知，将打的牌加入到记牌器
]]
CardRoboter = class("CardRoboter")
local cards_per_co = 18

function CardRoboter:ctor()
	print("CardRoboter:ctor()")
end

function CardRoboter:init(parent, z_order)
	if self.parent then
		print("don't init again")
		return
	end
	z_order = z_order or 0
	self.parent = parent
	self.cards_played = {}
	self.layer = display.newLayer()
	print("self.layer", self.layer)
	self.layer:setVisible(false)
	self.layer:setPosition(ccp(230, 300))
	self.layer:setAnchorPoint(ccp(0,0))
	self.parent:addChild(self.layer, z_order)
end

function CardRoboter:isShowing()
	return self.layer:isVisible()
end

function CardRoboter:dismiss()
	self.layer:setVisible(false)
end

function CardRoboter:show()
	self.layer:setVisible(true)
end

function CardRoboter:reset()
	self.cards_played = {}
	self.layer:removeAllChildrenWithCleanup(true)
end

function CardRoboter:onCardPlay(cards)
	table.combine(self.cards_played, cards)
	table.sort(self.cards_played, function(a, b) return b.index > a.index end)
	self:updateCards()
end

function CardRoboter:updateCards()
	self.layer:removeAllChildrenWithCleanup(true)
	local z_order = 0
	for _, card in pairs(self.cards_played) do
		local sprite = CCSprite:createWithSpriteFrameName(card.image_filename)
		sprite:setPosition(ccp((z_order % cards_per_co) * 20, 
			(-math.floor(z_order / cards_per_co)) * 30))
		sprite:setScale(GlobalSetting.content_scale_factor * 0.7)
		sprite:setColor(ccc3(187,187,187))
		self.layer:addChild(sprite, z_order)
		z_order = z_order + 1
	end
end

function CardRoboter:onServerStartGame(data)
	self:show()
end

function CardRoboter:onServerPlayCard(data)
	self:onCardPlay(data)
end

function CardRoboter:onServerGameOver(data)
	self:reset()
	self:dismiss()
end
