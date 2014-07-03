--require "FullMubanStyleLayer"
require "src.UIControllerPlugin"
require "src.HallServerConnectionPlugin"
require "src/WebsocketRails/Timer"
require "src.Stats"
require "src.AppStats"

VIP = class("VIP", function()
	print("new VIP")
	return display.newScene("VIP")	
end
)

local vip_kuang_scales = {85/138,90/138,90/138,1}

function createVIP()
	print("create VIP")
	return VIP.new()
end

function VIP:ctor()
	
	self.on_get_vip_salary_clicked = __bind(self.on_get_vip_salary, self)
	ccb.VIP = self
	
	local ccbproxy = CCBProxy:create()
 	local node = CCBReaderLoad("VIP.ccbi", ccbproxy, false, "")
	
	local layer = createFullMubanStyleLayer()
	self:addChild(layer)
	layer:setTitle("wenzi_VIP.png")
	layer:setContent(node)
 	
 	local function valueChanged(strEventName,pSender)
		local value = pSender:getValue()
    end
    --Add the slider
    local track_scale9 = CCSprite:createWithSpriteFrameName("VIP_hongse.png")
    local track_scale9_2 = CCSprite:createWithSpriteFrameName("VIP_heise.png")
    local thumb = CCSprite:createWithSpriteFrameName("VIP_jiantou.png")
    local pSlider = CCControlSlider:create(track_scale9_2,track_scale9 ,thumb)
    pSlider:setMinimumValue(0) 
    pSlider:setMaximumValue(100) 
	pSlider:setTag(1001)
	pSlider:setValue(50)
	pSlider:setPosition(ccp(343,10))
	self.progress_bar_layer:addChild(pSlider)
	pSlider:setEnabled(false)
	pSlider:addHandleOfControlEvent(valueChanged, CCControlEventValueChanged)
	
	dump(GlobalSetting.vip, "vip is=>")
	
	local vip = GlobalSetting.vip
	
	--设置VIP进度的图标
	for index=1,4 do
		local icon = "S_" ..tostring(38 + 2 * index) .. "_vip"
		local icon_name = icon..".png"
		if index > tonumber(vip.vip_level) then icon_name = icon.."_weijihuo.png" end
		local sprite_name = "vip_sprite_"..index
		local frame = CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName(icon_name)
		self[sprite_name]:setDisplayFrame(frame)
	end
	
	
	--设置VIP进度条
	pSlider:setValue(vip.percent) 
	
	--设置VIP图标
	local vip_icon = "S_" ..tostring(38 + 2 * vip.vip_level) .. "_vip.png"
	self.vip_sprite:setDisplayFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName(vip_icon))
	
	--设置VIP称号
	local vip_names = {"初级VIP","中级VIP", "高级VIP", "特级VIP"}
	self.vip_level_lbl:setString(vip_names[tonumber(vip.vip_level)])
	
	--设置VIP工资
	self.tequan_lbl:setString("每天发放"..vip.salary.."工资")
	
	--设置领工资
	local not_get = (vip.get_salary==0)
	self:set_get_salary(not_get)
	

 	scaleNode(self.rootNode, GlobalSetting.content_scale_factor)
 	
 	--设置VIP框的缩放
	
	self.vip_kuang:setScale(vip_kuang_scales[tonumber(vip.vip_level)] * GlobalSetting.content_scale_factor)
	
end

function VIP:set_get_salary(enbale)
	self.vip_get_salary_item:setEnabled(enbale)
	if enbale then 
		self.vip_get_salary_lbl:setString("领 工 资") 
		set_anniu_1_3_stroke(self.vip_get_salary_lbl)
	else
		self.vip_get_salary_lbl:setString("已 领 取") 
		set_black_stroke(self.vip_get_salary_lbl)
	end
end

function VIP:onEnter()
	Stats:on_start("vip")
end

function VIP:onExit()
	Stats:on_end("vip")
end

function VIP:on_get_vip_salary()
	print("[VIP:on_get_vip_salary]")
	AppStats.event(UM_VIP_BONUS)
	self:show_progress_message_box("领取今日工资")
	self:get_vip_salary()
end

function VIP:do_on_trigger_success(data)
	print("[VIP:do_on_trigger_success]")
	self:hide_progress_message_box()
	--self.vip_get_salary_item:setEnabled(false)
	self:set_get_salary(false)
	if data.result_code == 0 then
		self:show_message_box_suc("恭喜您领取了今天的工资"..data.salary.."豆子")
		GlobalSetting.vip.get_salary = 1
		GlobalSetting.current_user.score = tonumber(GlobalSetting.current_user.score) + tonumber(data.salary)
	--	GlobalSetting.current_user.score = data.score
	--	GlobalSetting.current_user.game_level = data.game_level
	end
end

function VIP:do_on_trigger_failure(data)
	print("[VIP:do_on_trigger_failure]")
	self:hide_progress_message_box()
	self:show_message_box(self.failure_msg)
end

UIControllerPlugin.bind(VIP)
HallServerConnectionPlugin.bind(VIP)
SceneEventPlugin.bind(VIP)