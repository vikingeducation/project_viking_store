class OrdersController < ApplicationController

  #before_action :require_login

  def edit
    @order = session[:cart]
  end
end
