UserInfo = {}

function UserInfo:new(info)
	local this_obj = {}
	if info then
		for _k, _v in pairs(info) do
			this_obj[_k] = _v
		end
	end
	
    setmetatable(this_obj, self)
    self.__index = self

	this_obj.user_id = this_obj.user_id or ""	
	this_obj.gender = this_obj.gender or 0
	this_obj.nick_name = this_obj.nick_name or ""	
	this_obj.flag = this_obj.flag or 0
	this_obj.email = this_obj.flag or 0
	this_obj.score = this_obj.score or 0
	this_obj.win_count = this_obj.win_count or 0
	this_obj.lost_count = this_obj.lost_count or 0
	this_obj.avatar = this_obj.avatar or 0
	this_obj.login_token = ""
	
	return this_obj
end