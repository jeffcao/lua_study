require "rubygems"
gem 'activerecord', '3.2.12'
require 'mongoid'
require 'yaml'
require "json"
require "time"
require "active_record"
require "active_support"
require "mysql2"
require "redis/connection/synchrony"
require "redis"
require "redis/connection/ruby"

require 'active_support'
require 'active_model'
require 'active_support/concern'
require 'active_model/dirty'

require "../../game_push_message/lib/game_config"
require "../../game_push_message/lib/game_text"

require "../../model_module/models/base_model_helper"
require "../../model_module/models/redis_model_aware"
require "../../model_module/models/base_model"

require "../../model_module/models/match_arrangement"
require "../../model_module/models/special_match_arrangement"
require "../../model_module/models/game_match"
require "../../model_module/models/game_room"
require "../../model_module/models/game_room_info"

require "../../model_module/models/game_room_utility"
require "../../model_module/models/match_counter"

require "../../model_module/config/preinitializer"

p DDZRedis.syn_option
@@redis = Redis.new(DDZRedis.syn_option.merge(:driver => :ruby))
p @@redis

Redis.current = Redis.new(DDZRedis.syn_option)
p Redis.current

dataConfig = YAML::load(File.open("../../config/doudizhu/config/database.yml"))
ActiveRecord::Base.establish_connection(dataConfig["development"])

Mongoid.load!("../../config/doudizhu/config/mongoid.yml", :development)

class ResultCode
  include GameConfig
  include GameText

end

