require "CCBReaderLoad"

HuafeiRankItem = class("HuafeiRankItem", function() return display.newLayer("HuafeiRankItem") end)

function createHuafeiRankItem() return HuafeiRankItem.new() end

function HuafeiRankItem:ctor()
	self.ccbproxy = CCBProxy:create()
	self.ccbproxy:retain()
	ccb.RankItem = self
	--local node = 
	CCBReaderLoad("RankItem.ccbi", self.ccbproxy, true, "RankItem")
--	self.rootNode = tolua.cast(node, "CCLayer")
	self:addChild(self.rootNode)
	self.rank_lbl:setPosition(ccp(60,15))
	self.name_lbl:setPosition(ccp(120,15))
	self.bean_lbl:setPosition(ccp(300,15))
	self.bean_img:setPosition(ccp(280,30))
	self.gets_lbl:setPosition(ccp(420,15))
	self.bean_lbl:setFontSize(20)
	self.gets_lbl:setFontSize(20)
	self.gets_lbl:setVisible(true)
	scaleNode(self.rootNode, GlobalSetting.content_scale_factor)
end

function HuafeiRankItem:init(rank)
	self.rank_lbl:setString(rank.id)
	self.name_lbl:setString(rank.nick_name)
	self.bean_lbl:setString(rank.total_balance)
	self.gets_lbl:setString(tostring(tonumber(rank.total_balance)-tonumber(rank.balance)))
end

