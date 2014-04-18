KickOut = {}

function KickOut.clear()
	GlobalSetting.kick_out = nil
end

function KickOut.set()
	GlobalSetting.kick_out = {time = os.time()}
end

function KickOut.set_reason(reason)
	if GlobalSetting.kick_out then
		GlobalSetting.kick_out.reason = reason
	end
end

function KickOut.check()
	if not GlobalSetting.kick_out then return nil end
	local delta = os.time() - GlobalSetting.kick_out.time
	if delta < 0 or delta > 10 then return nil end
	local reason = GlobalSetting.kick_out.reason
	KickOut.clear()
	return reason
end