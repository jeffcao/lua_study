class PlayerInfo
  include RedisModelAware
  define_dirty_attributes :id, :user_id, :avatar, :nick_name, :gender, :table_id,  :game_id, :room_id,
                          :is_robot, :is_tuoguan, :last_action_time, :poke_cards, :grab_lord, :player_role,
                          :lord_value, :state, :poke_card_count, :play_card_timeout_times, :dependence_user,
                          :timing_time, :current_action_seq ,:is_pause, :game_server_id, :is_lost,:vip_level,
                          :location
  define_json_attributes :poke_cards
  #location, 90--in_hall, x--is_the_room_type
  def redis_key_id
    self.user_id
  end

  def redis_key_id=(val)
    self.user_id = val
  end

  def self.redis_suffix
    ResultCode::USER_STATE_KEY_SUFFIX
  end

end