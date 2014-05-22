PurchasePlugin = {}
--purchase logic
require 'AnzhiPurchase'
require 'ShouchonglibaoBuyBox'

function PurchasePlugin.bind_ui_buy_prop_event(channel)
	local event_name = PurchasePlugin.get_event_start() .. 'buy_prop'
	print('bind_ui_buy_prop_event event_name is', event_name)
	channel:bind(event_name, PurchasePlugin.on_server_notify_buy_finish_success)
end

function PurchasePlugin.on_server_notify_buy_finish_success(data)
	print("[PurchasePlugin:on_server_notify_buy_finish_success]")
	dump(data, 'on_server_notify_buy_finish_success, data=> ') 
	PurchasePlugin.show_back_message_box(data.content)

	local success = function(data) 
		GlobalSetting.current_user.score = data.score
		GlobalSetting.current_user.win_count = data.win_count
		GlobalSetting.current_user.lost_count = data.lost_count
	end
	--after buy finish success, there are something to do
	local scene = runningscene()
	
	if data.shouchong_finished then
		if tonumber(data.shouchong_finished) == 1 then
			GlobalSetting.shouchong_finished = 1
			GlobalSetting.shouchong_rank_changed = true
			if scene.on_shouchonglibao_finished then
				scene:on_shouchonglibao_finished()
			end
		else
			GlobalSetting.shouchong_finished = 0
			GlobalSetting.shouchong_ordered = false
		end

	end

	
	--update user info
	if scene.display_player_info then
		scene.after_trigger_success = __bind(scene.display_player_info, scene)
	else
		scene.after_trigger_success = success
	end

	if scene.get_user_profile then
		scene:get_user_profile()
	else
		local ws = GlobalSetting.hall_server_websocket
		if ws then
			local event_data = {retry="0", user_id = GlobalSetting.current_user.user_id}
			local failure = function(data) dump(data, 'get user profile after buy fail') end
			success = scene.display_player_info or success
			ws:trigger("ui.get_user_profile", event_data, success, failure)
		end
	end
	
	--use prop
	if scene.use_prop_bought  and tonumber(data.result_code) == 0 then
		scene:use_prop_bought(data)
	end
end

function PurchasePlugin.show_back_message_box(message)
	local dialog = createBackMessageBoxLayer(runningscene().rootNode)
	dialog:setMessage(message)
	dialog:show()
end

function PurchasePlugin.suggest_buy(type, title)
	local product = GlobalSetting.cache_prop[type]
	dump(product, 'suggest buy')
	product.title = title
	PurchasePlugin.show_buy_notify(product)
end

function PurchasePlugin.on_bill_cancel()
--[[
		if GlobalSetting.run_env == "test" then
			print('run env is test, do not cancel')
			return
		end
		local user_default = CCUserDefault:sharedUserDefault()
		local params = user_default:getStringForKey("on_bill_cancel")
		print('on_bill_cancel', params)
		user_default:setStringForKey("on_bill_cancel", "")
		if is_blank(params) then return end
		local index = string.find(params,'_')
		local trade_id = string.sub(params, 1, index - 1)
		local prop_id = string.sub(params, index+1)
		cclog('trade_id:%s, prop_id:%s', trade_id, prop_id)
		GlobalSetting.hall_server_websocket:trigger("ui.cancel_buy_prop",{trade_num=trade_id,prop_id=prop_id},
			function(data) dump(data, 'ui.cancel_buy_prop success') end,
			function(data) dump(data, 'ui.cancel_buy_prop fail') end
		)
]]
	print('do note cancel')
end

