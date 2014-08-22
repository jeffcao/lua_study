require "CCBReaderLoad"
require "src.DialogInterface"
require "src.RankUPlugin"
require "src.UIControllerPlugin"
require "src/WebsocketRails/Timer"
require "src.SoundEffect"
require 'HuafeiRankItem'

Rank = class("Rank", function() return display.newLayer("Rank") end)

function createRank(socket, event_prefix) return Rank.new(socket, event_prefix) end

function Rank:ctor(socket, event_prefix)
	self.ccbproxy = CCBProxy:create()
	self.ccbproxy:retain()
	ccb.Rank = self
	self.on_get_huafei_btn_clicked = __bind(self.get_mobile_charge, self)
	local node = CCBReaderLoad("Rank.ccbi", self.ccbproxy, true, "Rank")
	self.rootNode = tolua.cast(node, "CCLayer")
	self:addChild(self.rootNode)
	
	self.timer_time = self.bottom_lbl2
	self.player_bean = self.info_value_lbl1
	self.player_rank = self.info_value_lbl2
	self.tab_douzi = self.tab_btn_right
	self.tab_huafei = self.tab_btn_left
	
	self:set_socket(socket, event_prefix)
	self:init()
	
	scaleNode(self.rootNode, GlobalSetting.content_scale_factor)
	
	local sc = GlobalSetting.content_scale_factor*0.56
	self.rank_avatar:setScale(sc)
	sc = GlobalSetting.content_scale_factor*0.85
--	self.rank_avatar_bg:setScale(0.6)
	
	self:setOnKeypad(function(key)
		if key == "back" then
			print("Rank on key pad")
			if self:isShowing()  then
				self:dismiss()
			end
		end
	end)
	--GlobalSetting.rank_dialog = self
	
	local fn = function()
		local tabs = {douzi={name='douzi'},huafei={name='huafei'}}
		local order = {'douzi','huafei'}
		self:init_mtabs(tabs, self.rank_content, order)
		self:set_tab('douzi')
	end
	Timer.add_timer(0.5, fn,  'rank_timer')
end

function Rank:set_strokes()
	local lbls = {self.info_attr_lbl2, self.info_attr_lbl1, self.bottom_lbl1,
				  self.item_name_lbl1, self.item_name_lbl2, self.item_name_lbl3}
	for _,v in pairs(lbls) do
		set_rank_stroke(v)
	end
	local lbls2 = {self.tab_btn_left_lbl, self.tab_btn_right_lbl}
	for _,v in pairs(lbls2) do
		set_green_stroke(v)
	end
end

function Rank:init()
	self.item_name_lbl1:setPosition(ccp(16,0))
	self.item_name_lbl2:setPosition(ccp(100,0))
	self.item_name_lbl3:setPosition(ccp(250,0))
	self.item_name_lbl4:setVisible(false)
	self.tab_douzi:setEnabled(false)
	self.tab_btns:setVisible(true)
	self.huafei_layer:setVisible(false)
	self.top_layer:setVisible(false)
	self:setVisible(false)
	self:swallowOnKeypad()
	local menus = CCArray:create()
	self:swallowOnTouch(menus)
	self:set_strokes()
	self.sp_rake_name:setDisplayFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName("paihangbang.png"))
end

SoundEffect.bind(Rank)
DialogInterface.bind(Rank)
RankUPlugin.bind(Rank)
UIControllerPlugin.bind(Rank)