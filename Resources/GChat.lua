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
    
    AppStats.event(UM_CHAT_SHOW)
end

function GChat:init(data, click_func)
	
	local function cellSizeForTable(table,idx)
  		return 340,30
	end

	local function numberOfCellsInTableView(table)
		return #data
	end
	
	local function tableCellTouched(table,cell)
		print("[GChat:init] tableCellTouched")
		-- local cell = table:dequeueCell()
	--	dump(a1:getTag(), "on props clicked =>")
		click_func(cell:getTag())
	--	self:setVisible(false)
		self:removeFromParentAndCleanup(true)
		
		AppStats.event(UM_CHAT_MSG, tostring(a1:getTag()))
	end

	local function tableCellAtIndex(table, idx)
	    local strValue = string.format("%d",idx)
	    print("[GChat:init] tableCellAtIndex, idx= ", idx)
	    local cell = table:dequeueCell()
	    local label = nil
	    if nil == cell then
			cell = CCTableViewCell:new()
			local a3 = CCLabelTTF:create(data[idx+1].text, "default", "22")
			a3:setColor(GlobalSetting.white)
			a3:setAnchorPoint(ccp(0,0))
			a3:setPosition(ccp(20,0))
			cell.data = data[idx+1]
			cell:setTag(data[idx+1].id)
			cell:addChild(a3, 0, 1)
	    else
	    	local a3 = tolua.cast(cell:getChildByTag(1), "CCLabelTTF")
	    	a3:setString(data[idx+1].text)
			cell.data = data[idx+1]
			cell:setTag(data[idx+1].id)
		end

	    return cell
	end

  	local tableView = CCTableView:create(CCSizeMake(352,185))
	--tableView:setAnchorPoint(ccp(0.5,0.5))
	tableView:setPosition(CCPointMake(0,7))
  -- tableView:setDirection(kCCScrollViewDirectionHorizontal)
  -- tableView:setPosition(CCPointMake(20, winSize.height / 2 - 150))
  --registerScriptHandler functions must be before the reloadData function
  tableView:registerScriptHandler(tableCellTouched,CCTableView.kTableCellTouched)
  tableView:registerScriptHandler(cellSizeForTable,CCTableView.kTableCellSizeForIndex)
  tableView:registerScriptHandler(tableCellAtIndex,CCTableView.kTableCellSizeAtIndex)
  tableView:registerScriptHandler(numberOfCellsInTableView,CCTableView.kNumberOfCellsInTableView)
  tableView:reloadData()

  self.text_container:addChild(tableView)


end