--product:consume_code,name,price,rmb
function PurchasePlugin.show_buy_notify(product, which)
	print("[PurchasePlugin:show_buy_notify]")
	--if GlobalSetting.run_env == 'test' then
	--	product.title = '为您的豆子保驾护航！'
	--	product.note = '开启后1个小时状态效果，记牌器显示3个人已出牌，方便您计算对方牌面，点击使反反复复反反复复反反复复方法发用。'
	--end
	
	local shouchonglibao = GlobalSetting.cache_prop["shouchongdalibao"]
	if shouchonglibao and tostring(shouchonglibao.id) == tostring(product.id) then
		PurchasePlugin.show_buy_shouchonglibao(product)
		return
	end
	
	local scene = runningscene()
	print('scene', scene.__cname)
	local buy = function() 
		ToastPlugin.show_progress_message_box(strings.pp_get_prop_info)
		scene.cur_product = product
		scene.cur_product.which = which or 1
		PurchasePlugin.buy_shouchonglibao = false
		PurchasePlugin.buy_prop(product.id)
	end
	local pay_type = getPayType()
	if pay_type == 'anzhi' or pay_type == 'leyifu' or pay_type == 'sikai' then
		local dialog = createAnzhiPurchase(buy)
		print('local dialog = createAnzhiPurchase(buy)')
		dialog:init(product)
		print('dialog:init(product)')
		dialog:attach_to(scene.rootNode)
		print('dialog:attach_to(scene.rootNode)')
		dialog:show()
		print('show buy notify dialog')
	elseif pay_type == 'cmcc' then
		if product.is_prompt then
			local dialog = createAnzhiPurchase(buy)
			dialog:init(product)
			dialog:attach_to(scene.rootNode)
			dialog:show()
		else
			buy()
		end
	end
end

function PurchasePlugin.show_buy_shouchonglibao(product, which)
	print("[PurchasePlugin:show_buy_shouchonglibao]")

	local scene = runningscene()
	print('scene', scene.__cname)
	local buy = function() 
		print("PurchasePlugin.show_buy_shouchonglibao.buy")
		print("PurchasePlugin.show_buy_shouchonglibao.buy, GlobalSetting.shouchong_ordered=> ", GlobalSetting.shouchong_ordered)
		
		if GlobalSetting.shouchong_ordered then
			ToastPlugin.show_message_box(strings.shouchong_warning) 
			return
		end
		
		ToastPlugin.show_progress_message_box(strings.pp_get_prop_info)
		scene.cur_product = product
		scene.cur_product.which = which or 1
		PurchasePlugin.buy_shouchonglibao = true
		PurchasePlugin.buy_prop(product.id)
		
	end
	
	local dialog = createShouchonglibaoBuyBox(buy)
	dialog:init(product)
	dialog:attach_to(scene.rootNode)
	dialog:show()
	
end

function PurchasePlugin.buy_prop(product_id)
	local failure_msg = strings.hscp_purchase_prop_w
	local event_data = {user_id = GlobalSetting.current_user.user_id, prop_id = product_id, payment=getPayType()}
	if getPayType() == 'sikai' then
		--pkg_version_code
		--has_sim_card
		local user_default = CCUserDefault:sharedUserDefault()
		local pkg_version_code = user_default:getStringForKey("pkg_version_code")
		local has_sim_card = user_default:getStringForKey("has_sim_card")
		event_data.app_version = pkg_version_code
		event_data.sim = has_sim_card
	end
	
	local ws = PurchasePlugin.get_buy_socket()
	if not ws then print('there is no websocket to buy') return end

	local failure_fuc = function(data) 
		dump(data, 'buy_prop failure') 
		ToastPlugin.hide_progress_message_box()
		ToastPlugin.show_message_box(failure_msg) 
	end
	local event_name = PurchasePlugin.get_event_start() .. 'buy_prop'
	print('buy_prop event_name is', event_name)
	if GlobalSetting.run_env == 'test' then
		ws:trigger(event_name, event_data, PurchasePlugin.do_on_buy_message_dev_test, failure_fuc)
	else
		ws:trigger(event_name, event_data, PurchasePlugin.do_on_buy_message, failure_fuc)
	end
	
end

function PurchasePlugin.do_on_buy_message_dev_test(data)
	print("[PurchasePlugin:do_on_buy_message_dev_test]")
	dump(data, "[PurchasePlugin:do_on_buy_message_dev_test], data=> ")
	if PurchasePlugin.buy_shouchonglibao then
		GlobalSetting.shouchong_ordered = true
	end
	ToastPlugin.hide_progress_message_box()
	if tonumber(data.result_code) ~= 0 then
		if data.content then
			PurchasePlugin.show_back_message_box(data.content)
		end
	end
	
