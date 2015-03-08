class UsersController < ApplicationController

  layout "admin", only: [:index, :new, :show, :edit]

  def index
    @users = User.all
  end

  def show
    @user = User.find(params[:id])
  end
end
