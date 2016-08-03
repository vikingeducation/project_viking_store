class DashboardsController < ApplicationController

  include DashboardsHelper

  def index
    get_overall_panel
    get_demographics_panel
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
  end

end
