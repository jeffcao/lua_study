CheckSignLua = {}

function CheckSignLua:generate_stoken(data)
	local s_code = data.v_code
	local i_code = data.v_flag
	local userDefault = CCUserDefault:sharedUserDefault()
	local s_name = "test"
	local s_sign = userDefault:getStringForKey("sign")
	local s_token = CheckSign:check_sign(s_name, s_sign, s_code, i_code)
	GlobalSetting.s_token = s_token
	GlobalSetting.s_name = s_name
	print("s_token is", s_token)
end

function CheckSignLua:check_stoken(data)
	if data.result_code and tonumber(data.result_code) == 902 then
		cclog("s_token is wrong, native is %s", GlobalSetting.s_token or "nil")
		cclog("result_message=> %s", data.result_message)
		endtolua()
	end
	return true
end
