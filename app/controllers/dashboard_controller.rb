class DashboardController < ApplicationController

  def index
    @total_users = User.all.count
    @total_orders = Order.all.count
    @total_products = Product.all.count
    @total_revenue = OrderContent.total_revenue_since_days_ago(100000).first.total
    @users_last_thirty_days = User.created_since_days_ago(30)
    @orders_last_thirty_days = Order.created_since_days_ago(30)
    @products_last_thirty_days = Product.created_since_days_ago(30)
    @total_revenue_last_thirty_days = OrderContent.total_revenue_since_days_ago(30).first.total
    @users_last_seven_days = User.created_since_days_ago(7)
    @orders_last_seven_days = Order.created_since_days_ago(7)
    @products_last_seven_days = Product.created_since_days_ago(7)
    @total_revenue_last_seven_days = OrderContent.total_revenue_since_days_ago(7).first.total
    top_three_states = State.top_three_states
    @best_state_name = top_three_states.first.name
    @best_state_total = top_three_states.first.total
    @second_state_name = top_three_states.second.name
    @second_state_total = top_three_states.second.total
    @third_state_name = top_three_states.third.name
    @third_state_total = top_three_states.third.total
    top_three_cities = City.top_three_cities
    @best_city_name = top_three_cities.first.name
    @best_city_total = top_three_cities.first.total
    @second_city_name = top_three_cities.second.name
    @second_city_total = top_three_cities.second.total
    @third_city_name = top_three_cities.third.name
    @third_city_total = top_three_cities.third.total
  end

end
