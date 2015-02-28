class DashboardsController < ApplicationController
  def index
    @total_revenue = Order.total_revenue
    @total_orders = Order.total_orders
  end
end
