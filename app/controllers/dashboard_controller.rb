class DashboardController < ApplicationController
  include DashboardHelper
  def index
    @users_seven_days = total_users(7)
  end
end
