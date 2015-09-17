class OrdersController < ApplicationController
  def index
      @orders = Order.all.order("user_id asc")
  end
end
