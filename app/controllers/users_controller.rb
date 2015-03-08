class UsersController < ApplicationController
  def index
    @users = User.all
    render layout: "admin"
  end

  def show
    @user = User.find(params[:id])
  end
end
