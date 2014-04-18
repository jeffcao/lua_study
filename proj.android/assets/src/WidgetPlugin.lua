WidgetPlugin = {}

function WidgetPlugin.bind(theClass)
	
	function theClass:createEditBox(width, height)
		width = width or 320
		height = height or 50
		local editbox = CCEditBoxBridge:create(Res.common_plist, "kuang_a.png", width, height)
		editbox:setHint("请输入...")
		return editbox
	end
	
	function theClass:createEditBoxOn(node, x, y, width, height)
		x = x or 0
		y = y or 0
		local editbox = self:createEditBox(width, height)
		editbox:addTo(tolua.cast(node, "CCNode"), x, y)
		return editbox
	end
	
end