class HomeController < ApplicationController
  def index
  end

  def dashboard
    # Panel 1
    @panel1_total = [User.count, Order.count, Product.count]
    
    # Panel 2
    @panel2 = { 
      state_demos: User.top_states, 
      city_demos: User.top_cities, 
      top_user_by_order_value: User.highest_single_order_value,
      top_user_by_lifetime_value: User.highest_lifetime_value,
      top_user_by_average_order_value: User.highest_average_order_value,
      top_user_by_most_orders: User.most_orders_placed
    }
    # Panel 3
    @panel3 = {
      order_stats_last_7_days: Order.get_stats(Time.new(2017, 2, 23), 7),
      order_stats_last_30_days: Order.get_stats(Time.new(2017, 2, 23), 30),
      order_stats_total: Order.get_stats
    }
    # Panel 4
  end
end
