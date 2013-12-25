GameMatchPlugin = {}
require 'YesNoDialog'
function GameMatchPlugin.bind(theClass)
	function theClass:listen_match_event()
		MatchLogic.clear()
		MatchLogic.bind_match_channels(self, GlobalSetting.g_WebSocket, false)
		MatchLogic.listen('private_match_start', __bind(self.on_private_match_start, self))
		MatchLogic.listen('private_match_end', __bind(self.on_private_match_end, self))
	end
	
	--room_id, match_seq, notify_type, content, title
	function theClass:on_private_match_start(data)
		local scene = runningscene()
		local dialog = createYesNoDialog(scene.rootNode)
		dialog:setTitle('温馨提示')
		dialog:setMessage('比赛已开始，是否进入')--TODO
		dialog:setYesButton(function() 
			dialog:dismiss()
			self:onReturnClicked()
		end)
		dialog:show()
	end
	
	function theClass:on_private_match_end(data)
		dump(data,'game scene listen on_private_match_end')
	end
	
end