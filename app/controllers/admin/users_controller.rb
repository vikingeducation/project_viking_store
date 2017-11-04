class Admin::UsersController < ApplicationController

  layout 'admin_portal_layout'

  def index
    @users = User.all
  end


  def new
  end


  def create
  end


  def show
    @user = User.find(params[:id])
  end


  def edit
  end


  def update
  end


  def destroy
  end


  private


end
