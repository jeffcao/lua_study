LabelButtonTab = {}
require 'src.TabPlugin'

function LabelButtonTab.bind(theClass)
	
	--theClass must has variable
	--  menu_layer:to add menus
	
	--hanzi_names:{beans:"豆子", service:"服务"...}
	function theClass:setTabHanziNames(hanzi_names)
		self.labelbuttontab_hanzi_names = hanzi_names
	end
	
	function theClass:setNodeCheckStatus(tab_data)
		local cur_y = tab_data.tab_node:getPositionY()
		local original_y = tab_data.tab_node.original_y
		if cur_y ~= original_y then return end
		
		local cur_x = tab_data.tab_node:getPositionX()
		tab_data.tab_node:setPosition(ccp(cur_x, original_y - 10))
		set_red_stroke(tab_data.tab_node.label)
		tab_data.tab_node.toggle:setSelectedIndex(1)
		tab_data.tab_node.menu:setEnabled(false)
	end
	
	function theClass:setNodeUncheckStatus(tab_data)
		local cur_y = tab_data.tab_node:getPositionY()
		local original_y = tab_data.tab_node.original_y
		if cur_y == original_y then return end
		
		local cur_x = tab_data.tab_node:getPositionX()
		tab_data.tab_node:setPosition(ccp(cur_x, original_y))
		set_blue_stroke(tab_data.tab_node.label)
		tab_data.tab_node.toggle:setSelectedIndex(0)
		tab_data.tab_node.menu:setEnabled(true)
	end
	
	function theClass:getTabNode(tab_name)
		local hanzi_name = self.labelbuttontab_hanzi_names[tab_name]
		
		local layer = CCLayer:create()
		local label = CCLabelTTF:create(hanzi_name,"default",25)
		
		local plist = Res.jiesuan_plist
		CCSpriteFrameCache:sharedSpriteFrameCache():addSpriteFramesWithFile(plist)
		local menu_normal_sprite = CCSprite:createWithSpriteFrameName("xuanxiangka2.png")
		local menu_click_sprite = CCSprite:createWithSpriteFrameName("xuanxiangka1.png")
		local toggle_sub_normal = CCMenuItemSprite:create(menu_normal_sprite, menu_click_sprite)
		local toggle_sub_selected = CCMenuItemSprite:create(CCSprite:createWithSpriteFrameName("xuanxiangka1.png"),
															CCSprite:createWithSpriteFrameName("xuanxiangka1.png"))
		local toggle = CCMenuItemToggle:create(toggle_sub_normal)
		toggle:addSubItem(toggle_sub_selected)
		toggle:setSelectedIndex(0)
		toggle:setTag(1000)
		toggle:registerScriptTapHandler(function() self:set_tab(tab_name) end)
		local menu = CCMenu:createWithItem(toggle)
		menu:ignoreAnchorPointForPosition(false)
		layer:addChild(menu)
		layer:addChild(label)
		self.menu_layer:addChild(layer)
		layer:setPosition(ccp(40+self.menu_layer:getChildrenCount()*115,20))
		set_blue_stroke(label)
		
		layer.menu = menu
		layer.toggle = toggle
		layer.name = name
		layer.label = label
		layer.original_y = layer:getPositionY()
		
		return layer
	end
	TabPlugin.bind(theClass)
end