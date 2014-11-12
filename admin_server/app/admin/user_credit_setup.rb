#encoding:utf-8
ActiveAdmin.register UserCreditSetup do
  menu parent: "用户相关"
  config.clear_action_items!
  #controller.authorize_resource
  controller do
    def create
      index
    end

    def index
      Rails.logger.debug("UserCreditSetup.index")
      Rails.logger.debug("UserCreditSetup.index, submitType=>#{params[:submitType]}")
      submitType = params[:submitType].to_i
      @return_value = 0
        if submitType == 1
          user_id = params[:userid]
          unless user_id.nil?
            user = User.find_by_user_id(user_id)
            if user.nil?
              @return_value = -1
            else
              user.user_profile.used_credit = 0
              user.user_profile.save
              @return_value = 1
            end
          end
        elsif submitType == 2
          strSql = "UPDATE user_profiles SET used_credit=0 where used_credit > 0"
          ActiveRecord::Base.connection.execute(strSql)
          @return_value = 1
        end
      render 'index', :layout => 'active_admin'
    end

  end
end