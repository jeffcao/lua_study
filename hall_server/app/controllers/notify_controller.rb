class NotifyController < BaseController
  def self.event_ddz_socked_closed(cur_connection)
    Rails.logger.debug("[event_ddz_socked_closed] player_connection")
    user_id = cur_connection.data_store["current_user_id"].to_s
    Rails.logger.debug("[event_ddz_socked_closed] player_connection user_id=>#{user_id}")
    if user_id.blank?
      return
    end

    channel = user_id + "_hall_channel"
    notify_data = {:user_id => user_id,
                   :connection_id => cur_connection.id.to_s}
    WebsocketRails[channel].trigger("ui.ddz_socket_closed", notify_data)

    Rails.logger.debug("[event_ddz_socked_closed] publish ui.ddz_socket_closed, notify_data=>#{notify_data.to_json}.")
  end
end