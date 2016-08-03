class DashboardsController < ApplicationController

  include DashboardsHelper

  def index
    @totals = get_totals
    @thirty_day_totals = get_thirty_day_totals
    @seven_day_totals = get_seven_day_totals
    @top_states = top_states
  end

end
