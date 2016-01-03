class Admin::UsersController < ApplicationController
  layout 'admin'

  def index
    @users = User.all
  end

  def show
  end

  def edit
  end

  def new
  end
end
