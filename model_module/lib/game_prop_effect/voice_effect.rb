#encoding: utf-8

module VoiceEffect
  # To change this template use File | Settings | File Templates.

  def take_effect(user_id, args, &block)
    ratio = 100
    is_robot = false
    unless args.nil? or args[:is_robot].nil?
      is_robot = true
    end

    ratio = self.feature["affect_ratio"].to_i  unless self.feature["affect_ratio"].nil?
    rnd_ratio = 0
    rnd_ratio = rand(1..100) if is_robot
    if rnd_ratio <= ratio
      block.call(self.feature["text"], self.feature["voice"], user_id)
    end

  end
end

module VoiceEffectWithResponse
  def take_effect(user_id, args, &block)
    players = args[:players]

    block.call(self.feature["text"], self.feature["voice"], user_id)

    prop = GameProductItem.find_by_item_name("专属音效23")
    players.each do |p|
      p.response_chat(prop, &block)
    end
  end
end

module VoiceEffectRefRobot
  def take_effect(user_id, args, &block)

  end
end

