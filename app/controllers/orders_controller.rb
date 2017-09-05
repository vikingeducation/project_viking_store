class OrdersController < ApplicationController
  def index
    @orders = Order.all

    render layout: "admin_portal"
  end
end
