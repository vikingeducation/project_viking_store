module DashboardHelper

  def aggregate_data(day_range = nil)

    output = {'New Users' => User.count_new_users(day_range),
              'Orders' => Order.count_orders(day_range),
              'New Products' => Product.count_new_products(day_range),
              'Revenue' => Order.calc_revenue(day_range)
              }

    output

  end


end
