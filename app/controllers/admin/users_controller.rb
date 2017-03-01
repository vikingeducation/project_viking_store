class Admin::UsersController < ApplicationController
  layout 'admin'
  def index
    @users = User.all.limit(10)
  end

  def new
    @user = User.new

  end

  def create
  end
end
