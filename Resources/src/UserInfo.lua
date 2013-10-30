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
	local str_user_ids = userDefault:getStringForKey("user.user_ids")
	print("[UserInfo:load] str_user_ids: "..str_user_ids)
	if str_user_ids == nil then
		return self
	end
	local user_ids = split(str_user_ids, ",")
	if #user_ids < 1 then
		return self
	end
	
	self.user_id = user_ids[1]
	self.login_token = userDefault:getStringForKey("user.login_token_"..self.user_id)
	return self
end

function UserInfo:load_by_id(userDefault,u_id)
	local str_user_ids = userDefault:getStringForKey("user.user_ids")
	print("[UserInfo:load_by_id] str_user_ids: "..str_user_ids)
	if str_user_ids == nil then
		return self
	end
	local user_ids = split(str_user_ids, ",")
	if #user_ids < 1 then
		return self
	end
	for k, v in pairs(user_ids) do
		if tonumber(v) == tonumber(u_id) then
			self.user_id = u_id
			break
		end
	end	
	if self.user_id ~= nil then
		self.login_token = userDefault:getStringForKey("user.login_token_"..u_id)
	end
	dump(self, "UserInfo:self")
	return self
end

function UserInfo:get_all_user_ids(userDefault)
	local str_user_ids = userDefault:getStringForKey("user.user_ids")
	print("[UserInfo:load_by_id] str_user_ids: "..str_user_ids)
	if str_user_ids == nil then
		return {}
	end
	local user_ids = split(str_user_ids, ",")
	if #user_ids < 1 then
		return {}
	end
	
	return user_ids
end

function UserInfo:save(userDefault)
	local str_user_ids = userDefault:getStringForKey("user.user_ids")
	if str_user_ids == nil then
		userDefault:setStringForKey("user.user_ids", self.user_id)
	else
		str_user_ids = self:subUserIds(str_user_ids, self.user_id)
		userDefault:setStringForKey("user.user_ids", self.user_id..","..str_user_ids)
	end
	
	userDefault:setStringForKey("user.login_token_"..self.user_id, self.login_token)
end

function UserInfo:subUserIds(str_user_ids, user_id)
	local return_value = ""
	print("[UserInfo:subUserIds] user_id: "..user_id)
	local user_ids = split(str_user_ids, ",")
	if #user_ids < 1 then
		return ""
	end
	local count = 0
	for k, v in pairs(user_ids) do
		if count < 4 and tonumber(v) ~= tonumber(user_id)  then
			print("[UserInfo:subUserIds] user_id: "..user_id.." v: "..v)
			return_value = return_value..","..v
			count = count + 1
		end
	end
	print("[UserInfo:subUserIds] return_value: "..return_value)
	return trim(return_value,',')
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
	self.email = self.email or 0
	self.score = self.score or 0
	self.win_count = self.win_count or 0
	self.lost_count = self.lost_count or 0
	self.avatar = self.avatar or 0
	self.login_token = self.token
	
	return self
end