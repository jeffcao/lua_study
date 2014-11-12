module BaseHelper
  def user_legal(user_id)
    user = get_user(user_id)
    token = user.login_token
    if Redis.current.exists(token)
      false
    else
      true
    end
  end
end
