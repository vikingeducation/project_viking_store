class DashboardController < ApplicationController

  def index
    user_count = User.count_new_users(7)
    order_count = Order.count_orders(7)
    new_products = Product.count_new_products(7)
    revenue = Order.calc_revenue(7)

    @data = { 'New Users' => user_count,
              'Orders' => order_count,
              'New Products' => new_products,
              'Revenue' => revenue
            }
  end

end
