CheckSign = {}

function CheckSign:generate_stoken(s_code, i_code)
	local userDefault = CCUserDefault:sharedUserDefault()
	local s_name = userDefault:getStringForKey("appid")
	local s_sign = userDefault:getStringForKey("sign")
	local s_token = CheckSign:check(s_name, s_sign, s_code, i_code)
	GlobalSetting.s_token = s_token
	print("s_token is", s_token)
end

function CheckSign:check_stoken(s_token)
	if s_token ~= GlobalSetting.s_token then
		cclog("s_token is wrong, native is %s", GlobalSetting.s_token or "nil")
		endtolua()
	end
	return true
end
