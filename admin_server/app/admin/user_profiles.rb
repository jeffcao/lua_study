#encoding:utf-8
ActiveAdmin.register UserProfile do
  menu :if => proc{can? :manage,UserProfile}
  menu :priority => 1, :label => proc{"index"}
  menu parent: "用户相关"
  #controller.authorize_resource
  index do
   column :id
   column :nick_name
   column :gender
   column :email
   column :appid
   column :last_login_at
   column :created_at
   column :updated_at
   column :birthday
   column :version
   column :avatar
    default_actions
  end


  filter :nick_name, :as => :string
  filter :version, :as => :string
  filter :appid
  filter :id
  filter :last_login_at
  filter :created_at
  filter :updated_at




end
