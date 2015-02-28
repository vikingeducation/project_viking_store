class DashboardsController < ApplicationController
  def index
    @total_revenue = Order.total_revenue
  end
end
