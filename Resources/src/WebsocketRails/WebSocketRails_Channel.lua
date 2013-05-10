WebSocketRails = WebSocketRails or {}

WebSocketRails.Channel = {
new = function(self, name, _dispatcher, is_private, _on_success_callback, _on_failure_callback)
    local this_obj = {}
    setmetatable(this_obj, self)
    self.__index = self
    
    this_obj.name = name
    this_obj._dispatcher = _dispatcher
    this_obj.is_private = is_private
    this_obj.on_sucess_callback = _on_success_callback
    this_obj.on_failure_callback = _on_failure_callback
    
    local event_name = "websocket_rails.subscribe"
    if this_obj.is_private then
        event_name = event_name .. "_private"
    end
    
    local event = WebSocketRails.Event:new({event_name,
                                            { data = {channel = this_obj.name} },
                                            this_obj._dispatcher.connection_id
                                           },
                                           function(data) this_obj:_success_launcher(data) end,
                                           function(data) this_obj:_failure_launcher(data) end )
    this_obj._dispatcher:trigger_event(event)
    this_obj._callbacks = {}
    
    return this_obj
end,

bind = function(self, event_name, callback)
    if self._callbacks[event_name] == nil then
        self._callbacks[event_name] = {}
    end
    
    table.insert(self._callbacks[event_name], #self._callbacks[event_name] + 1, callback)
end,
    
trigger = function(self, event_name, message)
    local event = WebSocketRails.Event:new({event_name,
                                            {
                                                channel = self.name,
                                                data = message
                                            },
                                           self._dispatcher.connection_id
                                           })
    return self._dispatcher:trigger_event(event)
end,
    
dispatch = function(self, event_name, message)
    --print("[Channel.dispatch] event_name => " .. event_name, " message =>" , json.encode(message))
    if self._callbacks[event_name] == nil then
        --print("[Channel.dispatch] no callback for " .. event_name)
        return
    end
    
    local results = {}
    local event_callbacks = self._callbacks[event_name]
    --print("[Channel.dispatch] event_callbacks => " , event_callbacks)
    dump_table(event_callbacks)
    for _, event_callback in ipairs(event_callbacks) do
        --print("[Channel.dispatch] invoke callback : ", event_callback)
        table.insert(results, #results + 1, event_callback(message))
    end
    
    return results
end,

_success_launcher = function(self, data)
    if type(self.on_sucess_callback) == "function" then
        self.on_sucess_callback(data)
    end
end,

_failure_launcher = function(self, data)
    if type(self.on_failure_callback) == "function" then
        self.on_failure_callback(data)
    end
end

}