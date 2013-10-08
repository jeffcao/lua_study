require "CCBReaderLoad"
require "src.DialogInterface"
require "src.RankUPlugin"

Rank = class("Rank", function() return display.newLayer("Rank") end)

function createRank() return Rank.new() end

function Rank:ctor()
	self.ccbproxy = CCBProxy:create()
	self.ccbproxy:retain()
	ccb.Rank = self
	local node = CCBReaderLoad("Rank.ccbi", self.ccbproxy, true, "Rank")
	self.rootNode = tolua.cast(node, "CCLayer")
	self:addChild(self.rootNode)
	
	self:init()
	scaleNode(self.rootNode, GlobalSetting.content_scale_factor)
end

function Rank:init()
	local menus = CCArray:create()
	menus:addObject(self.rootNode)
	menus:addObject(self.rank_content)
	self:swallowOnTouch(menus)
	self:setVisible(false)
	self:swallowOnKeypad()
end

DialogInterface.bind(Rank)
RankUPlugin.bind(Rank)