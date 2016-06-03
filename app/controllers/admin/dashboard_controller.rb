class Admin::DashboardController < AdminController
  def index
    time_begin = Time.now
# Panel 1
    
    # Helper find change
    def self.change(nb_current, nb_full)
      nb_past = nb_full - nb_current
      change = nb_current - nb_past
      change >= 0 ? (change = "+ #{change}") : (change = "- #{change.abs}")
    end

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

    # Change 30 days
    @change_thirty_days = {
      users: change(@overall_thirty_days[:users], User.new_users(60)),
      orders: change(@overall_thirty_days[:orders], Order.new_orders(60)),
      products: change(@overall_thirty_days[:products], Product.new_products(60)),
      revenue: change(@overall_thirty_days[:revenue], Order.revenue_days(60))
    }

    #7 days data
    @overall_seven_days = {
      users: User.new_users(7),
      orders: Order.new_orders(7),
      products: Product.new_products(7),
      revenue: Order.revenue_days(7)
    }

    # Change 7 days
    @change_seven_days = {
      users: change(@overall_seven_days[:users], User.new_users(14)),
      orders: change(@overall_seven_days[:orders], Order.new_orders(14)),
      products: change(@overall_seven_days[:products], Product.new_products(14)),
      revenue: change(@overall_seven_days[:revenue], Order.revenue_days(14))
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

# Panel 4
    @orders_by_time = {
      orders_by_day: Order.orders_by_day,
      orders_by_week: Order.orders_by_week
    }


    time_end = Time.now
    @process_time = time_end - time_begin
  end
end
