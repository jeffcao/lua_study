CheckSign = {}

function CheckSign:check(s_name, s_sign, s_code, i_code)
	local count, codes = self:cal_codes(i_code)
	local s = {}
	s[1] = s_name
	s[2] = s_sign
	s[3] = s_code
	s[4] = string.sub(s_code, 1, count)
	
	local str = ''
	for k,v in pairs(codes) do
		str = str .. s[tonumber(v)]
	end
	print(str)
end

function CheckSign:cal_codes(i_code)
	i_code = tostring(i_code)
	local len = string.len(i_code)
	local count = string.sub(i_code, len - 1, len)
	local code = string.sub(i_code, 0, len - 2)
	code = tostring(tonumber(code) / 12)
	code = string_to_array(code)
end