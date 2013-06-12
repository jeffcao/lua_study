local json = require "cjson"
require "RegisterScene"
require "HallScene"
require "src.UIControllerPlugin"
require "src.LoginScenePlugin"
require "YesNoDialog2"

LoginScene = class("LoginScene", function()
	print("creating new loginScene")
	return display.newScene("LoginScene")
end)

user_token_chars = "-D-D-Z--"


function LoginScene:ctor()
	
	ccb.login_scene = self
	
	self.on_ui_register_clicked = __bind(self.onRegisterMenuClick, self)
	self.on_ui_fast_game_clicked = __bind(self.onKuaisuLoginBtnClick, self) 
	self.on_ui_login_clicked = __bind(self.onLoginBtnClick, self)
	self.on_ui_show_ids_clicked = __bind(self.onShowUsersBtnClick, self)
	
	local ccbproxy = CCBProxy:create()
	local node = CCBReaderLoad("LoginScene.ccbi", ccbproxy, false, "")
	self:addChild(node)
	scaleNode(self.rootNode, GlobalSetting.content_scale_factor)

	self:init_input_controll()
	
	self.rootNode:setKeypadEnabled(true)
	self.rootNode:registerScriptKeypadHandler( __bind(self.on_keypad_pressed, self) )

end

function LoginScene:init_input_controll()
	self.input_png = "xiankuang02.png"
	self:addEditbox(self.register_account_layer, 145, 35, false, 101)
	self:addEditbox(self.forget_password_layer, 165, 35, true, 102)
	
	local createUserIdMenue = function(lb_text)
		local menu_lb = CCLabelTTF:create(lb_text, "default",16)
		menu_lb:setColor(ccc3(0, 0, 0))
		
		local menu_item = CCMenuItemImage:create()
		menu_item:setNormalSpriteFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName("xiankuang02.png"))
		menu_item:setSelectedSpriteFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName("xiankuang01.png"))
		
		menu_item:setContentSize(CCSizeMake(170, 20))
		menu_item:setAnchorPoint(ccp(0, 0.5))
		menu_item:addChild(menu_lb, 999, 201)
		
		menu_lb:setAnchorPoint(ccp(0.5, 0.5))
		menu_lb:setPosition(ccp(25, 15))
		menu_item:registerScriptTapHandler(__bind(self.userIdMenuCallback, self))

		return menu_item
	end
	
--	local bg_sprite = self.ccbproxy:getNodeWithType("bg_sprite", "CCSprite")
	local pwd_bg_sprite = tolua.cast(self.pwd_bg_sprite, "CCScale9Sprite") --self.ccbproxy:getNodeWithType("pwd_bg_sprite", "CCScale9Sprite")
	local user_bg_sprite = tolua.cast(self.user_bg_sprite, "CCScale9Sprite") --self.ccbproxy:getNodeWithType("user_bg_sprite", "CCScale9Sprite")
	
	self.user_bg_sprite:setSpriteFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName("kuang_a.png"))
	self.pwd_bg_sprite:setSpriteFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName("kuang_a.png"))
	self.user_bg_sprite:setPreferredSize(CCSizeMake(220, 40))
	self.pwd_bg_sprite:setPreferredSize(CCSizeMake(220, 40))

