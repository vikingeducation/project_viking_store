class Admin::UsersController < ApplicationController
  layout 'admin'
  def index
    @users = User.all.limit(10)
  end

  def show
    @user = User.find(params[:id])

  end

  def new
    @user = User.new
  end

  def edit
    @user = User.find(params[:id])

  end

  def create
  end


end
