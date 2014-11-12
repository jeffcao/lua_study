class NotifyController < GameBaseController
  def self.event_ddz_socked_closed(cur_connection)
    Rails.logger.debug("[event_ddz_socked_closed] player_connection")
    user_id = cur_connection.data_store["current_user_id"].to_s
    Rails.logger.debug("[event_ddz_socked_closed] player_connection user_id=>#{user_id}")
    if user_id.blank?
      return
    end
    player =  Player.get_player(user_id)
    if player.player_info.table_id.blank? or player.player_info.table_id.to_i == 0
      return
    end
    table = GameTable.get_game_table(player.player_info.table_id, player.player_info.room_id)
    Rails.logger.debug("[event_ddz_socked_closed] player_connection table_id=>#{player.player_info.table_id.to_s}")

    notify_data = {:user_id => user_id,
                   :connection_id => cur_connection.id.to_s}
    GameController.trigger_personal_game_notify(player.player_info.user_id, "g.ddz_socket_closed",
                                                notify_data, table.table_info)
    Rails.logger.debug("[event_ddz_socked_closed] publish g.ddz_socket_closed, notify_data=>#{notify_data.to_json}.")
  end
end