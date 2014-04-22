require "src.UIControllerPlugin"
require "src.DialogPlugin"
require "src.resources"
require "src.SoundEffect"

ShouchonglibaoBuyBox = class("ShouchonglibaoBuyBox", function()
	print("new ShouchonglibaoBuyBox")
	return display.newLayer("ShouchonglibaoBuyBox")
end
)

function createShouchonglibaoBuyBox(confirm_func)
	print("create ShouchonglibaoBuyBox")
	return ShouchonglibaoBuyBox.new(confirm_func)
end

function ShouchonglibaoBuyBox:ctor(confirm_func)
	ccb.ShouchonglibaoBuyBox = self
	self.on_commit_clicked = function() 
		print("ShouchonglibaoBuyBox.on_buy_clicked")
		self:playButtonEffect() 
		self:dismiss() 
		confirm_func() 
	end
--	self.on_cancel_clicked = function()
--		if not self.first_click_tag then 
--			self.first_click_tag = true
--			if math.random() < 0.33 then
--				print('do not response to click cancel')
--				return 
--			else
--				print('do response to click cancel')
--			end
--		end
--		self:playButtonEffect() self:dismiss() 
--	end
	local ccbproxy = CCBProxy:create()
 	CCBReaderLoad("ShouchonglibaoBuyBox.ccbi", ccbproxy, true, "ShouchonglibaoBuyBox")
	self:addChild(self.rootNode)
	self.confirm_func = confirm_func

	scaleNode(self.rootNode, GlobalSetting.content_scale_factor)
	self:init_dialog()
	self:setClickOutDismiss(false)
	print('ShouchonglibaoBuyBox:actor end.')
end

function ShouchonglibaoBuyBox:init()
	print('ShouchonglibaoBuyBox.init')
	self:setClickOutDismiss(true)
end

UIControllerPlugin.bind(ShouchonglibaoBuyBox)
SoundEffect.bind(ShouchonglibaoBuyBox)
DialogPlugin.bind(ShouchonglibaoBuyBox)
