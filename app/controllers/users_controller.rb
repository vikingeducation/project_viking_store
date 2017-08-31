class UsersController < ApplicationController
  
  def index
    @admin_info = User.admin_info
  end

  
end
