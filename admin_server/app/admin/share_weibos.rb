#encoding: utf-8

ActiveAdmin.register ShareWeibo do

  menu :if => proc{can? :manage,ShareWeibo}
  menu parent: "游戏相关配置"

  #controller.authorize_resource
  #index do
  #  column :id
  #  column "action" do |u|
  #    id = u.id
  #    #link_to "view", "http://localhost:4000/admin/share_weibos/#{u.id}"
  #    link_to "view", upload_admin_share_weibos_path({'id'=>id,"name"=>id})
  #  end
  #    default_actions
  #end
  #
  #member_action :approve, :method => :post do
  #
  #end
  #
  #collection_action :upload, :method => :get do
  #  id = params[:id]
  #  redirect_to( {:action => :index}, :notice => "#{id}")
  #
  #end


end
