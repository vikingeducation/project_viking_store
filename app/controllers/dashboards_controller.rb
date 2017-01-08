class DashboardsController < ApplicationController
  include DashboardsHelper

  def index
    # Panel 1: Overall metrics
    @last_7 = metrics(7)
    @last_30 = metrics(30)
    @total = metrics

    # Panel 2: User Demographics 
    @states = State.three_most_populated
    @cities = City.three_most_populated
    @highest_single_order_value = User.highest_single_order_value
    @highest_lifetime_value = User.highest_lifetime_value
    @highest_average_value = User.highest_average_order_value
    @most_orders_placed = User.most_orders_placed
  end
  
end
