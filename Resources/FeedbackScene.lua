require "src.UIControllerPlugin"
require "src.HallServerConnectionPlugin"

FeedbackScene = class("FeedbackScene", function() 
		return display.newScene("FeedbackScene") 
	end)

function createFeedbackScene() return FeedbackScene.new() end

function FeedbackScene:ctor()
	ccb.feedback_scene = self
	
	self.on_ui_commit_btn_clicked = __bind(self.do_ui_commit_btn_clicked, self)
	
	local ccbproxy = CCBProxy:create()
 	local node = CCBReaderLoad("FeedbackScene.ccbi", ccbproxy, false, "")
 	
 	self.input_png = "kuang11.png"
	self.nick_name_box = self:addEditbox(self.feed_layer, 500, 200, false, 101)
	self.nick_name_box:setInputMode(kEditBoxInputModeAny)
	
	local layer = createFullMubanStyleLayer()
	self:addChild(layer)
	layer:setTitle("biaoti09.png")
	
	layer:setContent(node)

end

function FeedbackScene:do_ui_commit_btn_clicked(tag, sender)
	print("[FeedbackScene:do_ui_commit_btn_clicked]")
	
	
end

UIControllerPlugin.bind(FeedbackScene)
HallServerConnectionPlugin.bind(FeedbackScene)