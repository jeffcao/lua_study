CheckBox = {}

CheckBox.create = function(name, plist_name, selected_image, unselected_image)
	name = name or ""
	plist_name = plist_name or Res.common_plist
	selected_image = selected_image or "kuang_c.png"
	unselected_image = unselected_image or "kuang_d.png"
	
	local cache = CCSpriteFrameCache:sharedSpriteFrameCache();
	cache:addSpriteFramesWithFile(plist_name)
	local selected_image = cache:spriteFrameByName(selected_image);
	local unselected_image = cache:spriteFrameByName(unselected_image);
	local unselected_menu = CCMenuItemImage:create()
	unselected_menu:setNormalSpriteFrame(unselected_image)
	local selected_menu = CCMenuItemImage:create()
	selected_menu:setNormalSpriteFrame(selected_image)
	
	local toggle = CCMenuItemToggle:create(unselected_menu)
	toggle:addSubItem(selected_menu)
	toggle:setScale(GlobalSetting.content_scale_factor)
	function toggle:isChecked()
		local result = self:getSelectedIndex() == 1
		return result
	end
	
	function toggle:setChecked(value)
		if not self:isChecked() == value then
			if value then
				self:setSelectedIndex(1)
			else
				self:setSelectedIndex(0)
			end
			
		end
	end
	toggle:setPosition(ccp(16,15))
	
	local  title = CCMenuItemFont:create(name)
	title:setFontSizeObj(22)
	title:setDisabledColor(ccc3(255,255,254))
    title:setEnabled(false)
    title:setPosition(ccp(80,15))
	
	local menu = CCMenu:create()
    menu:addChild(toggle)
    menu:setContentSize(CCSizeMake(32,30))
    menu:ignoreAnchorPointForPosition(false)
	menu:setAnchorPoint(ccp(0,0.5))
	
	menu:addChild(title)
	menu.toggle = toggle
	menu.title = title
	return menu
end
