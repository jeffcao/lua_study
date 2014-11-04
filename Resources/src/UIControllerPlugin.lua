require "src.WebsocketRails.Timer"
require 'src.ToastPlugin'
UIControllerPlugin = {}

function UIControllerPlugin.bind(theClass)

	function theClass:createEditbox(width, height, is_password)
		local cache = CCSpriteFrameCache:sharedSpriteFrameCache();
		cache:addSpriteFramesWithFile(Res.common2_plist)
		cache:addSpriteFramesWithFile(Res.common3_plist)
		
		local scale9_2 = nil
		if not self.direct then 
			scale9_2 = CCScale9Sprite:createWithSpriteFrameName(self.input_png)
		else 
			cclog('load 9sprite from direct dir')
			scale9_2 = CCScale9Sprite:create(self.input_png)
		end
		local editbox2 = CCEditBox:create(CCSizeMake(width,height), scale9_2)
		editbox2:setPosition(ccp(0,0))
		editbox2:setAnchorPoint(ccp(0,0))
		editbox2:setPlaceholderFont("default",16)
		editbox2:setFont("default",16)
		editbox2:setPlaceholderFontColor(ccc3(255, 255, 255))
		editbox2:setFontColor(ccc3(255, 255, 255))
		if is_password then
			editbox2:setInputFlag(kEditBoxInputFlagPassword)
		else
			editbox2:setInputFlag(kEditBoxInputFlagSensitive)
		end
		
		editbox2:setInputMode(kEditBoxInputModeSingleLine)
		editbox2:setReturnType(kKeyboardReturnTypeDone)
		editbox2:setText(" ")
		editbox2:setText("")
		return editbox2
	end
	
	function theClass:addEditbox(layer, width, height, is_password, tag)
		layer.editbox = self:createEditbox(width, height, is_password)
		layer:addChild(layer.editbox, 0, tag)
		return layer.editbox
	end
	
	function theClass:show_message_box_suc(message, params)
		ToastPlugin.show_message_box_suc(message, params)
	end
	
	function theClass:show_message_box(message, params)
		ToastPlugin.show_message_box(message, params)
	end
	
	function theClass:show_progress_message_box(message, msg_width, msg_height, z_order)
		ToastPlugin.show_progress_message_box(message, msg_width, msg_height)
	end
	
	function theClass:show_progress_message_no_create(message)
		ToastPlugin.show_progress_message_box(message)
	end
	
	function theClass:hide_progress_message_box()
		ToastPlugin.hide_progress_message_box()
	end
	
	function theClass:show_server_notify(message, type)
		ToastPlugin.show_server_notify(message, type)
	end
	
	function theClass:get_player_avatar_png_name()
		local cur_user = GlobalSetting.current_user
		local avatar_png_index = tonumber(cur_user.avatar) < 10 and "0"..cur_user.avatar or cur_user.avatar
		if tonumber(cur_user.avatar) == 101 then
			avatar_png_index = "00_m"
		elseif tonumber(cur_user.avatar) == 102 then
			avatar_png_index = "00_f"
		end
		local avatar_png_index_gender = tonumber(cur_user.gender) == 1 and "m" or "f"
		avatar_png_index = avatar_png_index == "00" and "00_"..avatar_png_index_gender or avatar_png_index
		local avatar_png = "touxiang"..avatar_png_index..".png"
		return "tx-xiaotu/"..avatar_png
	end
	
	function theClass:show_back_message_box(message)
		self.back_message_box = createBackMessageBoxLayer(self.rootNode)
		self.back_message_box:setMessage(message)
		self.back_message_box:show()
	end

	function theClass:do_on_buy_produce_message(data)
		print("[MarketSceneUPlugin:do_back_message_box]")
		
		--[[
		if GlobalSetting.run_env == 'test' then
			data.result_code = 2
			data.billingIndex = "010"
			data.cpparam = "5133301388036864"
			data.trade_num = "5133301388036864"
			data.prop_id = 186
		end
		]]
		
		if tonumber(data.result_code) == 2 then
			local billingIndex = data.billingIndex
			local cpparam = data.cpparam
			local trade_id = data.trade_num
			local prop_id = data.prop_id
			local params = billingIndex..'_'..cpparam..'_'..trade_id..'_'..prop_id
			print('retry billing...', params)
			local jni = DDZJniHelper:create()
			jni:messageJava('retry_billing_'..params)
			return
		end
		if self.matket_scene then
			print("[MarketSceneUPlugin:matket_scene:show_back_message_box]")
			self.matket_scene:show_back_message_box(data.content)
		else
			self:show_back_message_box(data.content)
		end
		
		if self.get_user_profile and self.display_player_info then
			self:get_user_profile()
			self.after_trigger_success = __bind(self.display_player_info, self)
		end
	end
	
	function theClass:check_tech_msg(moment)
		cclog("check_tech_msg "..moment)
		dump(GlobalSetting.teach_msg, "GlobalSetting.teach_msg=>")
		local teach = GlobalSetting.teach_msg[moment]
		if not (teach and teach.content) then
			cclog("do not introduce moment " .. moment)
			return
		end
		local scene = CCDirector:sharedDirector():getRunningScene()
		if not (scene and scene.rootNode) then
			cclog('check_tech_msg the running scene is null or has not root node')
			return
		end
		showIntroduce(moment, teach.content, scene.rootNode)
		GlobalSetting.teach_msg[moment] = nil
	end
	
end
