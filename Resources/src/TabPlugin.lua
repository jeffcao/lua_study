TabPlugin = {}

--theClass must implement this functions
--  setNodeCheckStatus(tab_data)
--  setNodeUncheckStatus(tab_data)
--  getTabView(name, call_back)
--  getTabNode(name)

-- theClass must call
--   init_mtabs(tabs, tab_content, order)
--   set_tab(name)

function TabPlugin.bind(theClass)

	--tabs:{tabname:tab_data,...}
	--  tab_data:name, tab_view=nil, tab_node=nil
	--tab_content:the layer to add tab_view in it
	function theClass:init_mtabs(tabs, tab_content, order)
		self.tabplugin_tabs = tabs
		self.tabplugin_tab_content = tab_content
		--cause when pairs table, the item which key is not number will not be visited in order
		--set order table to visit the tab_table
		for _, tab_name in pairs(order) do
			tab_data = self.tabplugin_tabs[tab_name]
			if not tab_data then print("must set and only set every tab's order") return end
			if not tab_data.tab_node then
				tab_data.tab_node = self:getTabNode(tab_name)
			end
		end
	end
	
	function theClass:set_tab_view(name, view)
		local tab_data = self.tabplugin_tabs[name]
		if not tab_data then return end
		if tab_data.tab_view and tab_data.tab_view:getParent() then
			tab_data.tab_view:removeFromParentAndCleanup(true)
		end
		tab_data.tab_view = view
	end
	
	function theClass:current_tab()
		if self.tabplugin_current then return self.tabplugin_current.name else return nil end
	end

	function theClass:set_tab(name)
		if (not self.tabplugin_tabs) or (not self.tabplugin_tabs[name]) then return end
		if self.tabplugin_current and self.tabplugin_current.name == name then return end
		
		for tab_name, tab_data in pairs(self.tabplugin_tabs) do
			if tab_name == name then
				if not tab_data.tab_view then
					self:getTabView(tab_name, function(view) tab_data.tab_view = view self:set_tab(name) end)
					return
				end
				if not tab_data.tab_view:getParent() then
					self.tabplugin_tab_content:addChild(tab_data.tab_view)
				end
				self:setNodeCheckStatus(tab_data)
				tab_data.tab_view:setVisible(true)
			else
				self:setNodeUncheckStatus(tab_data)
				if tab_data.tab_view then tab_data.tab_view:setVisible(false) end
			end
		end
		self.tabplugin_current = self.tabplugin_tabs[name]
	end
end