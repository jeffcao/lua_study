LoginSceneUIPlugin = {}

function LoginSceneUIPlugin.bind(theClass)
		
	function theClass:init_input_controll()
		self.input_png = "xiankuang02.png"
		self:addEditbox(self.register_account_layer, 145, 35, false, 101)
		self:addEditbox(self.forget_password_layer, 165, 35, true, 102)
		
		local createUserIdMenue = function(lb_text)
			local menu_lb = CCLabelTTF:create(lb_text, "default",16)
			menu_lb:setColor(ccc3(0, 0, 0))
			
			local menu_item = CCMenuItemLabel:create(menu_lb)

			menu_item:setContentSize(CCSizeMake(168, 22))
			menu_item:setAnchorPoint(ccp(0, 0.5))

			menu_item:registerScriptTapHandler(__bind(self.do_user_id_selected, self))
	
			return menu_item
		end
	
		local pwd_bg_sprite = tolua.cast(self.pwd_bg_sprite, "CCScale9Sprite") 
		local user_bg_sprite = tolua.cast(self.user_bg_sprite, "CCScale9Sprite") 
		
		self.user_bg_sprite:setSpriteFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName("kuang_a.png"))
		self.pwd_bg_sprite:setSpriteFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName("kuang_a.png"))
		self.user_bg_sprite:setPreferredSize(CCSizeMake(220, 40))
		self.pwd_bg_sprite:setPreferredSize(CCSizeMake(220, 40))
	
		local user_id_list_sprite = tolua.cast(self.user_id_list_sprite, "CCScale9Sprite")
		
		user_ids = UserInfo:get_all_user_ids(CCUserDefault:sharedUserDefault())
		self.user_id_list_layer:setContentSize(CCSizeMake(173, 23*#user_ids+15))
		self.user_id_list_sprite:setSpriteFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName("kuang_a.png"))
		self.user_id_list_sprite:setPreferredSize(CCSizeMake(173, 23*#user_ids+15))
		self.user_id_list_sprite:setAnchorPoint(ccp(0,0.5))
	
		if user_ids ~= nil then
			for _index, _user_id in pairs(user_ids) do
				self.user_id_list_menu:addChild(createUserIdMenue(_user_id), 999)
			end
		end
		self.user_id_list_menu:alignItemsVerticallyWithPadding(2.5)
		self.user_id_list_menu:setPosition(ccp(3, self.user_id_list_layer:getContentSize().height / 2-5 ))
		self.user_id_list_sprite:setPosition(ccp(0, self.user_id_list_layer:getContentSize().height / 2 ))
		
		dump(GlobalSetting.current_user, "[LoginScene:init_input_controll()] current_user")
		if GlobalSetting.current_user ~= nil then
			self:setUserInfo(GlobalSetting.current_user.user_id)
		end
	
	end
	
	function theClass:do_user_id_selected(tag, sender)
		self.user_id_list_layer:setVisible(false)
		print(dump(sender, "callback sender", true))
--		local user_id_item = tolua.cast(sender, "CCMenuItemImage")
		local user_id_item = tolua.cast(sender, "CCMenuItemLabel")
--		local user_id_label = tolua.cast(user_id_item:getChildByTag(201), "CCLabelTTF")
		local user_id_label = tolua.cast(user_id_item:getLabel(), "CCLabelTTF")
		local user_id = user_id_label:getString()
		print("[LoginScene:do_user_id_selected()] user id: "..user_id)
		self:setUserInfo(user_id)
	end
	
	function theClass:setUserInfo(user_id)
		print("[LoginScene:setUserInfo()]")
		local user = UserInfo:load_by_id(CCUserDefault:sharedUserDefault(), user_id)
		if is_blank(user.user_id) then
			return
		end
		
		local user_id_txt = tolua.cast(self.register_account_layer:getChildByTag(101), "CCEditBox")
		local user_pwd_txt = tolua.cast(self.forget_password_layer:getChildByTag(102), "CCEditBox")
		
		if user_id_txt ~= nil then
			user_id_txt:setText(user_id)
		end
		if user_pwd_txt ~= nil and not is_blank(user.login_token) then
			user_pwd_txt:setText(user_token_chars)
		end
	end
	
	
	function theClass:do_ui_show_ids_clicked(tag, sender)
		print("[LoginScene:onShowUsersBtnClick]")
	
		if self.user_id_list_layer:isVisible() then
			print("[LoginScene:onShowUsersBtnClick] set layer invisible")
			self.user_id_list_layer:setVisible(false)
		else
			print("[LoginScene:onShowUsersBtnClick] set layer visible")
			self.user_id_list_layer:setVisible(true)
		end
	end
	
	function theClass:do_ui_register_clicked(tag, sender)
			print("go to register in login scene")
			CCDirector:sharedDirector():pushScene(createRegisterScene())
--			CCDirector:sharedDirector():replaceScene(createRegisterScene())	
		end
	
	function theClass:do_ui_fast_game_clicked()
		print("[LoginScene:onKuaisuLoginBtnClick()]")
		self:show_progress_message_box("注册用户...")
		self:signup()
	end
	
	function theClass:do_ui_login_clicked(tag, sender)
		print("[LoginScene:onLoginBtnClick()]")
	
		local user_id_txt = tolua.cast(self.register_account_layer:getChildByTag(101), "CCEditBox")
		local user_pwd_txt = tolua.cast(self.forget_password_layer:getChildByTag(102), "CCEditBox")
		
		local user_id = ""
		local user_pwd = ""
		if user_id_txt ~= nil then
			user_id = user_id_txt:getText()
		end
		if user_pwd_txt ~= nil then
			user_pwd = user_pwd_txt:getText()
		end
		
		if is_blank(user_id) or is_blank(user_pwd) or #user_id ~= 5 or #user_pwd < 8 then
			print("请输入正确的账号，密码信息.")
			self:show_message_box("请输入正确的账号，密码信息")
			return
		end
		self:show_progress_message_box("登录大厅服务器...")
		if user_pwd == user_token_chars then
			user = UserInfo:load_by_id(CCUserDefault:sharedUserDefault(), user_id)
			self:sign_in_by_token(user_id, user.login_token)
		else
			self:sign_in_by_password(user_id, user_pwd)
		end
	end
	
	function theClass:do_on_login_success()
		print("[LoginScene:do_on_login_success()]")
		self:hide_progress_message_box()
		if GlobalSetting.hall_server_websocket ~= nil then
			GlobalSetting.hall_server_websocket:close()
			GlobalSetting.hall_server_websocket = nil
		end
		self:do_connect_hall_server()
	end
	
	function theClass:enter_hall()
		local game = createHallScene()
		CCDirector:sharedDirector():replaceScene(game)
		self:close_login_websocket()
	end
	
	function theClass:do_on_login_failure()
		self:hide_progress_message_box()
		self:show_message_box("登录失败")
		
	end
	
	function theClass:do_on_websocket_ready()
		self:hide_progress_message_box()
	end
	
	function theClass:do_on_connection_failure()
		print("[LoginScene:do_on_connection_failure()]")
		self:hide_progress_message_box()
		self:show_message_box("连接服务器失败")
	end
	
	function theClass:do_on_connection_hall_server_failure()
		print("[LoginScene:do_on_connection_hall_server_failure()]")
		self:hide_progress_message_box()
		self:show_message_box("连接大厅服务器失败")
	end
	
	function theClass:show_message(message)
		local dialogScene = createYesNoDialog2()
		dialogScene:setMessage(message)
		dialogScene:show()
	--	CCDirector:sharedDirector():replaceScene(createRegisterScene())	
	end
end