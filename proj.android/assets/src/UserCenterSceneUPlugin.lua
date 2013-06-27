require "InfoLayer"
require "UpdatePasswordLayer"
require "AvatarListLayer"
UserCenterSceneUPlugin = {}

function UserCenterSceneUPlugin.bind(theClass)
	function theClass:onKeypad(key)
		if key == "backClicked" then
			self:doToHall()
		end
	end
	
	function theClass:doToHall()
		--local scene = createHallScene()
		CCDirector:sharedDirector():popScene()
	end
	
	function theClass:do_ui_close_btn_clicked(tag, sender)
		self:doToHall()
	end
	
	function theClass:set_title(tile_png)
		local title_sprite = tolua.cast(self.title_sprite, "CCSprite")
		title_sprite:setDisplayFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName(tile_png))
	end
	
	function theClass:do_ui_avatar_btn_clicked(tag, sender)
		self:set_title("biaoti02.png")
		self:doSetLayer("personal_info")
	end
	
	function theClass:do_ui_update_avatar_btn_clicked(tag, sender)
		self:set_title("biaoti04.png")
		self:doSetLayer("update_avatar")
	end
	
	function theClass:do_ui_update_pwd_btn_clicked()
		self:set_title("biaoti01.png")
		self:doSetLayer("update_password")
	end
	
	function theClass:do_player_cats_btn_clicked()
		self:set_title("biaoti03.png")
		self:doSetLayer("player_cats")
	end
	
	function theClass:init_controller()
		self:set_title("biaoti02.png")
		self:display_avatar()
		self:doSetLayer("personal_info")
	end
	
	function theClass:after_player_info_changed(data)
		print("[theClass:after_update_avatar] data => ", data)
		self:update_current_user(data)
		self:display_avatar()
		self.avatar_call_back(data)
	end

	
	function theClass:display_avatar()
	
		local avatar_btn = tolua.cast(self.avatar_btn, "CCMenuItemImage")
		local avatar_png = self:get_player_avatar_png_name()

		print("[HallSceneUPlugin:init_current_player_info] avatar_png: "..avatar_png)
		avatar_btn:setNormalSpriteFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName(avatar_png))
		avatar_btn:setSelectedSpriteFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName(avatar_png))
	end
	
	function theClass:update_current_user(user_info)
		GlobalSetting.current_user.nick_name = user_info.nick_name
		GlobalSetting.current_user.gender = user_info.gender
		GlobalSetting.current_user.avatar = user_info.avatar
	end
	
	
	function theClass:doSetLayer(name)
		if self.current_layer == name then
			return
		end
		self.current_layer = name
		self.upload_pic_sprite:setVisible(not (name == "personal_info"))
		self.container:removeAllChildrenWithCleanup(true)
		local layer = nil
		if name == "personal_info"  then 
			layer = createInfoLayer(__bind(self.after_player_info_changed, self))
		elseif name == "update_password" then
			layer = createUpdatePasswordLayer()
		elseif name == "player_cats" then
			layer = createPlayerProductsLayer()
		else 
			layer = createAvatarListLayer(__bind(self.after_player_info_changed, self))
		end
		
		self.container:addChild(layer)
		local container_size = self.container:getContentSize()
		layer:ignoreAnchorPointForPosition(false)
		layer:setAnchorPoint(ccp(0.5, 0.5))
		layer:setPosition(ccp(container_size.width/2, container_size.height/2))	
	end
end