class DashboardController < ApplicationController

  def index
    @dashboard = Dashboard.new

    @overall_platform   = @dashboard.overall_platform
    @user_demographics  = @dashboard.populate_user_demographics
    @order_statistics   = @dashboard.populate_order_statistics
    @time_series_data   = @dashboard.populate_time_series_data
  end

end
