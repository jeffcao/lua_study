CheckSignLua = {}

function CheckSignLua:generate_stoken(data)
	local s_code = data.v_code
	local i_code = data.v_flag
	DDZJniHelper:create():get("PackageSignCN")
	local s_name = CCUserDefault:sharedUserDefault():getStringForKey("PackageSignCN")
	print('s_name is', s_name)
	local s_token = CheckSign:check_sign(s_name, s_code, i_code)
	GlobalSetting.s_token = s_token
	GlobalSetting.s_name = s_name
	print("s_token is", s_token)
end

function CheckSignLua:fix_sign_param(data)
	if not data or type(data) ~= "table" then return end
	if GlobalSetting.s_token then
		data.s_token = GlobalSetting.s_token
		data.s_name = GlobalSetting.s_name
	end
	local user_default = CCUserDefault:sharedUserDefault()
	data.pkg_version_name = user_default:getStringForKey("pkg_version_name")
	data.version = resource_version
end

function CheckSignLua:check_stoken(data)
	if data.result_code and tonumber(data.result_code) == 902 then
		cclog("s_token is wrong, native is %s", GlobalSetting.s_token or "nil")
		cclog("result_message=> %s", data.result_message)
		endtolua()
	end
	return true
end
