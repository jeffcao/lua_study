#encoding: utf-8
class GameServerController < ApplicationController
  # To change this template use File | Settings | File Templates.

  def prop_expired_notify
    logger.debug("[prop_expired_notify] params => #{params.to_json}")
    notify_data = {:user_id => params["userid"], :prop_id =>params["propid"]}

    respond_to do |format|
      format.text  { render :text => 'nk' }
    end

    GameLogic.do_prop_expired_notify notify_data

  end

  def user_enter_score_list
    return if params[:user_id].nil?
    user_id = params[:user_id].split(",")
    user_id.each do |id|
      notify_data = {:user_id => id,:content => "恭喜用户进入排行榜前50名"}
      GameLogic.user_enter_score_list(notify_data)
    end
  end

end