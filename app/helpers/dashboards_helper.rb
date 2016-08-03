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

  def top_states
    User.top_states.each do |state|

    end
  end

end
