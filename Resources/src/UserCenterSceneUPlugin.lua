require "InfoLayer"
require "UpdatePasswordLayer"
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
	
	function theClass:onCloseClick()
		self:doToHall()
	end
	
	function theClass:onAvatarClick()
		self:doSetLayer("personal_info")
	end
	
	function theClass:onUpdateAvatarClick()
		self:doSetLayer("update_avatar")
	end
	
	function theClass:onUpdatePswdClick()
		self:doSetLayer("update_password")
	end
	
	function theClass:doSetLayer(name)
		if self.current_layer == name then
			return
		end
		self.current_layer = name
		self.upload_pic:setVisible(not (name == "personal_info"))
		self.container:removeAllChildrenWithCleanup(true)
		local layer = nil
		if name == "personal_info"  then 
			layer = createInfoLayer()
		elseif name == "update_password" then
			layer = createUpdatePasswordLayer()
		else 
			layer = display.newLayer()
		end
		self.container:addChild(layer)
	end
end