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
	self.onGOChangeDeskClicked = function()
		onChangeDesk()
		AppStats.event(UM_BALANCE_CHANGE_DESK)
	end
	self.onGOCloseClicked = onClose
	self.onGOToHallClicked = function()
		onToHall()
		AppStats.event(UM_BALANCE_TO_HALL)
	end	
	self.ccbproxy = CCBProxy:create()
	self.ccbproxy:retain()
	ccb.GameOver = self
	local node = CCBReaderLoad("GameOverScene.ccbi", self.ccbproxy, true, "GameOver")
	self.rootNode = tolua.cast(node, "CCLayer")
	self:addChild(self.rootNode)
	scaleNode(self.rootNode, GlobalSetting.content_scale_factor)
	self:setVisible(false)
	
	set_anniu_1_3_stroke(self.return_btn_lbl)
	set_anniu_1_3_stroke(self.gm_change_table_lbl)
	set_anniu_1_3_stroke(self.to_hall_btn_lbl)
	
	local menus = CCArray:create()
	menus:addObject(self.return_btn:getParent())
	self:swallowOnTouch(menus)
	self:swallowOnKeypad()
end

DialogInterface.bind(GameOver)
GameOverPlugin.bind(GameOver)