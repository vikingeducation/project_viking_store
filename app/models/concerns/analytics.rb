module Analytics
  extend ActiveSupport::Concern

  def panel_one
    @overall_seven_days = {
      "New Users" => User.new_users(7),
      "Orders" =>  Order.count_recent(7),
      "Products" => Product.new_products(7),
      "Revenue" => Order.revenue_recent(7) }
    @overall_thirty_days = {
      "New Users" => User.new_users(30),
      "Orders" =>  Order.count_recent(30),
      "Products" => Product.new_products(30),
      "Revenue" => Order.revenue_recent(30)
    }
    @overall_totals = {
      "Users" => User.total,
      "Orders" => Order.orders_total,
      "Products" => Product.total,
      "Revenue" => Order.revenue_total
    }
  end

  def panel_two
    # Top 3 States
    states_query = State.top_three_states
    @three_states = {}

    states_query.each do |state|
      @three_states[state.name] = state.state_count
    end

    # Top 3 Cities
    cities_query = City.top_three_cities
    @three_cities = {}

    cities_query.each do |city|
      @three_cities[city.name] = city.city_count
    end

    # Top User With...
    highest_single_order = User.highest_single_order
    highest_lifetime = User.highest_lifetime
    highest_average = User.highest_average
    most_ordered = User.most_ordered
    @data = [
      ["Item", "User", "Quantity"],
      ["Highest Single Order Value", highest_single_order.first.user, highest_single_order.first.order_value],
      ["Highest Lifetime Value", highest_lifetime.first.user, highest_lifetime.first.lifetime_total],
      ["Highest Average Order Value", highest_average.first.user, highest_average.first.avg_order_value],
      ["Most Orders Placed", most_ordered.first.user, most_ordered.first.order_count]
    ]
  end

  def panel_three
    @order_seven_days = {
      "Number of Orders" => @overall_seven_days["Orders"],
      "Total Revenue" => @overall_seven_days["Revenue"],
      "Average Order Value" => Order.average_order(7),
      "Largest Order Value" => Order.largest_order(7).first.largest_order
    }

    @order_thirty_days = {
      "Number of Orders" => @overall_thirty_days["Orders"],
      "Total Revenue" => @overall_thirty_days["Revenue"],
      "Average Order Value" => Order.average_order(30),
      "Largest Order Value" => Order.largest_order(30).first.largest_order
    }

    @order_totals = {
      "Number of Orders" => Order.orders_total,
      "Total Revenue" => Order.revenue_total,
      "Average Order Value" => Order.average_total,
      "Largest Order Value" => Order.largest_total
    }
  end

  def panel_four
    daily_timeseries = Order.daily_timeseries_orders
    @daily_timeseries_data = [
      ["Date", "Quantity", "Value"]
    ]
    daily_timeseries.each do |day|
      @daily_timeseries_data << [day.day, day.num_orders, day.daily_sum]
    end

    weekly_timeseries = Order.weekly_timeseries_orders
    @weekly_timeseries_data = [
      ["Date", "Quantity", "Value"]
    ]
    weekly_timeseries.each do |week|
      @weekly_timeseries_data << [week.week, week.num_orders, week.weekly_sum]
    end
  end

  def panel_five
    top_users = State.top_three_users
    @top_users_by_state = [
      ["State", "User", "Dollars Spent"]
    ]
    top_users.each do |user|
      @top_users_by_state << [user.state, user.user, user.spent]
    end

    # top_states_seven = State.top_state_shipped(7)
    # top_states_thirty = State.top_state_shipped(7)
    # @top_states = [
    #   ["Time Interval", "State", "Number of Orders"],
    #   ["Past 7 Days", top_states_seven.state, top_states_seven.order_count]
    # ]

  end
end
