class DashboardController < ApplicationController
  def index
    @orders = Order.all
    @top_three_cities = City.three_with_most_users
    @top_three_states = State.three_with_most_users
  end
end
