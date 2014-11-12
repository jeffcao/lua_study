#encoding:utf-8
ActiveAdmin.register SuperUser do
  menu :if => proc{can? :manage,SuperUser}
  menu parent: "游戏相关配置"

  #controller.authorize_resource



  #form do |f|
  #  f.inputs "User Details" do
  #    f.input :email
  #    f.input :password
  #    f.input :password_confirmation
  #    f.input :superadmin, :label => "Super Administrator"
  #  end
  #  f.buttons
  #end
  #
  #create_or_edit = Proc.new {
  #  @user            = User.find_or_create_by_id(params[:id])
  #  #if @user.nil?
  #  #  id = params[:id]
  #  #  @user = SuperUser.find(id)
  #  #  #render :text=>params[:super_user][:password_confirmation]
  #  #  #return
  #  #
  #  render :text=>"#{@user.user_id}"
  #  return
  #  @user.superadmin = params[:user][:superadmin]
  #  @user.attributes = params[:user].delete_if do |k, v|
  #    (k == "superadmin") ||
  #        (["password", "password_confirmation"].include?(k) && v.empty? && !@user.new_record?)
  #  end
  #  if @user.save
  #    redirect_to :action => :show, :id => @user.id
  #  else
  #    render active_admin_template((@user.new_record? ? 'new' : 'edit') + '.html.erb')
  #  end
  #}
  #
  #
  #
  #controller do
  #  def update
  #    id = params[:id]
  #    super_user = SuperUser.find(id)
  #    render :text=>"#{super_user.email}"
  #
  #  end
  #end
  #member_action :create, :method => :post, &create_or_edit
  ##member_action :update, :method => :put, &create_or_edit

end                                   
