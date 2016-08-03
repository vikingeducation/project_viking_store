class DashboardsController < ApplicationController

  include DashboardsHelper

  def index
    get_overall_panel
    get_demographics_panel
    get_order_stats_panel
  end


  private

  def get_overall_panel
    @totals = get_totals
    @thirty_day_totals = get_thirty_day_totals
    @seven_day_totals = get_seven_day_totals
  end

  def get_demographics_panel
    @top_states = get_top_states
    @top_cities = get_top_cities
    @best_customers = get_best_customers
  end

  def get_order_stats_panel
    @seven_day_order_stats = get_seven_day_order_stats
    @thirty_day_order_stats = get_thirty_day_order_stats
    @total_order_stats = get_total_order_stats
  end

end
