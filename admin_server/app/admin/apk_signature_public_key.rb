#encoding: utf-8
ActiveAdmin.register ApkSignaturePublicKey do
  menu :if => proc { can? :manage, ApkSignaturePublicKey }
  menu parent: "升级包管理"
  #scope_to :if =>proc{} do
  #  ApkSignaturePublicKey.where(id: 1)
  #
  #
  #end


  #config.comments = false
  #before_filter do
  #  @skip_sidebar = true
  #end
  #menu false
  #config.clear_action_items! # this will prevent the 'new button' showing u


  controller do

    #def index
    #  render 'view', :layout => 'active_admin'
    #end

    #def resource
    #  ApkSignaturePublicKey.where(id: 1)
    #
    #end

    #def scoped_collection
    #  ApkSignaturePublicKey.where(id: 1)
    #end

    def create
      record = ApkSignaturePublicKey.new
      record.name = params[:apk_signature_public_key][:name]
      record.public_key = params[:apk_signature_public_key][:public_key]
      record.code = params[:apk_signature_public_key][:code]
      record.save
      render "index",:layout => 'active_admin'
    end



    #def index
    #  @u_id = current_super_user.email
    #
    #  column :id
    #  column :name
    #  column "u_id" do
    #    @u_id
    #  end
    #  #column :public_key
    #  column "" do |apk_signature_public_key|
    #    links = ''.html_safe
    #    links += link_to I18n.t('active_admin.edit'), edit_resource_path(apk_signature_public_key), :class => "member_link edit_link"
    #    links += link_to I18n.t('active_admin.delete'), resource_path(apk_signature_public_key), :method => :delete, :confirm => I18n.t('active_admin.delete_confirmation'), :class => "member_link delete_link"
    #    if @u_id !="ming@cn6000.com"
    #      links += link_to I18n.t('active_admin.aprove'), resource_path(apk_signature_public_key), :method => :aprove
    #    end
    #    links
    #  end
    #
    #  #actions :defaults => false do |apk_signature_public_key|
    #  #
    #  #  #link_to "Edit", view_admin_apk_signature_public_key_path(apk_signature_public_key)
    #  #  #link_to 'Delete', admin_apk_signature_public_key_path(apk_signature_public_key), :method => :delete, :confirm => "Are you sure"
    #  #  #link_to 'Edit', edit_admin_apk_signature_public_key_path(apk_signature_public_key)
    #  #  #link_to "Delete", admin_post_path(apk_signature_public_key)
    #  #  #link_to "Search", admin_post_path(apk_signature_public_key)
    #  #end
    #end


  end


  collection_action :test, :method => :get do
    id=params[:id]
    id = current_super_user.email
    redirect_to({:action => :index}, :notice => "审核通过#{id}")
  end
  rows = ApkSignaturePublicKey.where(["id=?", 1])




  index do
    @u_id = current_super_user.email

    column :id
      column :name
      column "u_id" do
        @u_id
      end
      column :public_key
      column "" do |apk_signature_public_key|
        links = ''.html_safe
        links += link_to I18n.t('active_admin.edit'), edit_resource_path(apk_signature_public_key), :class => "member_link edit_link"
        links += link_to I18n.t('active_admin.delete'), resource_path(apk_signature_public_key), :method => :delete, :confirm => I18n.t('active_admin.delete_confirmation'), :class => "member_link delete_link"
        #if @u_id !="ming@cn6000.com"
          links += link_to I18n.t('active_admin.aprove'), resource_path(apk_signature_public_key), :method => :aprove
        #end
        links
      end

      #actions :defaults => false do |apk_signature_public_key|
      #
      #  #link_to "Edit", view_admin_apk_signature_public_key_path(apk_signature_public_key)
      #  #link_to 'Delete', admin_apk_signature_public_key_path(apk_signature_public_key), :method => :delete, :confirm => "Are you sure"
      #  #link_to 'Edit', edit_admin_apk_signature_public_key_path(apk_signature_public_key)
      #  #link_to "Delete", admin_post_path(apk_signature_public_key)
      #  #link_to "Search", admin_post_path(apk_signature_public_key)
      #end
  end

end
