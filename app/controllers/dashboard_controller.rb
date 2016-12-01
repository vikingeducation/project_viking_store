class DashboardController < ApplicationController

  def index
    @dashboard = Dashboard.new

    @overall_platform   = @dashboard.overall_platform
    @user_demographics  = @dashboard.user_demographics
    @order_statistics   = @dashboard.order_statistics
    @time_series_data   = @dashboard.time_series_data
  end

end
