PurchasePlugin = {}
--purchase logic

function PurchasePlugin.bind_ui_buy_prop_event(channel)
	local event_name = PurchasePlugin.get_event_start(ws) .. 'buy_prop'
	print('bind_ui_buy_prop_event event_name is', event_name)
	channel:bind(event_name, PurchasePlugin.on_server_notify_buy_finish_success)
end

function PurchasePlugin.on_server_notify_buy_finish_success(data)
	print("[PurchasePlugin:on_server_notify_buy_finish_success]")
	PurchasePlugin.show_back_message_box(data.content)

	--after buy finish success, there are something to do
	local scene = runningscene()
	if scene.get_user_profile and scene.display_player_info then
		scene:get_user_profile()
		scene.after_trigger_success = __bind(scene.display_player_info, scene)
	end
end

function PurchasePlugin.show_back_message_box(message)
	local dialog = createBackMessageBoxLayer(runningscene())
	dialog:setMessage(message)
	dialog:show()
end

function PurchasePlugin.is_cm_sim_card()
	print("[PurchasePlugin:is_cm_sim_card]")
	local imsi = CCUserDefault:sharedUserDefault():getStringForKey("hw_imsi")
	print("[PurchasePlugin:show_buy_notify] imsi=> "..imsi)
	local is_cm_sim_card = false
	if not is_blank(GlobalSetting.cm_sim_card_prefix) and not is_blank(imsi) then
		print("[PurchasePlugin:is_cm_sim_card] GlobalSetting.cm_sim_card_prefix=> "..GlobalSetting.cm_sim_card_prefix)
		local cm_sim_card_flags = split(GlobalSetting.cm_sim_card_prefix, ",")
		for k, v in pairs(cm_sim_card_flags) do
			local f_index = string.find(imsi, v)
			if f_index ~= nil and f_index == 1 then
				is_cm_sim_card = true
				break
			end
		end
	end
	return is_cm_sim_card
end

--product:consume_code,name,price,rmb
function PurchasePlugin.show_buy_notify(product)
	print("[PurchasePlugin:show_buy_notify]")

	--check error
	local err_msg = nil
	is_cm_sim_card = PurchasePlugin.is_cm_sim_card()
	if is_blank(product.consume_code) then err_msg = strings.msp_purchase_no_code_w end
	if not is_cm_sim_card and GlobalSetting.run_env ~= "test" then err_msg = strings.msp_purchase_not_cmcc_w end
	if err_msg then PurchasePlugin.show_back_message_box(err_msg) return end

	--create show content
	local content = string.gsub(strings.msp_purchase_notify, "name", product.name)
	content = string.gsub(content, "price", product.price)
	content = string.gsub(content, "rmb", product.rmb)
	print("[PurchasePlugin:show_buy_notify] notify content=> "..content)

	local dialog = createYesNoDialog3(runningscene())
	dialog:setMessage(content)
	dialog:setMessageSize(19)
	dialog:setYesButton(function() dialog:dismiss() PurchasePlugin.do_buy_product(product) end)
	dialog:setNoButton(function() dialog:dismiss() end)
	if product.is_prompt then
		dialog:set_is_restricted(true)
	end
	if product.title then
		dialog.title:setString(product.title)
	end
	dialog:show()
end

--trigger websocket to notify server to buy something
function PurchasePlugin.do_buy_product(product)
	print("[PurchasePlugin:do_buy_product]")
	ToastPlugin.show_progress_message_box(strings.msp_purchase)

	PurchasePlugin.buy_prop(product.id)
end

function PurchasePlugin.buy_prop(product_id)
	local failure_msg = strings.hscp_purchase_prop_w
	local event_data = {user_id = GlobalSetting.current_user.user_id, prop_id = product_id, version="1.0"}

	local ws = PurchasePlugin.get_buy_socket()
	if not ws then print('there is no websocket to buy') return end

	local failure_fuc = function(data) dump(data, 'buy_prop failure') ToastPlugin.show_message_box(failure_msg) end
	local event_name = PurchasePlugin.get_event_start(ws) .. 'buy_prop'
	print('buy_prop event_name is', event_name)
	ws:trigger(event_name, event_data, PurchasePlugin.do_on_buy_message, failure_fuc)
end

--data:content
function PurchasePlugin.do_on_buy_message(data)
	print("[PurchasePlugin:do_on_buy_message]")
	if tostring(data.result_code) == "1" then
		local dialog = createYesNoDialog3(runningscene())
		dialog:setMessage(data.content)
		dialog:setYesButton(function() dialog:dismiss() PurchasePlugin.do_confirm_buy(data) end)
		dialog:setNoButton(function() dialog:dismiss() end)
		dialog:show()
	else
		PurchasePlugin.do_confirm_buy(data)
	end
end

--data:sms_content, send_num, trade_num, prop_id
function PurchasePlugin.do_confirm_buy(data)
	print("[PurchasePlugin:do_confirm_buy]")
	ToastPlugin.show_progress_message_box(strings.msp_purchase_pay_ing)

	--send sms
	local msg = "send_sms_" .. data.sms_content.."__"..data.send_num
	local jni_helper = DDZJniHelper:create()
	jni_helper:messageJava(msg)

	PurchasePlugin.timing_buy_prop(data.trade_num, data.prop_id)
end

--notify server has send sms to buy some prop, command to start time count
function PurchasePlugin.timing_buy_prop(trad_seq, product_id)
	local failure_msg = strings.hscp_purchase_prop_w
	local event_data = {user_id = GlobalSetting.current_user.user_id, prop_id = product_id, trade_id = trad_seq, version="1.0"}

	--temporary only can buy in hall and game websocket
	local ws = PurchasePlugin.get_buy_socket()
	if not ws then print('there is no websocket to buy') return end

	local timing_func = function(data) dump(data, 'timing func get data') end
	local event_name = PurchasePlugin.get_event_start(ws) .. 'timing_buy_prop'
	print('timing_buy_prop event_name is', event_name)
	ws:trigger(event_name, event_data, PurchasePlugin.on_timing_success, PurchasePlugin.on_timing_failure)
end

--timing success, hide progress message box and wait
function PurchasePlugin.on_timing_success(data)
	print("[PurchasePlugin:on_timing_success]")
	ToastPlugin.hide_progress_message_box()
end

--timing failure, hide progress message box, notify user failure and wait
function PurchasePlugin.on_timing_failure(data)
	print("[PurchasePlugin:on_timing_failure]")
	ToastPlugin.hide_progress_message_box()
	if not is_blank(data.result_message) then
		ToastPlugin.show_message_box(data.result_message)
	end
end

function PurchasePlugin.get_buy_socket()
	local ws = GlobalSetting.hall_server_websocket or GlobalSetting.g_WebSocket
	return ws
end

function PurchasePlugin.get_event_start(ws)
	local start = 'ui.'
	if ws == GlobalSetting.g_WebSocket then start = 'g.' end
	return start
end