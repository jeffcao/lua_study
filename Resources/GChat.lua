GChat = class("GChat", function() return display.newLayer("GChat") end)

function createGChat() return GChat.new() end

function GChat:ctor()
	self.ccbproxy = CCBProxy:create()
	self.ccbproxy:retain()
	ccb.GChat = self
	local node = CCBReaderLoad("Chat.ccbi", self.ccbproxy, true, "GChat")
	self.rootNode = tolua.cast(node, "CCLayer")
	self:addChild(self.rootNode)
	scaleNode(self.rootNode, GlobalSetting.content_scale_factor)
	
	local ontouch = function(eventType, x, y)
    		cclog("touch event GChat:%s,x:%d,y:%d", eventType, x, y)
			if eventType == "began" then
				do return true end
			elseif eventType == "moved" then
				do return end
			else
				if not self.bg:boundingBox():containsPoint(ccp(x,y)) then
					--self:setVisible(false)
					self:removeFromParentAndCleanup(true)
				end
				do return end
			end
    	end
    self.rootNode:registerScriptTouchHandler(ontouch)
    self.rootNode:setTouchEnabled(true)
end

function GChat:init(data, click_func)
	--dump(data, "GChat init data is =>")
	--dump(click_func, "click func is =>")
	local h = LuaEventHandler:create(function(fn, table, a1, a2)
		--	dump(a1, "LuaEventHandler a1=>")
		--	dump(fn, "LuaEventHandler fn=>")
		--	dump(a2, "LuaEventHandler a2=>")
		--	dump(table, "LuaEventHandler table=>")
		--	dump(data, "LuaEventHandler data is =>")
			local r
			if fn == "cellSize" then
				r = CCSizeMake(340,30)
			elseif fn == "cellAtIndex" then
				a1 = a1 + 1
				if not a2 then
					a2 = CCTableViewCell:create()
					cclog("a1 is " .. a1)
				--	dump(data[a1],"data[a1]")
					local a3 = CCLabelTTF:create(data[a1].text, "default", "22")
					a3:setColor(GlobalSetting.zongse)
					a3:setAnchorPoint(ccp(0,0))
					a3:setPosition(ccp(20,0))
					a2.data = data[a1]
					a2:setTag(data[a1].id)
					--dump(a3.data, "a3.data after set")
					a2:addChild(a3, 0, 1)
				else
					local a3 = tolua.cast(a2:getChildByTag(1), "CCLabelTTF")
					--dump(a3.data, "a3.data when a3 is exist")
					a3:setString(data[a1].text)
					a2.data = data[a1]
					a2:setTag(data[a1].id)
					--dump(a3.data, "a3.data when a3 is exist and after set")
					--a3 = tolua.cast(a2:getChildByTag(1), "CCLabelTTF")
					--dump(a3.data, "a3.data when a3 is exist and after set and tolua")
				end
				r = a2
			elseif fn == "numberOfCells" then
				if data then
					r = #data
				end
			elseif fn == "cellTouched" then
				print("[HallSceneUPlugin:init_room_tabview] room_cell_touched")
				local a3 = a1:getChildByTag(1)
			--	dump(a1:getTag(), "on props clicked =>")
				click_func(a1:getTag())
			--	self:setVisible(false)
				self:removeFromParentAndCleanup(true)
			end
			return r
	end)
		
	local t = LuaTableView:createWithHandler(h, CCSizeMake(380,185))
	t:setDirection(kCCScrollViewDirectionVertical)
	t:reloadData()
	t:setPosition(CCPointMake(0,7))
	self.text_container:addChild(t)
	
	for index=#data, 1, -1 do
		t:updateCellAtIndex(index-1)
	end
end