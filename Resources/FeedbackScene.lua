require "src.UIControllerPlugin"
require "src.HallServerConnectionPlugin"

FeedbackScene = class("FeedbackScene", function() return display.newScene("FeedbackScene") end)

function createFeedbackScene() return FeedbackScene.new() end

function FeedbackScene:ctor()
	ccb.feedback_scene = self
	
	local ccbproxy = CCBProxy:create()
 	local node = CCBReaderLoad("FeedbackScene.ccbi", ccbproxy, false, "")
 	
 	self.input_png = "ccbResources/kuang01.png"
	self.nick_name_box = self:addEditbox(self.feed_layer, 500, 200, false, 101)
	
	local layer = createFullMubanStyleLayer()
	self:addChild(layer)
	layer:setTitle("ccbResources/fan01.png")
	
	layer:setContent(node)

end

function FeedbackScene:onKeypad(key)
	if key == "backClicked" then
		self:doToHall()
	end
end

function FeedbackScene:doToHall()
	--local scene = createHallScene()
	CCDirector:sharedDirector():popScene()
end

UIControllerPlugin.bind(FeedbackScene)
HallServerConnectionPlugin.bind(FeedbackScene)