class AdminController < ApplicationController
  before_action :require_admin
  layout 'admin'


  private
    def require_admin
      unless current_user && current_user.id == 1
        flash[:danger] = "You must be an admin to access this page!"
        redirect_to root_url
      end
    end
end
