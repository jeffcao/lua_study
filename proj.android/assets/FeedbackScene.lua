require "src.UIControllerPlugin"
require "src.HallServerConnectionPlugin"

FeedbackScene = class("FeedbackScene", function() 
		return display.newScene("FeedbackScene") 
	end)

function createFeedbackScene() return FeedbackScene.new() end

function FeedbackScene:ctor()
	ccb.feedback_scene = self
	
	self.on_ui_commit_btn_clicked = __bind(self.do_ui_commit_btn_clicked, self)
	
	local function editBoxTextEventHandle(strEventName,pSender)
		local edit = tolua.cast(pSender,"CCEditBox")
		if strEventName == "changed" then
			self.feedback_ttf:setString(edit:getText())
		end
	end
	
	local ccbproxy = CCBProxy:create()
 	local node = CCBReaderLoad("FeedbackScene.ccbi", ccbproxy, false, "")
 	
 	self.input_png = "kuang11.png"
	self.feedback_box = self:addEditbox(self.feed_layer, 500, 200, false, 101)
	self.feedback_box:setInputMode(kEditBoxInputModeAny)
	self.feedback_box:registerScriptEditBoxHandler(editBoxTextEventHandle)
	self.feedback_box:setFontColor(display.COLOR_WHITE)
	--self.feedback_ttf:setDimensions(CCSizeMake(460,160))
	
	local layer = createFullMubanStyleLayer()
	self:addChild(layer)
	layer:setTitle("biaoti09.png")
	
	layer:setContent(node)
	scaleNode(self.rootNode, GlobalSetting.content_scale_factor)

end

function FeedbackScene:do_ui_commit_btn_clicked(tag, sender)
	print("[FeedbackScene:do_ui_commit_btn_clicked]")
	local feedback = trim_blank(self.feedback_box:getText())
	if is_blank(feedback) then
		self:show_message_box("反馈内容不能为空")
		return
	end
	self:show_progress_message_box("保存反馈信息")
	self:feedback(feedback)
end

function FeedbackScene:do_on_trigger_success(data)
	print("[InfoLayer:do_on_trigger_success]")
	self:hide_progress_message_box()
	
	self:show_message_box("保存成功")
	
	Timer.add_timer(2, function()
			CCDirector:sharedDirector():popScene()
			end)

end

function FeedbackScene:do_on_trigger_failure(data)
	print("[InfoLayer:do_on_trigger_failure]")
	self:hide_progress_message_box()
	self:show_message_box(self.failure_msg)

end

UIControllerPlugin.bind(FeedbackScene)
HallServerConnectionPlugin.bind(FeedbackScene)