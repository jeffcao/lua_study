AwardRecordItem = class("AwardRecordItem", function() 
	print("new AwardRecordItem")
	return display.newLayer("AwardRecordItem")
	end
)

function createAwardRecordItem()
	print("create AwardRecordItem")
	return AwardRecordItem.new()
end

function AwardRecordItem:ctor()
	ccb.award_record_item = self
	self.ccbproxy = CCBProxy:create()
	self.ccbproxy:retain()
	CCBReaderLoad("AwardRecordItem.ccbi", self.ccbproxy, true, "award_record_item")
	self:addChild(self.rootNode)
	self.rootNode:ignoreAnchorPointForPosition(false)
	self.rootNode:setAnchorPoint(ccp(0,0.5))

	scaleNode(self.rootNode, GlobalSetting.content_scale_factor)
end

function AwardRecordItem:init_award(award_record)
	self.time_lbl:setString(award_record.date)
	self.name_lbl:setVisible(false)
	self.player_lbl:setVisible(false)
	self.spec_one_lbl:setString(award_record.content)
end

