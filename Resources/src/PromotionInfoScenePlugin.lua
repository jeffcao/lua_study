PromotionInfoScenePlugin = {}
require 'src.LabelButtonTab'

function PromotionInfoScenePlugin.bind(theClass)
	LabelButtonTab.bind(theClass)
	
	function theClass:init_tabs()
		local tabs = {speci = {name="speci"}, rule = {name="rule"}, record = {name="record"}}
		local order = {"speci","rule","record"}
		local tab_content = self.layer
		local hanzi_names = {speci="活动介绍", rule="活动规则", record="领奖记录"}
		self:setTabHanziNames(hanzi_names)
		self:init_mtabs(tabs, tab_content, order)
		self:set_tab('speci')
	end

	function theClass:getTabView(name, call_back)
		local speci = '活动规则：\na、每场比赛30-300人，时间为30分钟，在规定的时间赢豆最多的玩家获得胜利，领取相应的话费奖励。\n'
		..'b、所有虚拟奖品实时到帐，用户可在排行中的话费排行查看中奖情况与金额，话费达到10的倍数即可提现。'
		local rule = speci .. '\n\n' .. speci
		local tab_view = nil
		if name == 'rule' then
			tab_view = self:createInfoLabel(rule)
		elseif name == 'speci' then
			tab_view = self:createSpeciView(speci)
		elseif name == 'record' then
			tab_view = self:createRecordView()
		end
		scaleNode(tab_view, GlobalSetting.content_scale_factor)
		call_back(tab_view)
	end
	
	function theClass:createRecordView()
		local list = {}
		for index=1, 10 do
			local data = {time='2013.10.'..tostring(index)}
			data.speci = '在【送话费房】比赛中获得第一名，获得了6元话费，恭喜您'
			if index%2 == 0 then data.speci = '在【送豆子】比赛中获得第一百一十一名，获得了26元话费，恭喜您！' end
			table.insert(list, data)
		end
		return self:create_record_list(list)
	end
	
	function theClass:createSpeciView(text)
		local tab_view = CCLayer:create()
		local label = self:createInfoLabel(text)
		local ccbproxy = CCBProxy:create()
		ccbproxy:retain()
		local node = CCBReaderLoad("PromotionAward.ccbi", ccbproxy, false, "")
		tab_view:addChild(label)
		tab_view:addChild(node)
		return tab_view
	end
	
	function theClass:createInfoLabel(text)
		local label = CCLabelTTF:create(text,"default",25)
		label:setAnchorPoint(ccp(0.5,0.5))
		label:setHorizontalAlignment(kCCTextAlignmentLeft)
		label:setPosition(400,216)
		label:setDimensions(CCSizeMake(680,360))
		label:setColor(GlobalSetting.zongse)
		return label
	end
	
	function theClass:create_record_list(record_list)
		if not record_list or #record_list == 0 then return end
		local h = LuaEventHandler:create(function(fn, table, a1, a2)
			local r
			if fn == "cellSize" then
				r = CCSizeMake(800,80)
			elseif fn == "cellAtIndex" then
				if not a2 then
					a2 = CCTableViewCell:create()
					a3 = createAwardRecordItem()
					print("[PromotionInfoScene.create_record_list] a1 =>"..a1)
					a3:init_award(record_list[a1+1])
					a2:addChild(a3, 0, 1)
					_G.table.insert(self.record_layers, a3)--keep this variable or it will be clean up
				else
					local a3 = tolua.cast(a2:getChildByTag(1), "CCLayer")
					a3.init_award(a3, record_list[a1 + 1])
				end
				r = a2
			elseif fn == "numberOfCells" then
				r = #record_list
			elseif fn == "cellTouched" then
			end
			return r
		end)
		local t = LuaTableView:createWithHandler(h, CCSizeMake(800,360))
		t:setPosition(CCPointMake(0,40))
		
		for index=#(record_list), 1, -1 do
			t:updateCellAtIndex(index-1)
		end
		
		return t
	end
end