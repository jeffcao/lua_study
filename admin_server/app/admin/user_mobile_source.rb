#encoding:utf-8
ActiveAdmin.register UserMobileSource do
  menu parent: "市场报表", url: '/admin/user_mobile_sources'

  config.clear_action_items!
  index do
    column "用户id",:user_id
    column "金额",:num
    column "明细",:source
    column "话费类型",:mobile_type
  end

  controller do
    def show
      user_id = params[:id]
      @records = UserMobileSource.where("user_id"=>user_id)
      render 'cx.html.erb',:layout => 'active_admin'
    end
  end

end
