local json = require "cjson"
require "src.UIControllerPlugin"

RegisterScene = class("RegisterScene", function()
	print("creating new RegisterScene")
	return display.newScene("RegisterScene")
end)

function RegisterScene:ctor()

	ccb.register_scene = self
	self.on_cancel_btn_clicked =  __bind(self.do_cancel_btn_clicked, self)
	self.on_register_btn_clicked = __bind(self.do_register_btn_clicked, self)
	
	local ccbproxy = CCBProxy:create()
	local node = CCBReaderLoad("RegisterScene.ccbi", ccbproxy, false, "")
	self:addChild(node)
	scaleNode(self.rootNode, GlobalSetting.content_scale_factor)
	
	self:init_input_controller()

	self.rootNode:setKeypadEnabled(true)
	self.rootNode:registerScriptKeypadHandler( __bind(self.on_keypad_pressed, self) )
end

function RegisterScene:init_input_controller()
	self.input_png = "kuang_a.png"
	self:addEditbox(self.nick_name_layer, 225, 30, false, 101)
	self:addEditbox(self.password_layer, 225, 30, true, 102)
	self:addEditbox(self.confirm_pwd_layer, 225, 30, true, 103)
	
	local male_on_sprite = CCSprite:createWithSpriteFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName("kuang_d.png"))
	local male_off_sprite = CCSprite:createWithSpriteFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName("kuang_c.png"))
	local male_on_btn = CCMenuItemSprite:create(male_on_sprite,nil)
	local male_off_btn = CCMenuItemSprite:create(male_off_sprite,nil)
	local male_item_toggle = CCMenuItemToggle:create(male_on_btn)
	male_item_toggle:addSubItem(male_off_btn)
	male_item_toggle:setSelectedIndex(1)
	male_item_toggle:registerScriptTapHandler(__bind(self.do_male_btn_clicked, self))
	self.gender_male_menu:addChild(male_item_toggle,0,2001)
	
	local female_on_sprite = CCSprite:createWithSpriteFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName("kuang_d.png"))
	local female_off_sprite = CCSprite:createWithSpriteFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName("kuang_c.png"))
	local female_on_btn = CCMenuItemSprite:create(female_on_sprite,nil)
	local female_off_btn = CCMenuItemSprite:create(female_off_sprite,nil)
	local female_item_toggle = CCMenuItemToggle:create(female_on_btn)
	female_item_toggle:registerScriptTapHandler(__bind(self.do_female_btn_clicked, self))
	female_item_toggle:addSubItem(female_off_btn)
	self.gender_female_menu:addChild(female_item_toggle,0,2001)
	 
end

function RegisterScene:do_male_btn_clicked(tag, sender)
	print("[RegisterScene:do_male_btn_clicked]")
	menu_toggle = tolua.cast(sender, "CCMenuItemToggle")
	local selectedIndex = menu_toggle:getSelectedIndex()
	if selectedIndex == 0 then
		menu_toggle:setSelectedIndex(1)
	else
		local femal_menu_toggle = tolua.cast(self.gender_female_menu:getChildByTag(2001), "CCMenuItemToggle")
		femal_menu_toggle:setSelectedIndex(0)
	end
	
end

function RegisterScene:do_female_btn_clicked(tag, sender)
	print("[RegisterScene:do_female_btn_clicked]")
	menu_toggle = tolua.cast(sender, "CCMenuItemToggle")
	local selectedIndex = menu_toggle:getSelectedIndex()
	if selectedIndex == 0 then
		menu_toggle:setSelectedIndex(1)
	else
		local male_menu_toggle = tolua.cast(self.gender_male_menu:getChildByTag(2001), "CCMenuItemToggle")
		male_menu_toggle:setSelectedIndex(0)
	end
end

function RegisterScene:do_cancel_btn_clicked(tag, sender)
		print("go to login in register scene")
		CCDirector:sharedDirector():replaceScene(createLoginScene())	
end

function RegisterScene:do_register_btn_clicked(tag, sender)
	print("[RegisterScene:do_register_btn_clicked]")
	local nick_name_box = tolua.cast(self.nick_name_layer:getChildByTag(101), "CCEditBox")
	local password_box = tolua.cast(self.password_layer:getChildByTag(102), "CCEditBox")
	local confirm_pwd_box = tolua.cast(self.confirm_pwd_layer:getChildByTag(103), "CCEditBox")
	local male_menu_toggle = tolua.cast(self.gender_male_menu:getChildByTag(2001), "CCMenuItemToggle")
	
	local nick_name = nick_name_box:getText()
	local password = password_box:getText()
	local confirm_pwd = confirm_pwd_box:getText()
	local gender = male_menu_toggle:getSelectedIndex() == 1 and 1 or 2
	
	if is_blank(nick_name) then
		print("[RegisterScene:do_register_btn_clicked] 昵称不能为空.")
		self:show_message_box("昵称不能为空")
		return
	end
	if is_blank(password) then
		print("[RegisterScene:do_register_btn_clicked] 密码不能为空.")
		self:show_message_box("密码不能为空")
		return
	end
	if password ~= confirm_pwd then
		print("[RegisterScene:do_register_btn_clicked] 两次密码输入不一致.")
		self:show_message_box("两次密码输入不一致")
		return
	end
	
	self:fast_sign_up(nick_name, password, gender)
	
end

function RegisterScene:do_on_login_success()
	print("[RegisterScene:do_on_login_success].")
	local hall = createHallScene()
	CCDirector:sharedDirector():replaceScene(hall)
end

function RegisterScene:do_on_login_failure()
	print("[RegisterScene:do_on_login_failure].")
	
end
	
function RegisterScene:onEnter()
	print("[RegisterScene:on_enter()]")
	self.super.onEnter(self)
	scaleNode(self.rootNode, GlobalSetting.content_scale_factor)
end

function RegisterScene:onExit()
	print("[RegisterScene:on_exit()]")
end

function RegisterScene:onCleanup()
	print("[RegisterScene:onCleanup()]")
	self.super.onCleanup(self)

	if self.ccproxy then
		self.ccproxy:release()
	end
end

function RegisterScene:on_keypad_pressed(key)
	print("on keypad clicked: " .. key)
	if key == "backClicked" then
		print("go to login in register scene")
		local login = createLoginScene()
		CCDirector:sharedDirector():replaceScene(login)
	elseif key == "menuClicked" then
		--print("websocket state => ", WebsocketManager:sharedWebsocketManager():get_websocket_state(self.websocket._conn._websocket_id) )
	end 
end

function RegisterScene:do_close()
	CCDirector:sharedDirector():endToLua()
end

UIControllerPlugin.bind(RegisterScene)
LoginServerConnectionPlugin.bind(RegisterScene)

function createRegisterScene()
	print("createRegisterScene()")
	local login = RegisterScene.new()
	return login
end

