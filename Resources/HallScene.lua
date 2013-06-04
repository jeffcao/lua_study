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
	--local editbox = self:createEditBoxOn(self.rootNode, 400, 120)
	--editbox:setHintSize(10)
	--editbox:setText("hfdkahfla")
	--editbox:setTextSize(40)
	--editbox:setTextColor(255,0,0)
	--editbox:setMaxLength(10)
	--editbox:setInputFlag(0)
	--local tx = editbox:getText()
	--print("tx is " .. tx)
	--editbox:registerOnTextChange(function(before_text, cur_text)
	--	print("tx change from " .. before_text .. " to " .. cur_text)
	--end)
	local cache = CCSpriteFrameCache:sharedSpriteFrameCache();
	cache:addSpriteFramesWithFile(Res.common_plist)
	local scale9 = CCScale9Sprite:createWithSpriteFrameName("kuang_a.png")
	local editbox = CCEditBox:create(CCSizeMake(320,50), scale9)
	editbox:setText("hfdkahfla")
	self.rootNode:addChild(editbox)
	
	local data = {}
	for i = 1, 10 do
		table.insert(data, "Data 3"..i) end
	local h = LuaEventHandler:create(function(fn, table, a1, a2)
		local r
		if fn == "cellSize" then
			r = CCSizeMake(260,260)
		elseif fn == "cellAtIndex" then
			if not a2 then
				a2 = CCTableViewCell:create()
				a3 = createRoomItem()
				a2:addChild(a3, 0, 1)
			end
			r = a2
		elseif fn == "numberOfCells" then
			r = #data
		elseif fn == "cellTouched" then
		end
		return r
	end)
	local t = LuaTableView:createWithHandler(h, CCSizeMake(800,480))
	t:setDirection(kCCScrollViewDirectionHorizontal)
	t:reloadData()
	t:setPosition(CCPointMake(0,0))
	self.room_layer:addChild(t)
	
 end
 

 
 --[[
 function HallScene:onMenuClick(tag)
 	local menu = createMenu()
 	self.rootNode.addChild(menu)
 end
 ]]
 
 function HallScene:onEnter() 
	
 end
 
 