#encoding: utf-8

class DebugLog
  def self.debug_msg(msg, game_debug_info=nil)
    if game_debug_info.nil?
      Rails.logger.debug("#{msg}.")
    else
      Rails.logger.debug("#{game_debug_info}, #{msg}.")
    end

  end
end