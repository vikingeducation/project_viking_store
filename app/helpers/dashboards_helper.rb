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

end
