require "src.HallSceneUPlugin"
require "RoomItem"
require "Menu"
require "src.WidgetPlugin"

HallScene = class("HallScene", function() 
	print("create new hall scene")
	return display.newScene("HallScene")
	end
 )
 
 function createHallScene()
 	print("createHallScene()")
 	return HallScene.new()
 end
 
 HallSceneUPlugin.bind(HallScene)
 WidgetPlugin.bind(HallScene)
 
 function HallScene:ctor()
 	self.ccbproxy = CCBProxy:create()
 	self.ccbproxy:retain()
 	
 	local node = self.ccbproxy:readCCBFromFile("HallScene.ccbi")
	assert(node, "failed to load hall scene")
	self.rootNode = tolua.cast(node, "CCLayer")
	scaleNode(self.rootNode, GlobalSetting.content_scale_factor)
	self:addChild(self.rootNode)
	self.room_layer = self.ccbproxy:getNode("room_layer")
	assert(self.room_layer, "room_layer is null")
	self.avatar_item = self.ccbproxy:getNodeWithType("avatar_btn", "CCMenuItemImage")
	self.avatar_item:setScale(GlobalSetting.content_scale_factor * 0.45)
	
	self.menu = self.ccbproxy:getNodeWithType("menu_btn", "CCMenuItemImage")
	self.menu:registerScriptTapHandler(__bind(self.onMenuClick, self))
	
	self.avatar_btn = self.ccbproxy:getNodeWithType("avatar_btn", "CCMenuItemImage")
	self.info_btn = self.ccbproxy:getNodeWithType("info_btn", "CCMenuItemImage")
	self.info_btn:registerScriptTapHandler(__bind(self.onInfoClick, self))
	self.avatar_btn:registerScriptTapHandler(__bind(self.onAvatarClick, self))
	
	self.rootNode:setKeypadEnabled(true)
	self.rootNode:registerScriptKeypadHandler(__bind(self.onKeypad, self))
	
	self.market_btn = self.ccbproxy:getNodeWithType("market_btn", "CCMenuItemImage")
	self.market_btn:registerScriptTapHandler(__bind(self.onMarketClick, self))
	
	local mysprite = MySprite:createMS("btn_bujiao.png")
	self.rootNode:addChild(tolua.cast(mysprite, "CCNode"))
	
	--local editbox = CCEditBoxBridge:create(Res.common_plist, "kuang_a.png", 320, 50)
	--editbox:addTo(tolua.cast(self.rootNode, "CCNode"), 400, 120)
	local editbox = self:createEditBoxOn(self.rootNode, 400, 120)
	editbox:setHintSize(10)
	editbox:setText("hfdkahfla")
	editbox:setTextSize(40)
	editbox:setTextColor(255,0,0)
	editbox:setMaxLength(10)
	editbox:setInputFlag(0)
	local tx = editbox:getText()
	print("tx is " .. tx)
	editbox:registerOnTextChange(function(before_text, cur_text)
		print("tx change from " .. before_text .. " to " .. cur_text)
	end)
 end
 

 
 --[[
 function HallScene:onMenuClick(tag)
 	local menu = createMenu()
 	self.rootNode.addChild(menu)
 end
 ]]
 
 function HallScene:onEnter() 
	local data = {}
	for i = 1, 10 do
		table.insert(data, "Data 3"..i) end
	--
		
	-- @param fn string Callback type
	-- @param table LuaTableView
	-- @param a1 & a2 mixed Difference means for every "fn"
	local h = LuaEventHandler:create(function(fn, table, a1, a2)
			print("lua event handler")
		local r
		print("lua event handler1")
		if fn == "cellSize" then
			-- Return cell size
			r = CCSizeMake(260,260)
			print("lua event handler2")
		elseif fn == "cellAtIndex" then
			-- Return CCTableViewCell, a1 is cell index (zero based), a2 is dequeued cell (maybe nil)
			-- Do something to create cell and change the content
			if not a2 then
				a2 = CCTableViewCell:create()
				a3 = createRoomItem()
				--a3 = CCBProxy:create():readCCBFromFile("RoomItem.ccbi")
				-- Build cell struct, just like load ccbi or add sprite
				local lbl = CCLabelTTF:create("", "Arial", 20)
					lbl:setAnchorPoint(ccp(0,0))
					lbl:setPosition(ccp(0,0))
				a2:addChild(a3, 0, 1)
				print("lua event handler3")
			end
			-- Change content
			--tolua.cast(a2:getChildByTag(1), "CCLabelTTF"):setString(data[a1 + 1])
			r = a2
			print("lua event handler4")
		elseif fn == "numberOfCells" then
			-- Return number of cells
			r = #data
			print("lua event handler5")
		elseif fn == "cellTouched" then
			-- A cell was touched, a1 is cell that be touched. This is not necessary.
			print("lua event handler6")
		end
		print("lua event handler7")
		return r
	end)
	print("h is:")
	print(h)
	local t = LuaTableView:createWithHandler(h, CCSizeMake(800,480))
	t:setDirection(kCCScrollViewDirectionHorizontal)
	t:reloadData()
	print("t is:")
	print(t)
	t:setPosition(CCPointMake(0,0))
	
	print("lua event handler8")
	self.room_layer:addChild(t)
	--[[
	-- Temporary unusable, please skip these lines to the comment section's end.
	-- Add scroll bar and scroll track (track is optional), they'll be placed right or bottom in table.
	-- The function LuaTableView:setScrollOffset(float) can be used for adjust scroll bar's position (bigger to right or bottom)
	-- Assume those two sprite frames were loaded.
	local sfc = CCSpriteFrameCache:sharedSpriteFrameCache()
	local bar = CCScale9Sprite:createWithSpriteFrame(sfc:spriteFrameByName("scrollBar.png"))
	bar:setOpacity(80)
	bar:setPreferredSize(CCSizeMake(10, 10))
	local trk = CCScale9Sprite:createWithSpriteFrame(sfc:spriteFrameByName("scrollTrack.png"))
	trk:setOpacity(128)
	trk:setPreferredSize(CCSizeMake(15, 15))
	t:setScrollBar(bar, trk)
	]]
	
	--Create a scene and run
	--local l = CCLayer:create()
	--l:addChild(t)
	--local s = CCScene:create()
	--s:addChild(l)
	--CCDirector:sharedDirector():replaceScene(s)
	 print("lua event handler9")
 end
 
 