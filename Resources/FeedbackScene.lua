require "src.UIControllerPlugin"
require "src.HallServerConnectionPlugin"
require "src.Stats"
require "src.AppStats"

FeedbackScene = class("FeedbackScene", function() 
		return display.newScene("FeedbackScene") 
	end)

function createFeedbackScene() return FeedbackScene.new() end

function FeedbackScene:onEnter()
	Stats:on_start("feedback")
end

function FeedbackScene:onExit()
	Stats:on_end("feedback")
end

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
 	
 	self.feedback_ttf:setColor(ccc3(255,255,255))
 	
 	self.input_png = "ccbResources/yinyingkuang.png"
 	self.direct = true
	self.feedback_box = self:addEditbox(self.feed_layer, 500, 200, false, 101)
	self.feedback_box:setInputMode(kEditBoxInputModeAny)
	self.feedback_box:registerScriptEditBoxHandler(editBoxTextEventHandle)
	--self.feedback_box:setFontColor(display.COLOR_WHITE)
	self.feedback_box:setFontColor(ccc3(93,72,41))
	self.feedback_box:setFontSize(1)
	self.feedback_box:setMaxLength(100)
	--self.feedback_ttf:setDimensions(CCSizeMake(460,160))
	
	set_anniu_1_3_stroke(self.commit_btn_lbl)
	
	local layer = createFullMubanStyleLayer()
	self:addChild(layer)
	layer:setTitle("wenzi_youxifankui.png")
	
	layer:setContent(node)
	scaleNode(self.rootNode, GlobalSetting.content_scale_factor)

end

function FeedbackScene:do_ui_commit_btn_clicked(tag, sender)
	print("[FeedbackScene:do_ui_commit_btn_clicked]")
	AppStats.event(UM_COMMIT_FEEDBACK)
	local feedback = trim_blank(self.feedback_box:getText())
	if is_blank(feedback) then
		self:show_message_box(strings.feedback_nil_w)
		return
	end
	self:show_progress_message_box(strings.feedback_ing)
	self:feedback(feedback)
end

function FeedbackScene:do_on_trigger_success(data)
	print("[InfoLayer:do_on_trigger_success]")
	self:hide_progress_message_box()
	
	self:show_message_box_suc(strings.feedback_s)
	
	Timer.add_timer(2, function()
			CCDirector:sharedDirector():popScene()
			end)

end

function FeedbackScene:do_on_trigger_failure(data)
	print("[InfoLayer:do_on_trigger_failure]")
	self:hide_progress_message_box()
	local msg = self.failure_msg
	if data.result_message then msg = data.result_message end
	self:show_message_box(msg)
	--		self.feedback_box:setText("")
	self.feedback_ttf:setString("重新输入")
	self.feedback_box:setText("重新输入")
end

UIControllerPlugin.bind(FeedbackScene)
HallServerConnectionPlugin.bind(FeedbackScene)
SceneEventPlugin.bind(FeedbackScene)