class DashboardController < ApplicationController
  def index
    @top_states = User.top_states
    @top_cities = User.top_cities
    @top_users_with = [User.highest_single_order, User.highest_lifetime_order, User.highest_average_order, User.most_orders_placed]
  end
end
