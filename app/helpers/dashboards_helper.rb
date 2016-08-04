module DashboardsHelper

  def get_totals
   {
    users: User.total_users,
    orders: Order.total_orders,
    revenue: OrderContent.total_revenue,
    products: Product.total_products
    }

  end

  def get_seven_day_totals
    {
    users: User.day_users_total(8),
    orders: Order.day_orders_total(8),
    revenue: OrderContent.day_revenue(8),
    products: Product.day_products_total(8)
    }
  end

  def get_thirty_day_totals
    {
    users: User.day_users_total(31),
    orders: Order.day_orders_total(31),
    revenue: OrderContent.day_revenue(31),
    products: Product.day_products_total(31)
    }
  end

  def get_top_states
    User.top_states.map do |state_row|
      [state_row.name, state_row.users_in_state]
    end.to_h
  end

  def get_top_cities
    User.top_cities.map do |city_row|
      [city_row.name, city_row.users_in_city]
    end.to_h
  end

  def get_best_customers
    highest_single_order = User.get_all_orders_highest_first[0]
    highest_lifetime_value = User.highest_lifetime_value[0]
    highest_avg_order = User.highest_avg_order[0]
    most_orders_placed = User.most_orders_placed[0]

    {
      "Highest Single Order Value" =>
        [highest_single_order.full_name, highest_single_order.order_total],
      "Highest Lifetime Value" =>
        [highest_lifetime_value.full_name, highest_lifetime_value.order_total],
      "Highest Average Order" =>
        [highest_avg_order.full_name, highest_avg_order.order_average],
      "Most Orders Placed" =>
        [most_orders_placed.full_name, most_orders_placed.orders]
    }
  end

  def get_seven_day_order_stats
    {
    "Number of Orders" => OrderContent.day_orders(8),
    "Total Revenue" => OrderContent.day_revenue(8),
    "Average Order Value" => OrderContent.average_order(8).round(2),
    "Largest Order Value" => OrderContent.largest_order(8)
    }
  end

  def get_thirty_day_order_stats
    {
    "Number of Orders" => OrderContent.day_orders(31),
    "Total Revenue" => OrderContent.day_revenue(31),
    "Average Order Value" => OrderContent.average_order(31).round(2),
    "Largest Order Value" => OrderContent.largest_order(31)
    }
  end


  def get_total_order_stats
    {
    "Number of Orders" => OrderContent.total_orders,
    "Total Revenue" => OrderContent.total_revenue,
    "Average Order Value" => OrderContent.average_order_total.round(2),
    "Largest Order Value" => OrderContent.largest_order_total
    }
  end

  def get_orders_per_day
    {
      "Today" => [OrderContent.order_num_on_day(0), OrderContent.order_num_on_day_value(0)],
      "Yesterday" => [OrderContent.order_num_on_day(1), OrderContent.order_num_on_day_value(1)],
      "#{2.days.ago.month}/#{2.days.ago.day}" => [OrderContent.order_num_on_day(2), OrderContent.order_num_on_day_value(2)],
      "#{3.days.ago.month}/#{3.days.ago.month}" => [OrderContent.order_num_on_day(3), OrderContent.order_num_on_day_value(3)],
      "#{4.days.ago.month}/#{4.days.ago.day}" => [OrderContent.order_num_on_day(4), OrderContent.order_num_on_day_value(4)],
      "#{5.days.ago.month}/#{5.days.ago.day}" => [OrderContent.order_num_on_day(5), OrderContent.order_num_on_day_value(5)],
      "#{6.days.ago.month}/#{6.days.ago.day}" => [OrderContent.order_num_on_day(6), OrderContent.order_num_on_day_value(6)],
    }
  end

  def get_orders_per_week
    {
      "This Week" => [OrderContent.order_num_on_week(0), OrderContent.order_num_on_week_value(0)],
      "Last Week" => [OrderContent.order_num_on_week(1),OrderContent.order_num_on_week_value(1)],
      "#{2.weeks.ago.month}/#{2.weeks.ago.day}" => [OrderContent.order_num_on_week(2),OrderContent.order_num_on_week_value(2)],
      "#{3.weeks.ago.month}/#{3.weeks.ago.day}" => [OrderContent.order_num_on_week(3),OrderContent.order_num_on_week_value(3)],
      "#{4.weeks.ago.month}/#{4.weeks.ago.day}" => [OrderContent.order_num_on_week(4),OrderContent.order_num_on_week_value(4)],
      "#{5.weeks.ago.month}/#{5.weeks.ago.day}" => [OrderContent.order_num_on_week(5),OrderContent.order_num_on_week_value(5)],
      "#{6.weeks.ago.month}/#{6.weeks.ago.day}" => [OrderContent.order_num_on_week(6),OrderContent.order_num_on_week_value(6)],
    }
  end

end
