require "result_code"
require "synchronization"
class ApplicationController < ActionController::Base
  include ApplicationHelper

  protect_from_forgery

  def authenticate_active_admin_user!
    authenticate_super_user!
    unless current_super_user.superadmin?
      flash[:alert] = "Unauthorized Access!"
      redirect_to root_path
    end
  end
end
