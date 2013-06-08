local json = require "cjson"
require "RegisterScene"
require "src.LoginScenePlugin"

LoginScene = class("LoginScene", function()
	print("creating new loginScene")
	return display.newScene("LoginScene")
end)

user_token_chars = "-D-D-Z--"




function LoginScene:ctor()
	
	self.ccbproxy = CCBProxy:create()
	self.ccbproxy:retain()
	
	local node = self.ccbproxy:readCCBFromFile("LoginScene.ccbi")
	assert(node, "failed to load login scene")
	self.rootNode = tolua.cast(node, "CCLayer")
	print("self.rootNode ==> ", self.rootNode)
	self:addChild(self.rootNode)
	
	
	self:init_input_controll()
	self.register_menu = self.ccbproxy:getNodeWithType("register_account_btn", "CCMenuItemImage")
	self.register_menu:registerScriptTapHandler(__bind(self.onRegisterMenuClick, self))
	
	self.kuaisu_login_menu = self.ccbproxy:getNodeWithType("kuaisu_login_btn", "CCMenuItemImage")
	self.kuaisu_login_menu:registerScriptTapHandler(__bind(self.onKuaisuLoginBtnClick, self) )
	
	self.login_menu = self.ccbproxy:getNodeWithType("login_btn", "CCMenuItemImage")
	self.login_menu:registerScriptTapHandler(__bind(self.onLoginBtnClick, self) )
	
	self.show_users_btn = self.ccbproxy:getNodeWithType("user_ids_btn", "CCMenuItemImage")
	self.show_users_btn:registerScriptTapHandler( __bind(self.onShowUsersBtnClick, self) )
	
	self.rootNode:setKeypadEnabled(true)
	self.rootNode:registerScriptKeypadHandler( __bind(self.on_keypad_pressed, self) )

end

function LoginScene:init_input_controll()

	local createEditbox = function(width, is_password)
		local cache = CCSpriteFrameCache:sharedSpriteFrameCache();
		cache:addSpriteFramesWithFile(Res.common_plist)
		
		local scale9_2 = CCScale9Sprite:createWithSpriteFrameName("kuang_a.png")
		local editbox2 = CCEditBox:create(CCSizeMake(width,35), scale9_2)
		editbox2:setPosition(ccp(0,0))
		editbox2:setAnchorPoint(ccp(0,0))
		editbox2:setPlaceholderFont("default",16)
		editbox2:setFont("default",16)
		editbox2:setFontColor(ccc3(0, 0, 0))
