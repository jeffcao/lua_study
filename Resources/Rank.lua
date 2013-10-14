require "CCBReaderLoad"
require "src.DialogInterface"
require "src.RankUPlugin"
require "src.UIControllerPlugin"
require "src/WebsocketRails/Timer"

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
	
	local sc = GlobalSetting.content_scale_factor*0.52
	self.rank_avatar:setScale(sc)
	sc = GlobalSetting.content_scale_factor*0.85
	self.rank_avatar_bg:setScale(sc)
	
	self:setOnKeypad(function(key)
		if key == "backClicked" then
			print("Rank on key pad")
			if self:isShowing()  then
				self:dismiss()
			end
		end
	end)
	GlobalSetting.rank_dialog = self
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
UIControllerPlugin.bind(Rank)