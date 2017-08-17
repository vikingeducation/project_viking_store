class DashboardController < ApplicationController
  def home
    render locals: {
      total_revenue: OrderContent.total_revenue
    }
  end
end