--	local user_id_list_layer = self.ccbproxy:getNodeWithType("user_id_list_layer", "CCLayer")
--	local user_id_list_menu = self.ccbproxy:getNodeWithType("user_id_list_menu", "CCMenu")
	local user_id_list_sprite = tolua.cast(self.user_id_list_sprite, "CCScale9Sprite") --self.ccbproxy:getNodeWithType("user_id_list_sprite", "CCScale9Sprite")
	
	user_ids = UserInfo:get_all_user_ids(CCUserDefault:sharedUserDefault())
	self.user_id_list_layer:setContentSize(CCSizeMake(173, 23*#user_ids+15))
	self.user_id_list_sprite:setSpriteFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName("kuang_a.png"))
	self.user_id_list_sprite:setPreferredSize(CCSizeMake(173, 23*#user_ids+15))
	self.user_id_list_sprite:setAnchorPoint(ccp(0,0.5))

	if user_ids ~= nil then
		for _index, _user_id in pairs(user_ids) do
			self.user_id_list_menu:addChild(createUserIdMenue(_user_id), 999)
			print("[LoginScene:ctor()] add ueser id menu, user_id=>".._user_id)
		end
	end
	self.user_id_list_menu:alignItemsVerticallyWithPadding(2.5)
	self.user_id_list_menu:setPosition(ccp(3, self.user_id_list_layer:getContentSize().height / 2-5 ))
	self.user_id_list_sprite:setPosition(ccp(0, self.user_id_list_layer:getContentSize().height / 2 ))
	
	if GlobalSetting.current_user ~= nil then
		self:setUserInfo(GlobalSetting.current_user.user_id)
	end

end

function LoginScene:userIdMenuCallback(tag, sender)
		self.user_id_list_layer:setVisible(false)
		print(dump(sender, "callback sender", true))
		local user_id_item = tolua.cast(sender, "CCMenuItemImage")
		local user_id_label = tolua.cast(user_id_item:getChildByTag(201), "CCLabelTTF")
		local user_id = user_id_label:getString()
		print("[LoginScene:userIdMenuCallback()] user id: "..user_id)
		self:setUserInfo(user_id)
	end

function LoginScene:setUserInfo(user_id)
	print("[LoginScene:setUserInfo()]")
	local user = UserInfo:load_by_id(CCUserDefault:sharedUserDefault(), user_id)
	if is_blank(user.user_id) then
		return
	end
	
--	local register_account_layer = self.ccbproxy:getNodeWithType("register_account_layer", "CCLayer")
--	local forget_password_layer = self.ccbproxy:getNodeWithType("forget_password_layer", "CCLayer")
	
	local user_id_txt = tolua.cast(self.register_account_layer:getChildByTag(101), "CCEditBox")
	local user_pwd_txt = tolua.cast(self.forget_password_layer:getChildByTag(102), "CCEditBox")
	
	if user_id_txt ~= nil then
		user_id_txt:setText(user_id)
	end
	if user_pwd_txt ~= nil and not is_blank(user.login_token) then
		user_pwd_txt:setText(user_token_chars)
	end
end


function LoginScene:onShowUsersBtnClick(tag, sender)
	print("[LoginScene:onShowUsersBtnClick]")
--	local user_id_list_layer = self.ccbproxy:getNodeWithType("user_id_list_layer", "CCLayer")
--	print("[LoginScene:onShowUsersBtnClick] id list layer: "..user_id_list_layer)
	if self.user_id_list_layer:isVisible() then
		print("[LoginScene:onShowUsersBtnClick] set layer invisible")
		self.user_id_list_layer:setVisible(false)
	else
		print("[LoginScene:onShowUsersBtnClick] set layer visible")
		self.user_id_list_layer:setVisible(true)
	end
end

function LoginScene:onRegisterMenuClick(tag, sender)
		print("go to register in login scene")
		CCDirector:sharedDirector():replaceScene(createRegisterScene())	
	end

function LoginScene:onKuaisuLoginBtnClick()
	print("[LoginScene:onKuaisuLoginBtnClick()]")
	self:signup()
end

function LoginScene:onLoginBtnClick(tag, sender)
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
		self:show_message("请输入正确的账号，密码信息.")
		return
	end
	
	if user_pwd == user_token_chars then
		user = UserInfo:load_by_id(CCUserDefault:sharedUserDefault(), user_id)
		self:sign_in_by_token(user_id, user.login_token)
	else
		self:sign_in_by_password(user_id, user_pwd)
	end
end
	
function LoginScene:onEnter()
	print("[LoginScene:on_enter()]")
	self.super.onEnter(self)
	scaleNode(self.rootNode, GlobalSetting.content_scale_factor)
	self:connect_to_login_server(GlobalSetting)
end

function LoginScene:onExit()
	print("[LoginScene:on_exit()]")
end

function LoginScene:onCleanup()
	print("[LoginScene:onCleanup()]")
	self.super.onCleanup(self)

	if self.ccproxy then
		self.ccproxy:release()
	end
end

function LoginScene:on_keypad_pressed(key)
	print("on keypad clicked: " .. key)
	if key == "backClicked" then
		self:do_close()
	elseif key == "menuClicked" then
		--print("websocket state => ", WebsocketManager:sharedWebsocketManager():get_websocket_state(self.websocket._conn._websocket_id) )
	end 
end

function LoginScene:do_close()
	CCDirector:sharedDirector():endToLua()
end

UIControllerPlugin.bind(LoginScene)
LoginScenePlugin.bind(LoginScene)

function createLoginScene()
	print("createLoginScene()")
	local login = LoginScene.new()
	return login
end


function LoginScene:on_login_success()
	local hall = createHallScene()
	CCDirector:sharedDirector():replaceScene(hall)
end

function LoginScene:show_message(message)
	local dialogScene = createYesNoDialog2()
	dialogScene:setMessage(message)
	dialogScene:show()
--	CCDirector:sharedDirector():replaceScene(createRegisterScene())	
end



