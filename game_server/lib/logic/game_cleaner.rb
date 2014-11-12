class GameCleaner
   def self.clear_game(notify_data)
     Rails.logger.info("GameCleaner.clear_game, notify_data=>#{notify_data}")
     Rails.logger.info("GameCleaner.clear_game, Process.pid=>#{Process.pid}")
     if notify_data.nil? or Process.pid.to_s != notify_data["p_id"].to_s
       return
     end
     rooms = GameRoomUtility.get_all_rooms
     rooms.each do |room|
       unless room.tables.blank?
          room.tables.each do |t_id|
            clear_table(t_id,room.room_id)
          end
       end
     end

     release_robot
   end
  def self.clear_table(table_id, room_id)
    Rails.logger.info("GameCleaner.clear_table, table_id=>#{table_id}, room_id=#{room_id}")

    if table_id.nil? or table_id.to_i ==0
      return
    end
    table = GameTable.get_game_table(table_id, room_id)
    if table.is_empty?
      Rails.logger.info("GameCleaner.clear_table, table.is_empty")
      return
    end
    if table.game_dead?
      players = table.get_players
      Rails.logger.debug("GameCleaner.clear_table, table.users=>#{table.users}")
      players.each do |p|
        p.on_leave_game if p.player_info.table_id.to_s == table_id.to_s
        table.on_player_leave(p.player_info.user_id)
      end
      table.init_game_info
      GameRoomUtility.set_table_available(table.table_info.room_id, table_id)
    end
  end

  def self.release_robot
    Rails.logger.info("GameCleaner.release_robot")
    busy_robots = User.where(:robot => 1, :busy => 1)
    busy_robots.each do |robot|
      player = Player.get_player(robot.user_id)
      unless player.in_game?
        Rails.logger.info("GameCleaner.release_robot, robot_id=>#{robot.user_id}")
        player.release
      end
    end
  end
end