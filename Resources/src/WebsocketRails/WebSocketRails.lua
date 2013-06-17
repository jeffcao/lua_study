WebSocketRails = { 
	-- this will be overwrite by GlobalSetting
	config = {
		-- 连接最大重连次数
		CONNECTION_MAX_RETRIES = 6,
		-- 连接超时时间
		CONNECTION_TIMEOUT = 20, 
	
		-- 最大登陆重试次数
		LOGIN_MAX_RETRIES = 6,
		-- 登陆重试时间间隔
		LOGIN_RETRY_TIMEFRAME = 2,
		
		-- 事件重发次数
		EVENT_MAX_RESEND = 5,
		-- 事件重发时间间隔
		EVENT_RESEND_TIMEFRAME = 2,
		
		-- ping pong 时间间隔， 通常是服务器的间隔＋10
		PING_PONG_TIMEFRAME = 40,	
	} 
}

--require "WebSocketRails_Event"
--require "WebSocketRails_Connection"
--require "WebSocketRails_Channel"
--require "json"

WebSocketRails.SessionState = {
	SESSION_INVALID = 0,
	SESSION_OPEN = 1, 			-- websocket connected
	SESSION_CONNECTED = 2,  	-- got client_connected event from server
	SESSION_VERIFED = 3, 		-- session authenticated
	SESSION_CLOSED = 4,			-- session closed NORMALLY (by manual)
	SESSION_DISCONNECTED = 5,	-- websocket break, means need to re-connect
	SESSION_RECONNECTING = 6,	-- websocket reconnecting...
}


function WebSocketRails:new(url, use_websockets)
    local this_obj = {}
    setmetatable(this_obj, self)
    self.__index = self
    
    this_obj.url = url
    this_obj.use_websockets = true
    if use_websockets ~= nil then
        this_obj.use_websockets = use_websockets == true
    end
    
    this_obj.state = "connecting"
    this_obj.callbacks = {}
    this_obj.channels = {}
    this_obj.queue = {}
        
    this_obj.request_event_queue = {}
    
    this_obj.session_state = WebSocketRails.SessionState.INVALID
    this_obj._self_close = false
    
    this_obj._conn = WebSocketRails.WebSocketConnectionCC:new(url, this_obj)
    
    return this_obj
end

function WebSocketRails:new_message(data)
    local results = {}
    for _i = 1, #data do
        local socket_message = data[_i]
        --print("[WebSocketRails:new_message] socket_message => ")
        --dump_table(socket_message)
        local event = WebSocketRails.Event:new(socket_message)
        --print("[WebSocketRails:new_message] event => " .. event:serialize())
 		
 		ack_event = event:new_client_ack_event()
 		if ack_event ~= nil then
 			self._conn:trigger(ack_event)
 		end
        
        if event:is_result() then
         	--print("[WebSocketRails:new_message] event is result ", event.id, "   ", type(event.id))
            local _ref = self.queue[event.id]
            --print("_ref ==> " , _ref)
            if _ref ~= nil then
                --print("_ref ====>")
                --dump_table(_ref)
                --print("event ====>")
                --dump_table(event)
                _ref:run_callback(event.success, event.data)
            end
            self.queue[event.id] = nil
        elseif event:is_channel() then
            self:dispatch_channel(event)
        elseif event:is_ping() then
            self:pong()
        elseif event.name == "server_ack" then
        	if event.data and event.data.ack_id then
        		local req_event = self.request_event_queue[event.data.ack_id]
        		self.request_event_queue[event.data.ack_id] = nil
        		if req_event then
        			Timer.cancel_timer(req_event.timer_handler)
        		end
        	end
        else
            self:dispatch(event)
        end
        
        if self.state == 'connecting' and event.name == 'client_connected' then
            table.insert(results, #results + 1, self:connection_established(event.data) )
        else
            table.insert(results, #results + 1, 0)
        end
    end
    return results
end

function WebSocketRails:connection_established(data)
    self.state = 'connected'
    self.connection_id = data.connection_id
    self.session_state = WebSocketRails.SessionState.SESSTION_CONNECTED
    self._conn:flush_queue(data.connection_id)
    self:reset_channels()
    self.request_event_queue = {}
    if type(self.on_open) == "function" then
        return self.on_open(data)
    end
end

function WebSocketRails:bind(event_name, callback)
    if self.callbacks[event_name] == nil then
        self.callbacks[event_name] = {}
    end
    table.insert(self.callbacks[event_name], #self.callbacks[event_name] + 1, callback)
    return self.callbacks
end

function WebSocketRails:trigger(event_name, data, success_callback, failure_callback)
    local event = nil
    event = WebSocketRails.Event:new( {event_name, data, self.connection_id},
                                     success_callback,
                                     failure_callback )
    return self:trigger_event(event)
end

function WebSocketRails:trigger_event(event)
	print("[WebSocketRails:trigger_event] event => " .. event:serialize())
    if self.queue[event.id] == nil then
    	print("[WebSocketRails:trigger_event] store event into queue" , event.id, "  " , type(event.id))
        self.queue[event.id] = event
        self.request_event_queue[event.id] = {event=event}
        local event_id = event.id
        local resend_times = 0
        self.request_event_queue[event.id].timer_handler = Timer.add_repeat_timer(WebSocketRails.config.EVENT_RESEND_TIMEFRAME, function()
        	local pending_request = self.request_event_queue[event_id]
        	resend_times = resend_times + 1
        	if resend_times >= WebSocketRails.config.EVENT_MAX_RESEND or not pending_request then
        		if pending_request then
	        		self.request_event_queue[event_id] = nil
        		end
         		return false
        	end
        	pending_request.event.data.retries = resend_times
        	self._conn:trigger(pending_request.event)
        	return true
         end)
    end
    return self._conn:trigger(event)
end

function WebSocketRails:dispatch(event)
    if self.callbacks[event.name] == nil then
        return
    end
    
    local _ref = self.callbacks[event.name]
    local results = {}
    for _, callback in ipairs(_ref) do
        table.insert(results, #results + 1, callback(event.data))
    end
    
    return results
end

function WebSocketRails:dispatch_channel(event)
    --print("[WebSocketRails:dispatch_channel] self => ", self, " event => ", event)
    local channel = self.channels[event.channel]
    --print("[WebSocketRails:dispatch_channel] channel for " .. event.channel .. " is ==> ", channel)
    if channel == nil then
        --print("[WebSocketRails:dispatch_channel] no subscriber for channel: " .. event.channel)
        return
    end
    
    return channel:dispatch(event.name, event.data)
end

function WebSocketRails:subscribe(channel_name, success_callback, failure_callback)
    local channel = self.channels[channel_name]
    if channel == nil then
        channel = WebSocketRails.Channel:new(channel_name, self, false, success_callback, failure_callback)
        self.channels[channel_name] = channel
    end
    return channel
end

function WebSocketRails:subscribe_private(channel_name, success_callback, failure_callback)
    local channel = self.channels[channel_name]
    if channel == nil then
        channel = WebSocketRails.Channel:new(channel_name, self, true, success_callback, failure_callback)
        self.channels[channel_name] = channel
    end
    return channel
end

function WebSocketRails:reset_channels()
	self.channels = {}
end

function WebSocketRails:pong()
    --print("WebSocketRails.pong self => ", self )
    local pong_event = WebSocketRails.Event:new({'websocket_rails.pong', {}, self.connection_id})
    return self._conn:trigger(pong_event)
end

function WebSocketRails:close()
	self._self_close = true
	self._conn:close(true)
end
