UserInfo = {}

function UserInfo:new(info)
	local this_obj = {}
    setmetatable(this_obj, self)
    self.__index = self
    
    this_obj:load_from_json(info)
	
    --self.__index = self
	
	return this_obj
end

function UserInfo:load(userDefault)
	self.user_id = userDefault:getStringForKey("user.user_id")
	self.login_token = userDefault:getStringForKey("user.login_token")
	
	return self
end

function UserInfo:save(userDefault)
	userDefault:setStringForKey("user.user_id", self.user_id)
	userDefault:setStringForKey("user.login_token", self.login_token)
end

function UserInfo:load_from_json(json_data)
	if json_data then
		for _k, _v in pairs(json_data) do
			self[_k] = _v
		end
	end
	
	self.user_id = self.user_id or ""	
	self.gender = self.gender or 0
	self.nick_name = self.nick_name or ""	
	self.flag = self.flag or 0
	self.email = self.flag or 0
	self.score = self.score or 0
	self.win_count = self.win_count or 0
	self.lost_count = self.lost_count or 0
	self.avatar = self.avatar or 0
	self.login_token = self.token
	
	return self
end