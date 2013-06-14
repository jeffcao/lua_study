require "CCBReaderLoad"
require "src.DialogInterface"
require "src.GameOverPlugin"

GameOver = class("GameOver", function() 
	return display.newLayer("GameOver") 
end)

function createGameOver()
	return GameOver.new()
end

function GameOver:ctor()
	self.ccbproxy = CCBProxy:create()
	self.ccbproxy:retain()
	ccb.GameOver = self
	self.ontohall = __bind(self.onToHallClicked, self)
	self.onChangeDesk = __bind(self.onChangeDeskClicked, self)
	self.onClose = __bind(self.onGameOverCloseClicked, self)
	local node = CCBReaderLoad("GameOverScene.ccbi", self.ccbproxy, true, "GameOver")
	self.rootNode = tolua.cast(node, "CCLayer")
	self:addChild(self.rootNode)
	scaleNode(self.rootNode, GlobalSetting.content_scale_factor)
	
	local menus = CCArray:create()
	menus:addObject(self.to_hall_btn:getParent())
	menus:addObject(self.gm_change_table:getParent())
	menus:addObject(self.return_btn:getParent())
	self:swallowOnTouch(menus)
	self:swallowOnKeypad()
end

DialogInterface.bind(GameOver)
GameOverPlugin.bind(GameOver)