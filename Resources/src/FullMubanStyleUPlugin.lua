FullMubanStyleUPlugin = {}

function FullMubanStyleUPlugin.bind(theClass)

	function theClass:setContent(layer)
		self:addChild(layer)
	end
	
	function theClass:getRightMenu()
		return self.right_menu
	end
	
	function theClass:setTitle(sprite_frame, plist_name)
		plist_name = plist_name or Res.common_plist
		local plist_name2 = Res.geren_ziliao_plist
		local plist_name3 = Res.ui_wenzi_plist
		local cache = CCSpriteFrameCache:sharedSpriteFrameCache()
		cache:addSpriteFramesWithFile(plist_name)
		
		cache:addSpriteFramesWithFile(plist_name2)
		cache:addSpriteFramesWithFile(plist_name3)

		local frame = cache:spriteFrameByName(sprite_frame)
		assert(frame, "muban set title, frame is null")
		self.title:setDisplayFrame(frame)
	end
	
	function theClass:setTitleLeft()
		self.title_layer:setPosition(ccp(168,480))
		self.title_sprite:setPosition(ccp(91,18))
	end
	
	function theClass:setMenuDown()
		self.menu_layer:setPosition(ccp(7,338))
	end
	
	function theClass:setContentBbSize(b_width, b_height)
		self.sp_content_bg:setContentSize(CCSizeMake(b_width, b_height))
	end
	
	function theClass:showTitleBg()
		self.title_bg:setVisible(true)
	end
	
	function theClass:setDecorationHuawen()
	end
	
	function theClass:removeRepeatBg()
		self.rootNode:removeChildByTag(23, true)
	end

	function theClass:setOnClose(fn)
		self.close:registerScriptTapHandler(fn)
	end
	
	function theClass:setOnBackClicked(fn)
		local keypad_fn = function(key)
			if key == "back" then
				print("muban style on back clicked")
				if hasDialogFloating(self) then print "there is dialog floating" return end
				fn()
			end
		end
		self:setKeypadEnabled(true)
		self:registerScriptKeypadHandler(keypad_fn)
	--	self.rootNode:setKeypadEnabled(true)
	--	self.rootNode:registerScriptKeypadHandler(keypad_fn)
	end
end