require "src.UIControllerPlugin"
require "src.DialogInterface"

InputMobile = class("InputMobile", function()
	print("new InputMobile")
	return display.newLayer("InputMobile")
end
)

function createInputMobile(confirm_func)
	print("create InputMobile")
	return InputMobile.new(confirm_func)
end

function InputMobile:ctor(confirm_func)
	ccb.InputMobile = self
	self.on_commit_clicked = __bind(self.do_commit, self)
	local ccbproxy = CCBProxy:create()
 	CCBReaderLoad("InputMobile.ccbi", ccbproxy, true, "InputMobile")
	self:addChild(self.rootNode)
	self.confirm_func = confirm_func
	set_green_stroke(self.commit_btn_lbl)
	
	self:init_input_controller()
	scaleNode(self.rootNode, GlobalSetting.content_scale_factor)
end

function InputMobile:do_commit()
	print('do_commit')
	local mobile = self.mobile_box:getText()
	if not self:is_mobile(mobile) then
		self.mobile_box:setText('')
		ToastPlugin.show_message_box(strings.im_mobile_err)
		return
	end
	cclog('mobile is %s', mobile)
	self.confirm_func(mobile)
	self:dismiss()
end

function InputMobile:is_mobile(mobile)
	if is_blank(mobile) then return false end
	regxp = '^[1][3-8]%d%d%d%d%d%d%d%d%d'
	return string.find(mobile, regxp)
end

function InputMobile:init_input_controller()
	print("[InputMobile:init_input_controller]")
	self.input_png = "kuang_a.png"
	self.mobile_box = self:addEditbox(self.mobile_box_layer, 225, 40, false, 101)
	self.mobile_box:setMaxLength(11)
	self.mobile_box:setPlaceHolder("输入11位手机号码")
	self.mobile_box:setFontColor(ccc3(255,255,255))
	self.mobile_box:setFontSize(18)
	self.mobile_box:setInputMode(kEditBoxInputModePhoneNumber)
	
	local menus = CCArray:create()
	menus:addObject(self.commit_btn_menu)
	menus:addObject(self.mobile_box)
	menus:addObject(self.rootNode)
	self:setVisible(false)
	self:swallowOnTouch(menus)
	self:swallowOnKeypad()
end

UIControllerPlugin.bind(InputMobile)
DialogInterface.bind(InputMobile)