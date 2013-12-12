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
		local tab_view = CCLabelTTF:create(name,"default",25)
		tab_view:setPosition(ccp(240,400))
		call_back(tab_view)
	end
end