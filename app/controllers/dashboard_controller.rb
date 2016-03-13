class DashboardController < ApplicationController

  def index
    @total_users = User.all.count
  end

end
