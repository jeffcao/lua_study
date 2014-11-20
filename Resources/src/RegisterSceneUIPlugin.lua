require 'src.AppStats'

RegisterSceneUIPlugin = {}

function RegisterSceneUIPlugin.bind(theClass)
	
	function theClass:init_input_controller()
		self.input_png = "touming.png"
		self.name_box = self:addEditbox(self.nick_name_layer, 160, 30, false, 101)
		self.name_box:setPlaceHolder("昵称为不大于10位的任意字符")
		self.name_box:setMaxLength(10)
		self.pwd_box = self:addEditbox(self.password_layer, 160, 30, true, 102)
		self.pwd_box:setPlaceHolder("密码为8到20位的任意字符")
		self.pwd_box:setMaxLength(20)
		self.c_pwd_box = self:addEditbox(self.confirm_pwd_layer, 160, 30, true, 103)
		self.c_pwd_box:setMaxLength(20)
		self.c_pwd_box:setPlaceHolder("再次输入密码")
		
		local male_on_sprite = CCSprite:createWithSpriteFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName("kuang_d.png"))
		male_on_sprite:setScale(GlobalSetting.content_scale_factor)
		local male_off_sprite = CCSprite:createWithSpriteFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName("kuang_c.png"))
		male_off_sprite:setScale(GlobalSetting.content_scale_factor)
		local male_on_btn = CCMenuItemSprite:create(male_on_sprite,nil)
		local male_off_btn = CCMenuItemSprite:create(male_off_sprite,nil)
		self.male_item_toggle = CCMenuItemToggle:create(male_on_btn)
		self.male_item_toggle:addSubItem(male_off_btn)
		self.male_item_toggle:setSelectedIndex(1)
		self.male_item_toggle:registerScriptTapHandler(__bind(self.do_male_btn_clicked, self))
		self.gender_male_menu:addChild(self.male_item_toggle,0,201)
		
		local female_on_sprite = CCSprite:createWithSpriteFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName("kuang_d.png"))
		female_on_sprite:setScale(GlobalSetting.content_scale_factor)
		local female_off_sprite = CCSprite:createWithSpriteFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName("kuang_c.png"))
		female_off_sprite:setScale(GlobalSetting.content_scale_factor)
		local female_on_btn = CCMenuItemSprite:create(female_on_sprite,nil)
		local female_off_btn = CCMenuItemSprite:create(female_off_sprite,nil)
		self.female_item_toggle = CCMenuItemToggle:create(female_on_btn)
		self.female_item_toggle:registerScriptTapHandler(__bind(self.do_female_btn_clicked, self))
		self.female_item_toggle:addSubItem(female_off_btn)
		self.gender_female_menu:addChild(self.female_item_toggle,0,201)

		 
	end
	
	function theClass:do_male_btn_clicked(tag, sender)
		print("[RegisterScene:do_male_btn_clicked]")
		menu_toggle = tolua.cast(sender, "CCMenuItemToggle")
		local selectedIndex = menu_toggle:getSelectedIndex()
		if selectedIndex == 0 then
			menu_toggle:setSelectedIndex(1)
		else
			local femal_menu_toggle = tolua.cast(self.gender_female_menu:getChildByTag(201), "CCMenuItemToggle")
			femal_menu_toggle:setSelectedIndex(0)
		end
		
	end
	
	function theClass:do_female_btn_clicked(tag, sender)
		print("[RegisterScene:do_female_btn_clicked]")
		menu_toggle = tolua.cast(sender, "CCMenuItemToggle")
		local selectedIndex = menu_toggle:getSelectedIndex()
		if selectedIndex == 0 then
			menu_toggle:setSelectedIndex(1)
		else
			local male_menu_toggle = tolua.cast(self.gender_male_menu:getChildByTag(201), "CCMenuItemToggle")
			male_menu_toggle:setSelectedIndex(0)
		end
	end
	
	function theClass:do_cancel_btn_clicked(tag, sender)
			print("go to login in register scene")
--			CCDirector:sharedDirector():replaceScene(createLoginScene())
			 CCDirector:sharedDirector():popScene()	
	end
	
	function theClass:do_register_btn_clicked(tag, sender)
		print("[RegisterScene:do_register_btn_clicked]")
		AppStats.event(UM_COMMIT_SIGN_UP)
		local nick_name_box = tolua.cast(self.nick_name_layer:getChildByTag(101), "CCEditBox")
		local password_box = tolua.cast(self.password_layer:getChildByTag(102), "CCEditBox")
		local confirm_pwd_box = tolua.cast(self.confirm_pwd_layer:getChildByTag(103), "CCEditBox")
		local male_menu_toggle = tolua.cast(self.gender_male_menu:getChildByTag(201), "CCMenuItemToggle")
		
		local nick_name = nick_name_box:getText()
		local password = password_box:getText()
		local confirm_pwd = confirm_pwd_box:getText()
		local gender = male_menu_toggle:getSelectedIndex() == 1 and 1 or 2
		
		if is_blank(nick_name) then
			print("[RegisterScene:do_register_btn_clicked] 昵称不能为空.")
			self:show_message_box(strings.rsp_nick_name_nil_w)
			return
		end
		if is_blank(password) then
			print("[RegisterScene:do_register_btn_clicked] 密码不能为空.")
			self:show_message_box(strings.rsp_pswd_nil_w)
			return
		end
		if #password < 8 then
		self:show_message_box(strings.rsp_pswd_formt_w)
		return
	end
		if password ~= confirm_pwd then
			print("[RegisterScene:do_register_btn_clicked] 两次密码输入不一致.")
			self:show_message_box(strings.rsp_two_pswd_not_same_w)
			return
		end
		self:show_progress_message_box(strings.rsp_register_ing)
		self:fast_sign_up(nick_name, password, gender)
		
	end

	
	function theClass:on_keypad_pressed(key)
		print("on keypad clicked: " .. key)
		if hasDialogFloating(self) then print("regist scene there is dialog floating") return end
		if key == "back" then
			print("go to login in register scene")
--			local login = createLoginScene()
--			CCDirector:sharedDirector():replaceScene(login)
			CCDirector:sharedDirector():popScene()	
		elseif key == "menuClicked" then
			--print("websocket state => ", WebsocketManager:sharedWebsocketManager():get_websocket_state(self.websocket._conn._websocket_id) )
		end 
	end
	
	function theClass:do_on_websocket_ready()
		self:hide_progress_message_box()
	end
	
	function theClass:do_on_login_success()
		print("[RegisterScene:do_on_login_success()]")
		self:hide_progress_message_box()
		
		self:show_progress_message_box(strings.rsp_connect_hall_ing)
		Timer.add_timer(3, function()
			local hall = createHallScene()
			CCDirector:sharedDirector():replaceScene(hall)
			end)
	end
	
	function theClass:do_on_login_failure(data)
		self:hide_progress_message_box()
		local msg = strings.rsp_register_w
		if data.result_message then msg = data.result_message end
		self:show_message_box(msg)
		self:clear_input()
	end
	
	function theClass:clear_input()
		self.name_box:setText("")
		self.pwd_box:setText("")
		self.c_pwd_box:setText("")
		self.male_item_toggle:setSelectedIndex(1)
		self.female_item_toggle:setSelectedIndex(0)
	end

end