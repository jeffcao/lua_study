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
	
	function theClass:do_ui_avatar_btn_clicked(tag, sender)
		self:doSetLayer("personal_info")
	end
	
	function theClass:do_ui_update_avatar_btn_clicked(tag, sender)
		self:doSetLayer("update_avatar")
	end
	
	function theClass:do_ui_update_pwd_btn_clicked()
		self:doSetLayer("update_password")
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
			layer = createInfoLayer()
		elseif name == "update_password" then
			layer = createUpdatePasswordLayer()
		else 
			layer = createAvatarListLayer()
		end
		
		self.container:addChild(layer)
		local container_size = self.container:getContentSize()
		layer:ignoreAnchorPointForPosition(false)
		layer:setAnchorPoint(ccp(0.5, 0.5))
		layer:setPosition(ccp(container_size.width/2, container_size.height/2))	
	end
end