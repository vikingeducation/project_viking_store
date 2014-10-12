class UsersController < ApplicationController

  def index
    @users = User.all
    render :layout => "admin_interface"
  end

  def show
    @user = User.find(params[:id])
    render :layout => "admin_interface"
  end
end
