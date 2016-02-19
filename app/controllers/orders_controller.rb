class OrdersController < ApplicationController
  def index
    @orders = Order.all_order_totals
  end

end
