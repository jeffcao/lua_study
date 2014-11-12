#encoding: utf-8
require "logic/synchronization"
include GameShopPropHelper

class HallLogic

  def self.unicom_code(notify_data,channel)
    #Rails.logger.debug("on_test_user_close=> "+notify_data.to_json)
    #user_id = notify_data["user_id"].to_s
    #code_type = ['','sms_password','sms_code','voice_code' ]
    #type = notify_data["type"].to_i
    #channel = "#{user_id}_hall_channel"
    #if notify_data["status"].to_i == 0
    #  data = {:resule_code=>ResultCode::SUCCESS,:code_type=>code_type[type],:trade_num=>notify_data["trade_num"]}
    #  Rails.logger.debug("unicom_code.data =>#{data}")
    #else
    #  data = {:resule_code=>1,:code_type=>code_type[type],:content=>"失败"}
    #  Rails.logger.debug("unicom_code.data =>#{data}")
    #end
    #WebsocketRails[channel].trigger("ui.unicom_code", data)
    WebsocketRails[channel].trigger("ui.get_unicom_code", notify_data)


  end

  def self.on_test_user_close(notify_data)
    Rails.logger.debug("on_test_user_close=> "+notify_data.to_json)
    user_id = notify_data["user_id"].to_s
    type = notify_data["type"].to_s
    GameHallController.test_close_user(user_id, type)
  end

  def self.do_transaction_notify(notify_data)
    Rails.logger.debug("do_transaction_notify=> "+notify_data.to_json)
    cur_user_id = notify_data[:user_id].to_s
    Rails.logger.debug("do_transaction_notify=> cur_user_id =>" + cur_user_id.to_s)
    prop_id = notify_data[:game_product_id]
    flag = notify_data[:result_code].to_i
    status = notify_data[:status].to_i
    consume_code = notify_data[:consumeCode]
    tran_id = notify_data[:tran_id]

    Rails.logger.debug("do_transaction_notify, cur_user_idF=>#{cur_user_id}.")
    channel = cur_user_id + "_hall_channel"
    new_channel = "channel_#{cur_user_id}"
    prop = GameProduct.find(prop_id)
    if flag == 0
      user = User.find_by_user_id(cur_user_id)
      #buy_shop_prop(user,prop)
      content = " 您已经成功购买 \n 道具名：#{prop.product_name},\n 道具数量:1"
      if prop.product_name == ResultCode::SHOUCHONGDALIBAO
        content = ResultCode::SHOUCHONGLIBAO_SUCCESS
      end
      notify_data = {:content => content,
                     :result_code => ResultCode::SUCCESS,
                     :score => user.game_score_info.score,
                     :name => prop.product_name,
                     :prop_id => prop_id,
                     :price => prop.price.to_i,
                     :id => prop.product_product_item.first.game_product_item_id


      }
      Rails.logger.debug("do_transaction_notify, prop.product_name=>#{prop.product_name}.")

      if prop.product_name == ResultCode::SHOUCHONGDALIBAO
        notify_data = notify_data.merge({:shouchong_finished => 1})
        product_items = prop.product_product_item
        product_items.each do |prop_item|
          item = GameProductItem.find(prop_item.game_product_item_id)
          Rails.logger.debug("do_transaction_notify, item.beans=>#{item.beans.to_i}.")

          #if not item.using_point.nil? and item.using_point.to_i == 1 and item.respond_to?(:take_effect) and item.beans.to_i== 0
          if item.beans.to_i==0
            Rails.logger.debug("do_transaction_notify, item.beans=>#{item.beans}.")
            Rails.logger.debug("do_transaction_notify, item.id=>#{item.id}.")

            PropController.shouchong_use_cate(User.find_by_user_id(cur_user_id), item.id)
          end
        end
      end


    elsif status == 1906
      notify_data = {:billingIndex => consume_code[9, 3],
                     :consume_code => consume_code,
                     :trade_num => tran_id,
                     :cpparam => tran_id,
                     :result_code => 2,
                     :prop_id => prop_id
      }

    else

      notify_data = {:content => " 对不起，购买失败，请尝试重新\n购买或联系客服，联系电话:#{ResultCode::MOBILE}，\n(合作伙伴客服)",
                     :result_code => 1
      }
      if prop.product_name == ResultCode::SHOUCHONGDALIBAO
        notify_data = notify_data.merge({:shouchong_finished => 0})
      end
    end
    channel_connection_ids = WebsocketRails[channel].subscribers.collect { |c| c.id }.join(", ")
    Rails.logger.debug("do_transaction_notify, channel.subscribers=>#{channel_connection_ids}")
    notify_data["notify_id"] = BaseController.get_new_notify_id
    WebsocketRails[channel].trigger("ui.buy_prop", notify_data)
    WebsocketRails[new_channel].trigger("g.buy_prop", notify_data)

    Rails.logger.debug("do_transaction_notify, user is in this instance. channel=>#{channel},
            notify_data=>#{notify_data.to_json}")
  end

  def self.do_vip_level_notify(notify_data)
    Rails.logger.debug("do_vip_level_notify=> "+notify_data.to_json)
    user_id = notify_data[:user_id].to_s
    percent = notify_data[:percent]
    vip = notify_data[:vip_level]
    salary = notify_data[:salary]
    get_salary = notify_data[:get_salary]
    channel = user_id + "_hall_channel"
    data = {:get_salary => get_salary, :salary => salary, :user_id => user_id, :result_code => ResultCode::SUCCESS, :vip_level => vip, :notify_type => ResultCode::VIP_UP_TYPE, :percent => percent}
    Rails.logger.debug("do_vip_level_notify=> channel=>#{channel} data=>#{data}")

    WebsocketRails[channel].trigger("ui.routine_notify", data)
  end

  def self.do_user_level_notify(notify_data)
    Rails.logger.debug("do_user_level_notify=> "+notify_data.to_json)
    user_id = notify_data[:user_id].to_s
    game_level = notify_data[:game_level]
    channel = user_id + "_hall_channel"
    data = {:user_id => user_id, :result_code => ResultCode::SUCCESS, :game_level => game_level, :notify_type => ResultCode::LEVEL_UP_TYPE}
    Rails.logger.debug("do_user_level_notify=> channel=>#{channel} data=>#{data}")

    #WebsocketRails[channel].trigger("ui.routine_notify",data)
  end

  def self.get_game_server_instances
    tmp_instances = `ps aux |grep thin |grep ddz_game_server | awk '{print $2}'`
    tmp_instances = tmp_instances.split("\n")
    tmp_instances = tmp_instances - [tmp_instances.last]
  end

  def self.do_prop_expired_notify(notify_data)
    user = User.find(notify_data[:user_id])
    user_id = user.user_id
    prop_id = notify_data[:prop_id]

    prop = GameProductItem.find(prop_id)
    player = Player.get_player(user_id)

    return if prop.nil? or player.nil?

    prop.expired_notify(user_id, {:ref_user_id => player.player_info.id}) do |text, voice, u_id|
      notify_data = {:text => text, :voice => voice, :notify_type => ResultCode::PROP_EXPIRED_TYPE}
      channel = user_id.to_s + "_hall_channel"
      Rails.logger.debug("do_prop_expired_notify=> notify_data=>#{notify_data}")

      WebsocketRails[channel].trigger("ui.routine_notify", notify_data)
    end
  end

  def self.broadcast_message(event_name, message, options={})
    Rails.logger.info("broadcast_message => #{message.to_json}")
    success = options[:success]
    #options.merge! :connection => connection, :data => message, :id => options[:id]
    options.merge! :data => message, :id => options[:id]
    event = WebsocketRails::Event.new(event_name, options)

    @_dispatcher.broadcast_message event if @_dispatcher.respond_to?(:broadcast_message)
    Rails.logger.info("broadcast_message => #{message.to_json}")

  end

  def broadcast_msg

    bc_event_name = message["event_name"]
    bc_event_data = message["event_data"]

    my_channel = bc_event_data["channel"]

    options = {:success => bc_event_data["success"]}
    unless bc_event_data["id"].blank? or bc_event_data["id"] == "null"
      options[:id] = bc_event_data["id"].to_i
    end

    if my_channel.empty?
      broadcast_message bc_event_name, bc_event_data["data"], options
    else
      WebsocketRails[my_channel].test_trigger(bc_event_name, bc_event_data["data"], options)
    end

  end


end
