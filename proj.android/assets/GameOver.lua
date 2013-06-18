require "CCBReaderLoad"
require "src.DialogInterface"
require "src.GameOverPlugin"

GameOver = class("GameOver", function() 
	return display.newLayer("GameOver") 
end)

function createGameOver(onToHall, onChangeDesk, onClose)
	local layer = GameOver.new(onToHall, onChangeDesk, onClose)
	
	return layer
end

function GameOver:ctor()
	
end

function GameOver:initCallback(onToHall, onChangeDesk, onClose)
	self.onGOChangeDeskClicked = onChangeDesk
	self.onGOCloseClicked = onClose
	self.onGOToHallClicked = onToHall
	self.ccbproxy = CCBProxy:create()
	self.ccbproxy:retain()
	ccb.GameOver = self
	local node = CCBReaderLoad("GameOverScene.ccbi", self.ccbproxy, true, "GameOver")
	self.rootNode = tolua.cast(node, "CCLayer")
	self:addChild(self.rootNode)
	scaleNode(self.rootNode, GlobalSetting.content_scale_factor)
	self:setVisible(false)
	
	local menus = CCArray:create()
	menus:addObject(self.to_hall_btn:getParent())
	menus:addObject(self.gm_change_table:getParent())
	menus:addObject(self.return_btn:getParent())
	self:swallowOnTouch(menus)
	self:swallowOnKeypad()
end

DialogInterface.bind(GameOver)
GameOverPlugin.bind(GameOver)