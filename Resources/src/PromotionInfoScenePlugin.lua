PromotionInfoScenePlugin = {}
require 'src.LabelButtonTab'
require 'src.strings'

function PromotionInfoScenePlugin.bind(theClass)
	LabelButtonTab.bind(theClass)
	
	function theClass:init_tabs()
		local tabs = {speci = {name="speci"}, rule = {name="rule"}, record = {name="record"}}
		local order = {"speci","rule","record"}
		local tabs_frams = {}
		tabs_frams["speci"]={"hd-xq/hd-xiaotu/hd-jirshao.png","hd-xq/hd-xiaotu/hd-jirshao.png"}
		tabs_frams["rule"]={"hd-xq/hd-xiaotu/hd-guize.png","hd-xq/hd-xiaotu/hd-guize.png"}
		tabs_frams["record"]={"hd-xq/hd-xiaotu/hd-huojiangjilu.png","hd-xq/hd-xiaotu/hd-huojiangjilu.png"}
		local tab_content = self.layer
		local hanzi_names = {speci="", rule="", record=""}
		self:setTabHanziNames(hanzi_names)
		self:init_mtabs(tabs, tab_content, order, tabs_frams)
		self:set_tab('speci')
	end

	function theClass:getTabView(name, call_back)
		--if GlobalSetting.run_env == 'test' then
		--	self.promotion.rule_desc = "活动规则：\na:\b每场比赛30--300人。时间30分钟，在规定的时间赢豆子最多的玩家获得胜利，领取相应的话费奖励.\nb:\b所有虚拟奖品实时到账，用户可以在排行中的话费排行查看中奖情况和金额，话费达到10倍数即可提现"
		--end
		local tab_view = nil
		self.promotion.rule_desc = string.gsub(self.promotion.rule_desc, " ", "\b")
		self.promotion.description = string.gsub(self.promotion.description, " ", "\b")
		if name == 'rule' then
			AppStats.event(UM_MATCH_RULE_SHOW)
			tab_view = self:createInfoLabel(self.promotion.rule_desc)
		elseif name == 'speci' then
			AppStats.event(UM_MATCH_DESC_SHOW)
			tab_view = self:createSpeciView(self.promotion.description)
		elseif name == 'record' then
			AppStats.event(UM_MATCH_BONUS_LOG)
			tab_view = self:createRecordView(call_back)
			return
		end
		scaleNode(tab_view, GlobalSetting.content_scale_factor)
		call_back(tab_view)
	end
	
	function theClass:createRecordView(call_back)
		local fail = function(data)
			dump(data, 'get_record fail')
			ToastPlugin.hide_progress_message_box()
		end
		local suc = function(data)
			dump(data, 'get_record success')
			ToastPlugin.hide_progress_message_box()
			self.record_list = data.content
			
			local process_time = function(t) return string.gsub(string.sub(t,0,string.find(t,'T')-1),'-','.') end
			for _,v in pairs(self.record_list) do
				v.date = process_time(v.date)
			end
			table.sort(self.record_list, 
				function(a,b)
					local date1 = string.gsub(a.date, "%.", "")
					local date2 = string.gsub(b.date, "%.", "")
					return tonumber(date1) > tonumber(date2)
				end
			)
			local view = self:create_record_list(self.record_list)
			call_back(view)
		end
		local event_data = {user_id=GlobalSetting.current_user.user_id, room_type=self.promotion.match_type}
		ToastPlugin.show_progress_message_box(strings.pisp_get_record_ing)
		GlobalSetting.hall_server_websocket:trigger('ui.game_match_log', event_data, suc, fail)
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
		local label = CCLabelTTF:create(text,"default",20)
		label:setAnchorPoint(ccp(0.5,0.5))
		label:setHorizontalAlignment(kCCTextAlignmentLeft)
		label:setPosition(400,160)
		label:setDimensions(CCSizeMake(680,270))
		label:setColor(GlobalSetting.white)
		return label
	end
	
	function theClass:create_record_list(record_list)
		local t = ListViewPlugin.create_list_view(record_list,
			createAwardRecordItem, 'init_award', CCSizeMake(800,80), CCSizeMake(800,270))
		if not t then
			return CCLayer:create()
		end
		t:setPosition(CCPointMake(0,10))
		return t
	end
end