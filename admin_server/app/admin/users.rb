#encoding:utf-8
ActiveAdmin.register User do
  menu :if => proc{can? :manage,User}
  menu :priority => 1, :label => proc{"index"}
  menu parent: "用户相关"
  #controller.authorize_resource
  index do
    column :id
    column :nick_name
    column :appid
    #column("aabbc")  {|user| link_to "#{user.nick_name}","/admin/users/test?id=#{user.id}" }
    column :version
    column :created_at
    column :updated_at
    column :robot
    column :busy
    column :score do |user|
      user.game_score_info.score
    end
    default_actions
  end
  filter :nick_name, :as => :string
  filter :version, :as => :string
  filter :appid
  filter :robot

  collection_action :test, :method => :get do
    id = params[:id]
    render :xml => {user_count: "500",name: "#{id}" }
  end


  sidebar "test",:only => :show do
    attributes_table_for user do
      row("name") {user.nick_name}
      row("id") {user.id}
      row("robot") {user.robot}
      row("busy") {user.busy}
    end
  end




end
