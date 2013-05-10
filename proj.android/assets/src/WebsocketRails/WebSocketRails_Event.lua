WebSocketRails = WebSocketRails or {}

--require "json"
local json = require "cjson"
--local json = cjson_safe.new

WebSocketRails.Event = {

    new = function (self, params, success_callback, failure_callback)
        local this_obj = {}
        setmetatable(this_obj, self)
        self.__index = self
        
    --    for k,v in ipairs(params) do
    --        print(k,v)
    --    end

        this_obj.success_callback = success_callback
        this_obj.failure_callback = failure_callback
        
        this_obj.name = tostring(params[1])
        this_obj.attr = params[2]
        if #params >= 3 then
            this_obj.connection_id = params[3]
        end
    
        this_obj.id = 1 + math.ceil( math.random() * 0x10000 )
        this_obj.channel = nil
        this_obj.data = nil
        this_obj.success = nil
        this_obj.connection_id = nil
        this_obj.__srv_seq_id = nil
        this_obj.__srv_resend = nil
        
    --    print("dump self ===> ")
    --    for k,v in pairs(self) do
    --        print(k,v)
    --    end

    --    print("self.name => " .. self.name)
        
        local attr = this_obj.attr
        if attr ~= nil then
            if (attr.id ~= nil) and (attr.id ~= json.null) then
                this_obj.id = tonumber( attr.id )
                --print("this_obj.id => ", this_obj.id)
            end
            
            if  (attr.channel ~= nil) and (attr.channel ~= json.null) then
                this_obj.channel = tostring(attr.channel)
            else
                this_obj.channel = nil
            end
            
            if  (type(attr.data) == "table") or ((attr.data ~= nil) and (attr.data ~= json.null)) then
                this_obj.data = attr.data
            else
                this_obj.data = attr
            end
            
            --print("attr.success => ", attr.success, type(attr.success), attr.success == true)
            
            --if (attr.success ~= nil) and (type(attr.success) == "userdata" and attr.success ~= json.null) then
            if (attr.success == true) or (attr.success == false) then
                this_obj.result = true
                this_obj.success = attr.success == true
                --print("this_obj.success => ", this_obj.success)
            end
            
            if this_obj.data.__srv_seq_id ~= nil then
            	this_obj.__srv_seq_id = this_obj.data.__srv_seq_id
            end
            
            if this_obj.data.__srv_resend ~= nil then
            	this_obj.__srv_resend = this_obj.data.__srv_resend
            end
            
        end

        return this_obj
    end,

    is_channel = function(self)
        return self.channel ~= nil
    end,

    is_result = function(self)
         return self.result == true
    end,

    is_ping = function(self)
   		ping_result = self.name == "websocket_rails.ping"
     	--print("self.name => " .. self.name .. " , ping_result => " )
        return ping_result
    end,
    
    has_srv_seq_id = function(self)
    	return self.__srv_seq_id ~= nil
    end,
    
    new_client_ack_event = function(self)
    	if not self:has_srv_seq_id() then
    		return nil
    	end
    	
    	local client_ack_event = WebSocketRails.Event:new({'client_ack', {__srv_seq_id = self.__srv_seq_id}, self.connection_id})
    	return client_ack_event
    end,

    attributes = function(self)
        return {id = self.id, channel = self.channel, data = self.data}
    end,
    
    serialize = function(self)
        return json.encode( {self.name, self:attributes()} )
    end,

    run_callback = function(self, success, data)
        if success == true or success == "true" then
            if type(self.success_callback) == "function" then
                return self.success_callback(data)
            else
                return 0
            end
        else
            if type(self.failure_callback) == "function" then
                return self.failure_callback(data)
            else
                return 0
            end
        end
    end
}

dump_table = dump_table or function(the_table, level, dumped_objects)
    level = level or 1
    dumped_objects = dumped_objects or {}
    for k, v in pairs(the_table) do
        print( string.rep("  ", level) .. k, v )
        if type(v) == "table" and dumped_objects[v] == nil then
            dumped_objects[v] = true
            dump_table(v, level + 1, dumped_objects)
        end
        dumped_objects[v] = true
    end
end












