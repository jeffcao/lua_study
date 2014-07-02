require "CCBReaderLoad"

MatchResultItem = class("MatchResultItem", function() return display.newLayer("MatchResultItem") end)

function createMatchResultItem() return MatchResultItem.new() end

function MatchResultItem:ctor()
	self.ccbproxy = CCBProxy:create()
	self.ccbproxy:retain()
	ccb.RankItem = self
	CCBReaderLoad("RankItem.ccbi", self.ccbproxy, true, "RankItem")
	self:addChild(self.rootNode)
	self.rank_lbl:setPosition(ccp(2,15))
	self.name_lbl:setPosition(ccp(50,15))
	self.bean_lbl:setPosition(ccp(168,15))
	self.bean_lbl:setDimensions(CCSizeMake(100,42))
	self.gets_lbl:setPosition(ccp(253,15))
	self.bean_lbl:setFontSize(20)
	self.gets_lbl:setFontSize(20)
	self.gets_lbl:setVisible(true)
	scaleNode(self.rootNode, GlobalSetting.content_scale_factor)
end

function MatchResultItem:init(item)
	self.rank_lbl:setString(item.rank)
	self.name_lbl:setString(item.nick_name)
	self.bean_lbl:setString(item.scores)
	local bonus = ''
	local cjson = require "cjson"
	if item.bonus ~= cjson.null then bonus = item.bonus end
	local text = '元话费'
	if item.type and item.type == 'bean' then text = '豆子' end
	self.gets_lbl:setString(bonus..text)
end

