class DashboardController < ApplicationController
  def index
    @top_states = User.top_states
    @top_cities = User.top_cities
    @top_users_with = [
      User.highest_single_order,
      User.highest_lifetime_order,
      User.highest_average_order,
    User.most_orders_placed]
    @last_7day_totals = [
      ['Users', User.new_users_count],
      ['Orders', Order.new_orders_count],
      ['New Products', Product.new_products_count],
      ['Recent Revenue', Order.recent_revenue(7).to_s(:currency, precision: 0)]
    ]
    @last_30day_totals = [
      ['Users', User.new_users_count(30)],
      ['Orders', Order.new_orders_count(30)],
      ['New Products', Product.new_products_count(30)],
      ['Recent Revenue', Order.recent_revenue(30).to_s(:currency, precision: 0)]
    ]
    @overall_totals = [
      ['Users', User.count],
      ['Orders', Order.count],
      ['New Products', Product.count],
      ['Revenue', Order.recent_revenue.to_s(:currency, precision: 0)]
    ]

  end
end
