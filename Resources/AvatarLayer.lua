AvatarLayer = class("AvatarLayer", function()
	return display.newLayer("AvatarLayer")
end
)

function createAvatarLayer()
	return AvatarLayer.new()
end

function AvatarLayer:ctor()
	local cache = CCSpriteFrameCache:sharedSpriteFrameCache();
	cache:addSpriteFramesWithFile(Res.info_plist)
	local data = {}
	for i = 1, 6 do
		table.insert(data, "touxiang0" .. i .. ".png") end
	for i = 50, 53 do
		table.insert(data, "touxiang" .. i .. ".png") end
	local h = LuaEventHandler:create(function(fn, table, a1, a2)
		local r
		if fn == "cellSize" then
			r = CCSizeMake(800,480)
		elseif fn == "cellAtIndex" then
			if not a2 then
				a2 = CCTableViewCell:create()
				a3 = CCSprite:createWithSpriteFrameName(data[a1+1])
				a3:setScale(GlobalSetting.content_scale_factor)
				a2:addChild(a3, 0, 1)
			end
			r = a2
		elseif fn == "numberOfCells" then
			r = #data
		elseif fn == "cellTouched" then
		end
		return r
	end)
	local t = LuaTableView:createWithHandler(h, CCSizeMake(800,480))
	t:setDirection(kCCScrollViewDirectionBoth)
	t:reloadData()
	t:setPosition(CCPointMake(100,20))
	self:addChild(t)
end