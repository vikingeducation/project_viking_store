class DashboardController < ApplicationController
  def index

# Panel 1

    # Global Data
    @overall_total = {
      users: User.total,
      orders: Order.total,
      products: Product.total,
      revenue: Order.revenue
    }

    # 30 days data
    @overall_thirty_days = {
      users: User.new_users(30),
      orders: Order.new_orders(30),
      products: Product.new_products(30),
      revenue: Order.revenue_days(30)
    }

    #7 days data
    @overall_seven_days = {
      users: User.new_users(7),
      orders: Order.new_orders(7),
      products: Product.new_products(7),
      revenue: Order.revenue_days(7)
    }

# Panel 2

    # top cities and states
    @top_places = {
      states: State.top_states,
      cities: City.top_cities
    }

    # Highest Numbers
    @top_users = {
      single_value: User.single_highest_value,
      lifetime_value: User.highest_lifetime_value,
      average_value: User.highest_average_value,
      most_orders: User.most_orders_place
    }

# Panel 3

    # Order Statistic
    @total_stats = {
      orders: Order.total,
      revenue: Order.revenue,
      avg_order: Order.avg_order_value,
      largest_order: Order.largest_order_value
    }

    @thirty_days_stats = {
      orders: Order.new_orders(30),
      revenue: Order.revenue_days(30),
      avg_order: Order.avg_order_value_days(30),
      largest_order: Order.largest_order_value_days(30)
    }

    @seven_days_stats = {
      orders: Order.new_orders(7),
      revenue: Order.revenue_days(7),
      avg_order: Order.avg_order_value_days(7),
      largest_order: Order.largest_order_value_days(7)
    }
  end
end
