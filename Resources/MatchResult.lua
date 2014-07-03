require "CCBReaderLoad"
require "src.DialogInterface"
require 'src.strings'
require 'MatchResultItem'
MatchResult = class("MatchResult", function() return display.newLayer("MatchResult") end)

function createMatchResult() return MatchResult.new() end

function MatchResult:ctor()
	self.ccbproxy = CCBProxy:create()
	self.ccbproxy:retain()
	ccb.Rank = self
	CCBReaderLoad("Rank.ccbi", self.ccbproxy, true, "Rank")
	self:addChild(self.rootNode)
	self:init()
	scaleNode(self.rootNode, GlobalSetting.content_scale_factor)
	
	local sc = GlobalSetting.content_scale_factor*0.52
	self.rank_avatar:setScale(sc)
	sc = GlobalSetting.content_scale_factor*0.85
--	self.rank_avatar_bg:setScale(sc)
end

function MatchResult:set_strokes()
	local lbls = {self.top_lbl}
	for _,v in pairs(lbls) do
		set_rank_stroke(v)
	end
	set_rank_string_with_stroke(self.item_name_lbl1, '名次')
	set_rank_string_with_stroke(self.item_name_lbl2, '名称')
	set_rank_string_with_stroke(self.item_name_lbl3, '赢取豆子')
	set_rank_string_with_stroke(self.item_name_lbl4, '奖励')
	set_rank_string_with_stroke(self.info_attr_lbl1, '您赢取的豆子：')
	set_rank_string_with_stroke(self.info_attr_lbl2, '您的当前排名：')
end

function MatchResult:init()
	self.tab_btns:setVisible(false)
	self.huafei_layer:setVisible(false)
	self.bottom_lbl1:setVisible(false)
	self.sp_rake_name:setDisplayFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName("wenzi_bisaibang.png"))
	self.item_name_lbl1:setPosition(ccp(0,0))
	self.item_name_lbl2:setPosition(ccp(85,0))
	self.item_name_lbl3:setPosition(ccp(170,0))
	self.item_name_lbl4:setPosition(ccp(290,0))
	
	self:set_strokes()
	self:setVisible(false)
end

function MatchResult:create_rank_list(rank_list)
	local t = ListViewPlugin.create_list_view(rank_list,
	createMatchResultItem, 'init', CCSizeMake(355,30), CCSizeMake(355,165))
	return t
end
	
function MatchResult:set_result(data)
	--TODO
	--set_rank_string_with_stroke(self.bottom_lbl2, string.gsub(strings.mr_next_time, 'time', data.time))
	self.bottom_lbl2:setVisible(false)
	set_rank_string_with_stroke(self.info_value_lbl1, data.win_score)
	set_rank_string_with_stroke(self.info_value_lbl2, data.me_rank)
	dump(data.match_rank, ('data.match_rank'))
	local view = self:create_rank_list(data.match_rank)
	self.rank_content:addChild(view)
	local ontouch = function(e,x,y)
		if not self:isVisible() then print("self is not visible") return false end
		print('event is', e)
		if not cccn(self.bg, x,y) then
			self:dismiss()
		else
			return false
		end
		return true
	end
	self.bg:registerScriptTouchHandler(ontouch, false, 200, true)
	self.bg:setTouchEnabled(true)
	local menus = CCArray:create()
	menus:addObject(self.bg)
	menus:addObject(view)
	self:swallowOnTouch(menus)
end

DialogInterface.bind(MatchResult)