class Job
  def self.get_room(room_id)
    GameRoomUtility.get_room(room_id)
  end

  def self.arrange_room_match

    d_time = Time.now.strftime("%Y%m%d")+"000"
    d_time = d_time.to_i
    flag = GameMatch.where(:match_seq.gt=>d_time)
    if flag.count > 0
      return
    end

    rooms = GameRoom.all
    return if rooms.blank?

    rooms.each do |room|
      p room.room_type
      has_s_match = arrange_special_match(room.id, room.room_type)
      if has_s_match == 0
        arrange_match(room.id, room.room_type)
      end
    end
  end

  def self.arrange_match(room_id, room_type)
    p "arrange_match"


    lans = MatchArrangement.where(:room_type => room_type, :state => 0)
    p room_type
    p "arrange_match000"
    if lans.blank?
      return
    end
    p "arrange_match111"
    wday_plan = get_wday_plan(lans.first)
    if wday_plan.nil?
      return
    end
    p "arrange_match222"
    room = GameRoomUtility.get_room(room_id)
    room.base = wday_plan["match_ante"].to_i
    room.save
    create_match_seq(wday_plan["time_plan"], room_id, room_type, wday_plan["entry_fee"], wday_plan["match_ante"])
  end

  def self.get_wday_plan(match_plan)
    w_day = Time.now.wday
    return match_plan.monday if w_day == 1
    return match_plan.tuesday if w_day == 2
    return match_plan.wednesday if w_day == 3
    return match_plan.thursday if w_day == 4
    return match_plan.friday if w_day == 5
    return match_plan.saturday if w_day == 6
    return match_plan.sunday if w_day == 0
  end

  def self.arrange_special_match(room_id, room_type)
    p "arrange_special_match"
    s_day = Date.today

    s_plans = SpecialMatchArrangement.where(:room_type => room_type, :special_day => s_day, :state => 0)
    if s_plans.blank?
      return 0
    end
    s_plans.each do |plan|
      create_match_seq(plan.time_plan, room_id, room_type, plan.entry_fee, plan.match_ante)

      room = GameRoomUtility.get_room(room_id)
      room.base = plan.match_ante.to_i
      room.save
    end
  end

  def self.create_match_seq(time_plan, room_id, room_type, entry_fee, match_ante)
    return if time_plan.blank?
    p time_plan
    time_plan.each do |t_plan|
      b_time = t_plan["begin_time"]
      rule_name = t_plan["rule_name"] unless t_plan["rule_name"].nil?
      bonus_name = t_plan["bonus_name"] unless t_plan["bonus_name"].nil?
      entry_fee = t_plan["entry_fee"].nil? ? entry_fee : t_plan["entry_fee"]
      match_ante = t_plan["match_ante"].nil? ? match_ante : t_plan["match_ante"]
      end_time = b_time
      (1..t_plan["count"]).each do |i|
        b_time_h = b_time[0, 2].to_i
        b_time_m = b_time[3, 2].to_i

        end_time_h = b_time_h
        end_time_m = b_time_m + t_plan["duration"]
        # p "end_time_m=>#{end_time_m}"
        if end_time_m > 59
          end_time_h = end_time_h + end_time_m / 60
          end_time_m = "%02d" % (end_time_m % 60)
        end

        # p "end_time_h=>#{end_time_h}"
        break if end_time_h >= 24  and end_time_m.to_i > 0

        end_time_h = "%02d" % end_time_h
        # p "end_time_h=>#{end_time_h}"
        end_time = "#{end_time_h}:#{end_time_m}"
        # p "end_time=>#{end_time}"
        day = Time.now.to_s[0, 10]

        match = GameMatch.create()
        match.match_seq = new_match_seq
        match.room_id = room_id
        match.room_type = room_type
        match.entry_fee = entry_fee
        match.match_ante = match_ante
        match.rule_name = rule_name
        match.bonus_name = bonus_name
        match.begin_time = DateTime.parse("#{day} #{b_time}") - 8.hour
        # p match.begin_time
        match.end_time = DateTime.parse("#{day} #{end_time}") - 8.hour
        # p match.end_time
        match.status = 0
        match.save

        b_time = end_time
      end
    end
  end

  #def self.new_match_seq()
  #
  #  seq_const = Time.now.strftime("%Y%m%d")
  #  key = "#{seq_const}"
  #  MatchCounter.find_or_create_by(seq_key: key)
  #  seq_offset = MatchCounter.where(seq_key: key).find_and_modify({"$inc" => {seq_offset: 1}}, new: true)
  #  seq_const.to_i*1000 + seq_offset.seq_offset
  #end

  def self.new_match_seq()
    seq_const = Time.now.strftime("%Y%m%d")
    key = "#{seq_const}"
    MatchCounter.find_or_create_by(seq_key: key)
    seq_offset = MatchCounter.where(seq_key: key).find_and_modify({ "$inc"=>{seq_offset: 1} }, new: true )
    seq_const.to_i*1000 + seq_offset.seq_offset
  end

  def self.tomorrow_match_seq()
    t_time = 1.day.since(Time.now).strftime("%Y%m%d")+"000"
    t_time = t_time.to_i
    flag = GameMatch.where(:match_seq.gt=>t_time)
    if flag.count == 0
      rooms = GameRoom.all
      return if rooms.blank?

      rooms.each do |room|
        has_s_match = t_arrange_special_match(room.id, room.room_type)
        if has_s_match == 0
          t_arrange_match(room.id, room.room_type)
        end
      end
    else
      return
    end
  end

  def self.t_arrange_match(room_id, room_type)
    p "arrange_t_match"
    lans = MatchArrangement.where(:room_type => room_type, :state => 0)
    if lans.blank?
      return
    end
    wday_plan = t_get_wday_plan(lans.first)
    if wday_plan.nil?
      return
    end
    room = GameRoomUtility.get_room(room_id)
    room.base = wday_plan["match_ante"].to_i
    room.save
    t_create_match_seq(wday_plan["time_plan"], room_id, room_type, wday_plan["entry_fee"], wday_plan["match_ante"])
  end

  def self.t_get_wday_plan(match_plan)
    w_day = 1.day.since(Time.now).wday
    return match_plan.monday if w_day == 1
    return match_plan.tuesday if w_day == 2
    return match_plan.wednesday if w_day == 3
    return match_plan.thursday if w_day == 4
    return match_plan.friday if w_day == 5
    return match_plan.saturday if w_day == 6
    return match_plan.sunday if w_day == 0
  end

  def self.t_create_match_seq(time_plan, room_id, room_type, entry_fee, match_ante)
    return if time_plan.blank?
    p time_plan
    time_plan.each do |t_plan|
      b_time = t_plan["begin_time"]
      bonus_name = t_plan["bonus_name"] unless t_plan["bonus_name"].nil?
      rule_name = t_plan["rule_name"] unless t_plan["rule_name"].nil?
      entry_fee = t_plan["entry_fee"].nil? ? entry_fee : t_plan["entry_fee"]
      match_ante = t_plan["match_ante"].nil? ? match_ante : t_plan["match_ante"]
      end_time = b_time
      (1..t_plan["count"]).each do |i|
        b_time_h = b_time[0, 2].to_i
        b_time_m = b_time[3, 2].to_i

        end_time_h = b_time_h
        end_time_m = b_time_m + t_plan["duration"]
        # p "end_time_m=>#{end_time_m}"
        if end_time_m > 59
          end_time_h = end_time_h + end_time_m / 60
          end_time_m = "%02d" % (end_time_m % 60)
        end

        # p "end_time_h=>#{end_time_h}"
        break if end_time_h >= 24 and end_time_m.to_i > 0

        end_time_h = "%02d" % end_time_h
        # p "end_time_h=>#{end_time_h}"
        end_time = "#{end_time_h}:#{end_time_m}"
        # p "end_time=>#{end_time}"
        #day = Time.now.to_s[0, 10]
        day = 1.day.since(Time.now).to_s[0, 10]
        match = GameMatch.create()
        match.match_seq = t_new_match_seq
        match.room_id = room_id
        match.room_type = room_type
        match.entry_fee = entry_fee
        match.match_ante = match_ante
        match.rule_name = rule_name
        match.bonus_name = bonus_name
        match.begin_time = DateTime.parse("#{day} #{b_time}") - 8.hour
        # p match.begin_time
        match.end_time = DateTime.parse("#{day} #{end_time}") - 8.hour
        # p match.end_time
        match.status = 0
        match.save

        b_time = end_time
      end
    end
  end

  #def self.t_new_match_seq()
  #
  #  #seq_const = Time.now.strftime("%Y%m%d")
  #  seq_const = 1.day.since(Time.now).strftime("%Y%m%d")
  #  key = "#{seq_const}"
  #  MatchCounter.find_or_create_by(seq_key : key)
  #  seq_offset = MatchCounter.where(seq_key : key).find_and_modify({"$inc" => {seq_offset : 1}}, new : true)
  #  seq_const.to_i*1000 + seq_offset.seq_offset
  #end

  def self.t_new_match_seq()
    #seq_const = Time.now.strftime("%Y%m%d")
    seq_const = 1.day.since(Time.now).strftime("%Y%m%d")
    key = "#{seq_const}"
    MatchCounter.find_or_create_by(seq_key: key)
    seq_offset = MatchCounter.where(seq_key: key).find_and_modify({ "$inc"=>{seq_offset: 1} }, new: true )
    seq_const.to_i*1000 + seq_offset.seq_offset
  end

  def self.t_arrange_special_match(room_id, room_type)
    p "t_arrange_special_match"
    s_day = Date.tomorrow

    s_plans = SpecialMatchArrangement.where(:room_type => room_type, :special_day => s_day, :state => 0)
    if s_plans.blank?
      return 0
    end
    s_plans.each do |plan|
      t_create_match_seq(plan.time_plan, room_id, room_type, plan.entry_fee, plan.match_ante)

      room = GameRoomUtility.get_room(room_id)
      room.base = plan.match_ante.to_i
      room.save
    end
  end

end

Job.arrange_room_match
Job.tomorrow_match_seq
