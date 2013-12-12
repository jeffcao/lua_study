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
			tab_view = self:createInfoLabel(speci)
		end
		scaleNode(tab_view, GlobalSetting.content_scale_factor)
		call_back(tab_view)
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
end