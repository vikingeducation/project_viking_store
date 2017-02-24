class HomeController < ApplicationController
  def index
  end

  def dashboard
    # start_time = Time.now
    start_time = Time.new(2017, 2, 23)

    # Panel 1
    @panel1 = {
      overall_platform_last_7_days: overall_platform(start_time, 7),
      overall_platform_last_30_days: overall_platform(start_time, 30),
      overall_platform_total: overall_platform
    } 
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
      order_stats_last_7_days: Order.get_stats(start_time, 7),
      order_stats_last_30_days: Order.get_stats(start_time, 30),
      order_stats_total: Order.get_stats
    }
    # Panel 4
    @panel4 = {
      orders_by_day: Order.get_time_series_data(start_time, 'day', 7),
      orders_by_week: Order.get_time_series_data(start_time, 'week', 7)
    }
  end

  private

  def overall_platform(start = Time.now, days_ago = nil)
    { new_users: User.get_num_of_new_users(start, days_ago), 
      orders: Order.number_of_orders(start, days_ago),
      new_products: Product.get_num_of_new_products(start, days_ago),
      revenue: sprintf('$%.2f', Order.total_revenue(start, days_ago))
    }
  end
end
