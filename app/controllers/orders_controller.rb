class OrdersController < ApplicationController

  before_action :require_login, :exclude => [:new, :create]

  def new

  end

  def create

  end

  def edit

    current_user
    @order = Order.find(params[:id])

  end

  def update

  end

  private

  def require_current_user

    unless current_user == Order.find(params[:id]).user_id
      flash[:error] = "Access Denied."
      redirect_to new_session_path
    end

  end
  
end
