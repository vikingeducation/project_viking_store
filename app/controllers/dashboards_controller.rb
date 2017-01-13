class DashboardsController < ApplicationController
  include DashboardsHelper

  def index
    # Panel 1: Overall metrics
    @last_7_overall = metrics(7)
    @last_30_overall = metrics(30)
    @total_overall = metrics

    # Panel 2: User Demographics 
    @states = State.three_most_populated
    @cities = City.three_most_populated
    @highest_single_order_value = User.highest_single_order_value
    @highest_lifetime_value = User.highest_lifetime_value
    @highest_average_value = User.highest_average_order_value
    @most_orders_placed = User.most_orders_placed

    # Panel 3: Order Stats
    @last_7_stats = order_stats(7)
    @last_30_stats = order_stats(30)
    @total_stats = order_stats

    # Panel 4: Time Series
    @by_day = Order.by_day
    @by_week = Order.by_week
  end

  def admin
  end
  
end
