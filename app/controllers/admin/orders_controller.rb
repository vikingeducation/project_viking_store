class Admin::OrdersController < ApplicationController

  layout 'admin_portal_layout'

  def index
    if params[:user_id]
      @orders = Order.where(:user_id => params[:user_id])
      # @user = User.find(params[:user_id])
    else
      @orders = Order.all
      # @users = User.all
    end
  end





end
