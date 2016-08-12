class DashboardController < ApplicationController
  def index
    @orders = Order.all
    @top_three_cities = User.top_three_cities
    @top_three_states = User.top_three_states
  end
end
