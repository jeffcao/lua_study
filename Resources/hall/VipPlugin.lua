require "VIP"
VipPlugin = {}
local cjson = require "cjson"
function VipPlugin.bind(theClass)
	function theClass:checkVip()
 		local is_vip = (GlobalSetting.vip ~= cjson.null)
 		self.hall_vip_menu:setVisible(is_vip)
 		if not is_vip then return end
 		local fn = function()
 			local is_vip = GlobalSetting.vip and (GlobalSetting.vip ~= cjson.null)
 			if not is_vip then return false end
			local scene = CCDirector:sharedDirector():getRunningScene()
			local salary_getted = (GlobalSetting.vip.get_salary~=0)
			if scene ~= self or salary_getted then return false end
		
			local blink = CCBlink:create(2, 3)
			self.hall_vip_menu:runAction(blink)
			return true
		end
		local fn2 = function() fn() self.vip_blink_1 = nil end
		local fn3 = function() local re = fn() if not re then self.vip_blink = nil end return re end
		if not self.vip_blink_1 and not self.vip_blink then
			self.vip_blink_1 = Timer.add_timer(0.5, fn2, "vip_blink_1")
		end
		if not self.vip_blink then
			self.vip_blink = Timer.add_repeat_timer(5, fn3, "vip_blink")
		end
 	end
 	
 	function theClass:scene_on_become_vip()
		local is_vip = (GlobalSetting.vip and GlobalSetting.vip ~= cjson.null)
		print("scene_on_vip set vip menu visible to " .. tostring(is_vip))
		self.hall_vip_menu:setVisible(is_vip)
		self:checkVip()
	end
	
	function theClass:on_vip_click()
		self:do_to_vip()
	end
	
	function theClass:do_to_vip()
		local scene = createVIP()
		self.VIP = scene
		CCDirector:sharedDirector():pushScene(scene)
	end
end