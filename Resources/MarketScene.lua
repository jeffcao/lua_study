require "src.MarketSceneUPlugin"
require "src.UIControllerPlugin"
require "src.HallServerConnectionPlugin"

local tabnames_hanzi = {"优  惠", "豆  子", "礼  包", "服  务"}

MarketScene = class("MarketScene", function()
	print("new market scene")
	return display.newScene("MarketScene")	
end
)

function createMarketScene(inactive_market_scene_fn)
	print("create market scene")
	return MarketScene.new(inactive_market_scene_fn)
end

function MarketScene:ctor(inactive_market_scene_fn)
	
	self.tabs = {}
	
	--[[
	local ccbproxy = CCBProxy:create()
	
	self.inactive_market_scene_fn = inactive_market_scene_fn
	
	local layer = createFullMubanStyleLayer()
	self.rootNode = layer
	self:addChild(layer)
	layer.inactive_market_scene_fn = inactive_market_scene_fn
	layer:setTitle("biaoti06.png")
	
	Timer.add_timer(0.1, function() 
		self:set_tab(0)
	end)
	]]
	
	self.ccbproxy = CCBProxy:create()
	ccb.market_scene = self
	local node = CCBReaderLoad("MarketScene.ccbi", self.ccbproxy, true, "market_scene")
	self:addChild(self.rootNode)
	self:init_tabs()
	Timer.add_timer(0.1, function() 
		self:get_prop_list("0")
		--self.after_trigger_success = __bind(self.on_get_tab, self)
	end)
	scaleNode(self.rootNode, GlobalSetting.content_scale_factor)
	
end

function MarketScene:get_prop_list(type)
	self:show_progress_message_box("获取商品列表")
	self:shop_prop_list(type)
	self.after_trigger_success = __bind(self.on_get_tab, self)
end

function MarketScene:init_tabs()
	for index = 0,3 do
		self:create_one_tab(tostring(index))
	end
end

function MarketScene:create_one_tab(tab_seq)
	tab_seq = tostring(tab_seq)
	local name = tab_seq
	if self.tabs[name] then return end
	local name_hanzi = tabnames_hanzi[tonumber(tab_seq) + 1]
	
	local layer = CCLayer:create()
	local label = CCLabelTTF:create(name_hanzi,"default",25)
	--label:setFontSize(25)
	
	local menu_normal_sprite = CCSprite:createWithSpriteFrameName("xuanxiangka2.png")
	local menu_click_sprite = CCSprite:createWithSpriteFrameName("xuanxiangka1.png")
	local toggle_sub_normal = CCMenuItemSprite:create(menu_normal_sprite, menu_click_sprite)
	local toggle_sub_selected = CCMenuItemSprite:create(CCSprite:createWithSpriteFrameName("xuanxiangka1.png"),
														CCSprite:createWithSpriteFrameName("xuanxiangka1.png"))
	local toggle = CCMenuItemToggle:create(toggle_sub_normal)
	toggle:addSubItem(toggle_sub_selected)
	toggle:setSelectedIndex(0)
	toggle:setTag(1000)
	toggle:registerScriptTapHandler(function() self:set_tab(name) end)
	local menu = CCMenu:createWithItem(toggle)
	menu:ignoreAnchorPointForPosition(false)
	layer:addChild(menu)
	layer:addChild(label)
	self.menu_layer:addChild(layer)
	layer:setPosition(ccp(40+tonumber(tab_seq)*115,20))
	
	
	layer.menu = menu
	layer.toggle = toggle
	layer.name = name
	layer.y = layer:getPositionY()
	layer.x = layer:getPositionX()
	self.tabs[name]=layer
end

function MarketScene:on_get_tab(data)
	cclog("on get tab data")
	dump(data, "data=>")
	self.tabs[data.type].attach_view = self:create_product_list(data.commodity)
	self:set_tab(data.type)
end

function MarketScene:set_tab(name)
	cclog('set tab '..name)
	name = tostring(name)
		if name == self.last_tab then cclog('name == self.last_tab, return') return end
		for k,v in pairs(self.tabs) do
			--local y = v:getPositionY()
			--local x = v:getPositionX()
			if k == name then
				if not v.attach_view then 
					self:get_prop_list(name)
					return
				else
					if not v.attach_view:getParent() then
						self.content_layer:addChild(v.attach_view)
					end
					v.attach_view:setVisible(true)
					v.menu:setEnabled(false)
					v:setPosition(ccp(v.x, v.y - 10))
				end
			else
				if v.name == self.last_tab then v:setPosition(ccp(v.x, v.y)) end
				v.toggle:setSelectedIndex(0)
				if v.attach_view then v.attach_view:setVisible(false) end
				v.menu:setEnabled(true)
			end
		end
		self.last_tab = name
end

MarketSceneUPlugin.bind(MarketScene)
UIControllerPlugin.bind(MarketScene)
HallServerConnectionPlugin.bind(MarketScene)