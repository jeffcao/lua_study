class GameTableInfo
  include RedisModelAware

  define_dirty_attributes :room_table_id, :table_id, :bombs, :lord_card, :all_bombs, :lord_value,:prev_user_id,
                          :state, :lord_user_id, :lord_turn, :game_id, :room_id, :spring, :channel_name,
                          :anti_spring, :lord_card_count, :all_out_card, :next_user_id, :last_user_id,
                          :game_result, :current_action_seq, :game_sequence, :last_action_time
  define_json_attributes  :lord_turn , :all_out_card, :lord_card, :game_result

  def redis_key_id
    self.room_table_id
  end

  def redis_key_id=(val)
    self.room_table_id = val
  end

  def self.redis_suffix
    ResultCode::TABLE_KEY_SUFFIX
  end

end