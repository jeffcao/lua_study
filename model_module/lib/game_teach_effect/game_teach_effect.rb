#encoding: utf-8
class GameTeaching
  def self.get_game_teach(user_id, moment)
    Rails.logger.debug("[GameTeaching get_game_teach] user_id=>#{user_id},moment=>#{moment}")
    teach = GameTeach.find_by_moment(moment)
    return if teach.nil?
    id = teach.id
    message = {}
    if UserGameTeach.find_by_user_id_and_game_teach_id(user_id, id).nil? #判断展示过没
      new_record = UserGameTeach.new
      new_record.user_id = user_id
      new_record.game_teach_id = id
      new_record.save
      message = {:id => id, :content => teach.content, :moment => teach.moment}
    end
    message
  end

  def self.user_game_teach(user_id, type)
    teach = GameTeach.find_by_moment(type)
    return if teach.nil?
    record = UserGameTeach.find_by_user_id_and_game_teach_id(user_id, teach.id)
    if record.nil?
      user_teach = UserGameTeach.new
      user_teach.user_id = user_id
      user_teach.game_teach_id = teach.id
      user_teach.save
    end
  end

end