end
--data:content
function PurchasePlugin.do_on_buy_message(data)
	print("[PurchasePlugin:do_on_buy_message]")
	if tonumber(data.result_code) ~= 0 then
		ToastPlugin.hide_progress_message_box()
		if tonumber(data.result_code) == 1 then
			local dialog = createYesNoDialog3(runningscene().rootNode)
			dialog:setMessage(data.content)
			dialog:setYesButton(function() dialog:dismiss() PurchasePlugin.do_confirm_buy(data) end)
			dialog:setNoButton(function() dialog:dismiss() end)
			dialog:show()
		elseif data.content then
			PurchasePlugin.show_back_message_box(data.content)
		end
	else
		PurchasePlugin.do_confirm_buy(data)
	end
end

--data:trade_num, prop_id
function PurchasePlugin.do_confirm_buy(data)
	ToastPlugin.hide_progress_message_box()
	runningscene().cur_buy_data = data
	local payType = getPayType()
	if payType == 'anzhi' then
		PurchasePlugin.anzhi_pay(data)
	elseif payType == 'cmcc' then
		PurchasePlugin.cmcc_pay(data)
	elseif payType == 'leyifu' then
		PurchasePlugin.leyifu_pay(data)
	elseif payType == 'sikai' then
		PurchasePlugin.sikai_pay(data)
	end
	if PurchasePlugin.buy_shouchonglibao then
		GlobalSetting.shouchong_ordered = true
	end
end

function PurchasePlugin.sikai_pay(data)
	local jni_helper = DDZJniHelper:create()
	local scene = runningscene()
	if GlobalSetting.run_env == 'test' and not data.cpparam then data.cpparam = '123456' end
	dump(scene.cur_product,'scene.cur_product')
	local j_data = {orderInfo = data.sky}
	local cjson = require("cjson")
	local status, s = pcall(cjson.encode, j_data)
	local str = 'on_pay_sikai__' .. s
	print('pay:', str)
	jni_helper:messageJava(str)
end

function PurchasePlugin.anzhi_pay(data)
	local jni_helper = DDZJniHelper:create()
	local scene = runningscene()
	if GlobalSetting.run_env == 'test' and not data.cpparam then data.cpparam = '123456' end
	dump(scene.cur_product,'scene.cur_product')
	local j_data = {price=scene.cur_product.rmb,which=data.which,desc=scene.cur_product.name,cpparam=data.cpparam,
					trade_id=data.trade_num,prop_id=data.prop_id}
	local cjson = require("cjson")
	local status, s = pcall(cjson.encode, j_data)
	local str = 'on_pay_anzhi__' .. s
	print('pay:', str)
	jni_helper:messageJava(str)
end

function PurchasePlugin.leyifu_pay(data)
	dump(data, 'leyifu data')
	local jni_helper = DDZJniHelper:create()
	local scene = runningscene()
	if GlobalSetting.run_env == 'test' and not data.cpparam then data.cpparam = '123456' end
	dump(scene.cur_product,'scene.cur_product')
	local j_data = {price=data.price,which=data.which,desc=scene.cur_product.name,cpparam=data.cpparam,
					consume_code=data.consume_code,prop_id=data.prop_id,prop_name=scene.cur_product.name,trade_id=data.trade_num}
	local cjson = require("cjson")
	local status, s = pcall(cjson.encode, j_data)
	local str = 'on_pay_leyifu__' .. s
	print('pay:', str)
	jni_helper:messageJava(str)
end

function PurchasePlugin.cmcc_pay(data)
	local jni_helper = DDZJniHelper:create()
	local scene = runningscene()
	if GlobalSetting.run_env == 'test' and not data.cpparam then data.cpparam = '123456' end
	dump(scene.cur_product,'scene.cur_product')
	local j_data = {billingIndex=data.billingIndex,cpparam=data.cpparam,trade_id=data.trade_num,prop_id=data.prop_id}
	local cjson = require("cjson")
	local status, s = pcall(cjson.encode, j_data)
	local str = 'on_pay_cmcc__' .. s
	print('pay:', str)
	jni_helper:messageJava(str)
end

function PurchasePlugin.get_buy_socket()
	local ws = GlobalSetting.hall_server_websocket or GlobalSetting.g_WebSocket
	return ws
end

function PurchasePlugin.get_event_start()
	local start = 'ui.'
	if GlobalSetting.g_WebSocket then start = 'g.' end
	return start
end