--		editbox2:setPlaceHolder("那一刻的风情")
		if is_password then
			editbox2:setInputFlag(kEditBoxInputFlagPassword)
		end
		return editbox2
	end
	
	local add_editbox = function(layer, width, is_password, tag)
		layer.editbox = createEditbox(width, is_password)
		layer:addChild(layer.editbox, 0, tag)
	end
	
	local register_account_layer = self.ccbproxy:getNodeWithType("register_account_layer", "CCLayer")
	add_editbox(register_account_layer, 145, false, 1001)
	
	local forget_password_layer = self.ccbproxy:getNodeWithType("forget_password_layer", "CCLayer")
	add_editbox(forget_password_layer, 170, true, 1002)
	
	local function userIdMenuCallback(tag, sender)
		local user_id_list_layer = self.ccbproxy:getNodeWithType("user_id_list_layer", "CCLayerColor")
		user_id_list_layer:setVisible(false)
		print(dump(sender, "callback sender", true))
		local user_id_item = tolua.cast(sender, "CCMenuItemLabel")
		local user_id_label = tolua.cast(user_id_item:getLabel(), "CCLabelTTF")
		local user_id = user_id_label:getString()
		print("[LoginScene:userIdMenuCallback()] user id: "..user_id)
		self:setUserInfo(user_id)
	end
	
	local createUserIdMenue = function(lb_text)
		local menu_lb = CCLabelTTF:create()
		menu_lb:setString(lb_text)
		
		local lb_menu_item = CCMenuItemLabel:create(menu_lb)
		lb_menu_item:setAnchorPoint(ccp(0, 0.5))
		lb_menu_item:setColor(ccc3(0, 0, 0))
		lb_menu_item:registerScriptTapHandler(userIdMenuCallback)
		return lb_menu_item
	end
	local user_id_list_layer = self.ccbproxy:getNodeWithType("user_id_list_layer", "CCLayerColor")
	local user_id_list_menu = self.ccbproxy:getNodeWithType("user_id_list_menu", "CCMenu")
	user_ids = UserInfo:get_all_user_ids(CCUserDefault:sharedUserDefault())
	user_id_list_layer:setContentSize(CCSizeMake(140, 20*#user_ids+15))
	
	local menu_old_p_x = user_id_list_menu:getPositionX()
	local menu_old_p_y = user_id_list_menu:getPositionY()
	print("[LoginScene:init_input_controll] id_list_menu_old_p.x: "..menu_old_p_x.." y: "..menu_old_p_y)

	if user_ids ~= nil then
		for _index, _user_id in pairs(user_ids) do
			user_id_list_menu:addChild(createUserIdMenue(_user_id), 999)
			print("[LoginScene:ctor()] add ueser id menu, user_id=>".._user_id)
		end
	end
	user_id_list_menu:alignItemsVerticallyWithPadding(5)
	menu_old_p_x = user_id_list_menu:getPositionX()
	menu_old_p_y = user_id_list_menu:getPositionY()
	print("[LoginScene:init_input_controll] new id_list_menu_old_p.x: "..menu_old_p_x.." y: "..menu_old_p_y)
	user_id_list_menu:setPosition(ccp(3, user_id_list_layer:getContentSize().height / 2 ))
	
	if GlobalSetting.current_user ~= nil then
		self:setUserInfo(GlobalSetting.current_user.user_id)
	end

end



function LoginScene:setUserInfo(user_id)
	print("[LoginScene:setUserInfo()]")
	local user = UserInfo:load_by_id(CCUserDefault:sharedUserDefault(), user_id)
	if is_blank(user.user_id) then
		return
	end
	
	local register_account_layer = self.ccbproxy:getNodeWithType("register_account_layer", "CCLayer")
	local forget_password_layer = self.ccbproxy:getNodeWithType("forget_password_layer", "CCLayer")
	
	local user_id_txt = tolua.cast(register_account_layer:getChildByTag(1001), "CCEditBox")
	local user_pwd_txt = tolua.cast(forget_password_layer:getChildByTag(1002), "CCEditBox")
	
	if user_id_txt ~= nil then
		user_id_txt:setText(user_id)
	end
	if user_pwd_txt ~= nil and not is_blank(user.login_token) then
		user_pwd_txt:setText(user_token_chars)
	end
end


function LoginScene:onShowUsersBtnClick()
	print("[LoginScene:onShowUsersBtnClick]")
	local user_id_list_layer = self.ccbproxy:getNodeWithType("user_id_list_layer", "CCLayerColor")
--	print("[LoginScene:onShowUsersBtnClick] id list layer: "..user_id_list_layer)
	if user_id_list_layer:isVisible() then
		print("[LoginScene:onShowUsersBtnClick] set layer invisible")
		user_id_list_layer:setVisible(false)
	else
		print("[LoginScene:onShowUsersBtnClick] set layer visible")
		user_id_list_layer:setVisible(true)
	end
end

function LoginScene:onRegisterMenuClick()
		print("go to register in login scene")
		CCDirector:sharedDirector():replaceScene(createRegisterScene())	
	end

function LoginScene:onKuaisuLoginBtnClick()
	print("[LoginScene:onKuaisuLoginBtnClick()]")
	self:signup()
end

function LoginScene:onLoginBtnClick()
	print("[LoginScene:onLoginBtnClick()]")
	local register_account_layer = self.ccbproxy:getNodeWithType("register_account_layer", "CCLayer")
	local forget_password_layer = self.ccbproxy:getNodeWithType("forget_password_layer", "CCLayer")
	
	local user_id_txt = tolua.cast(register_account_layer:getChildByTag(1001), "CCEditBox")
	local user_pwd_txt = tolua.cast(forget_password_layer:getChildByTag(1002), "CCEditBox")
	
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

LoginScenePlugin.bind(LoginScene)

function createLoginScene()
	print("createLoginScene()")
	local login = LoginScene.new()
	return login
end



