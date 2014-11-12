#encoding: utf-8

ActiveAdmin.register SystemMessage do
  menu parent: "游戏相关配置"


  #controller do
  #  def index
  #    render 'view',:layout=> 'active_admin'
  #
  #
  #  end
  #end





  #
  #form do |f|
  #  f.inputs :message_type do
  #    f.input :content
  #    f.input :message_type, as: :select, collection: [['闪现', 0],['滚动',0],['点击',2]]
  #  end
  #  f.buttons :value=>"aa"
  #end
  ##collection_action :test, :method => :get do
  ##  id=params[:id]
  ##  redirect_to( {:action => :index}, :notice => "上传成功#{id}")
  ##end
  #index do
  #  column :id
  #  column :content
  #  column :message_type
  #  column :failure_time
  #  column :created_at
  #  column :updated_at
  #  #column :public_key
  #  column "" do |apk_signature_public_key|
  #    links = ''.html_safe
  #    links += link_to I18n.t('active_admin.edit'), edit_resource_path(apk_signature_public_key), :class => "member_link edit_link"
  #    links += link_to I18n.t('active_admin.delete'), resource_path(apk_signature_public_key), :method => :delete, :confirm => I18n.t('active_admin.delete_confirmation'), :class => "member_link delete_link"
  #    links += link_to I18n.t('active_admin.aprove'), resource_path(apk_signature_public_key), :method => :aprove
  #    links
  #  end
  #
  #end


end
