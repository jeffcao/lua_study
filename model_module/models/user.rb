class User < ActiveRecord::Base

  attr_accessible :appid, :brand, :display, :fingerprint, :game_id, :imsi,
                  :mac, :manufactory, :model, :msisdn, :nick_name, :os_release,
                  :password_digest, :password_salt, :user_id, :version,
                  :login_token, :imei, :robot, :busy, :last_action_time,:game_level,:vip_level,:total_consume,:robot_type,:prize
  has_one :user_profile, :dependent => :destroy
  has_one :game_score_info, :dependent => :destroy
  has_many :game_user_cate, :dependent => :destroy, :conditions => {:used_flag => 0}
  has_many :used_cate, :dependent => :destroy
  has_many :user_product_item_count,:dependent => :destroy
  has_many :user_used_prop,:dependent => :destroy

  def self.create_new_user(params)
    user_attrs = self.accessible_attributes.to_a
    user_params = params.select { |k, v| user_attrs.include?(k.to_s) }
    new_user = User.new(user_params)
    new_user.user_id = UserId.generate_next_id
    new_user.user_profile || new_user.build_user_profile
    new_user.user_profile.last_login_at = Time.now
    new_user.user_profile.save
    new_user.save
    new_user
  end

  def self.back_msg_user_score(user) #用户登陆后积分信息返回
    user_score = user.game_score_info
    unless user_score.nil?
      message = {:score => user_score.score,
                 :win_count => user_score.win_count,
                 :lost_count => user_score.lost_count,
                 :flee_count => user_score.flee_count,
      }
    else
      message = nil
    end
    message
  end

  def self.back_msg_user_cate(user) #用户登陆后道具列表返回
    i = 0
    user_cates = user.game_user_cate
    unless user_cates.nil?
      message = Array.new
      user_cates.each do |user_cate|
        if user_cate.cate_count <= 0
          next
        end
        message[i] = {:prop_name => user_cate.cate.cate_name,
                      :prop_count => user_cate.cate_count,
        }
        i = i + 1
      end
    else
      message = nil
    end
    message
  end

  def self.back_msg_user_profile(user)
    @user = user
    @user_profile = @user.user_profile.reload(:lock=>true)
    if user.password_digest.nil? or @user_profile.email.nil?
      profile_flag = {:flag => 0} #个人资料需要完善
    else
      profile_flag = {:flag => 1} #个人资料已经完善
    end
    msg = {:user_id => @user.user_id,
           :gender => @user_profile.gender,
           :nick_name => @user_profile.nick_name,
           :email => @user_profile.email,
           :game_level => @user.game_level,
           :avatar => @user_profile.avatar

    }
    msg = msg.merge(profile_flag)
    msg
  end

  def to_s
    self.nick_name
  end

  def self.record_user_game_teach(user_id,moment)
  record = GameTeach.find_by_moment("#{moment}")
  return if record.nil?
  id = record.id
  record = UserGameTeach.find_by_user_id_and_game_teach_id(user_id,id)
  if record.nil?
    record = UserGameTeach.new
    record.user_id = user_id
    record.game_teach_id = id
    record.save
  end


  end



end

