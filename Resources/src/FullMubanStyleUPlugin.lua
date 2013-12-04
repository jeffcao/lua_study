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
		local cache = CCSpriteFrameCache:sharedSpriteFrameCache()
		cache:addSpriteFramesWithFile(plist_name)
		local frame = cache:spriteFrameByName(sprite_frame)
		assert(frame, "muban set title, frame is null")
		self.title:setDisplayFrame(frame)
	end

	function theClass:setOnClose(fn)
		self.close:registerScriptTapHandler(fn)
	end
	
	function theClass:setOnBackClicked(fn)
		local keypad_fn = function(key)
			if key == "backClicked" then
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