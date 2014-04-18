Avatar = {}

Avatar.sharedAvatars = function()
	CCSpriteFrameCache:sharedSpriteFrameCache():addSpriteFramesWithFile(Res.info_plist)
end

Avatar.getUserAvatarFrame = function(player)
	local avatar = tonumber(player.avatar)
	cclog("get avatar:" .. avatar)
	local img = nil
	if avatar == 0 then
		img = "touxiang00_m.png"
		if tonumber(player.gender) ~= 1 then
			img = "touxiang00_f.png"
		end
	else
		img = "touxiang" .. avatar .. ".png"
		if avatar < 10 then
			img = "touxiang0" .. avatar .. ".png"
		end
	end
	local avatarFrame = CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName(img)
	if not avatarFrame then
		cclog("get default avatar")
		img = "touxiang00_m.png"
		if tonumber(player.gender) ~= 1 then
			img = "touxiang00_f.png"
		end
		avatarFrame = CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName(img)
	end
	cclog("avatar img name is " .. img)
	return avatarFrame
end

Avatar.getAvatarFrame = function(img)
	local avatarFrame = CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName(img)
	return avatarFrame
end