class OrdersController < ApplicationController
  def index
    @orders = Order.all.order("orders.id")
  end
end
