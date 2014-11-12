module GameHallHelper
  def get_day_activity
    day = Time.now.wday
    activity = Activity.find_by_week_date(day)
    unless activity.nil?
      msg = {:name => activity.activity_name,
             :content => activity.activity_content,
             :object => activity.activity_object
      }
    end
    msg
  end

  def continue_login_get_beans(user_id)

    if Redis.current.exists("#{Time.now.to_s[0,10]}_#{user_id}")
      return 0
    end


    Rails.logger.debug("[continue_login_get_beans_user_id#{user_id}]")
    table = "login_logs_#{Time.now.to_s[0,7].gsub("-","")}"
    Rails.logger.debug("[continue_login_get_beans_table#{table}]")
    sql = "select count(*) as n from #{table} where user_id=#{user_id} and created_at like '%#{Time.now.to_s[0,10]}%'"
    count = LoginLog.connection.execute(sql)
    login_count = ""
    count.each do |n|
      login_count = n[0]
    end
    return 0 if login_count >1

    user = User.find_by_user_id(user_id)
    key = user.user_profile.consecutive
    return 1500 if key > 7
    key = key - 1

    beans = ResultCode::CONTINUE_LOGIN
    bean = beans[key].split("-")[1].to_i
    user.game_score_info.score = user.game_score_info.score + bean.to_i
    user.game_score_info.save
    Redis.current.set("#{Time.now.to_s[0,10]}_#{user_id}","continue_login")
    Redis.current.expire("#{Time.now.to_s[0,10]}_#{user_id}",3600*24)
    return [key+1,bean]
  end



end
