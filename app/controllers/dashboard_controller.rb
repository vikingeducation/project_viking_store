class DashboardController < ApplicationController
    layout 'application'

  def index
    @seven_days_users = User.seven_days_users
    @seven_days_orders = Order.seven_days_orders
    @seven_days_products = Product.seven_days_products
    @seven_days_revenue = Order.seven_days_revenue[0].sum

    @month_users = User.month_users
    @month_orders = Order.month_orders
    @month_products = Product.month_products
    @month_revenue = Order.month_revenue[0].sum

    @total_users =User.total_users
    @total_orders = Order.total_orders
    @total_products = Product.total_products
    @total_revenue_checked = Order.total_revenue_checked[0].sum_orders

    @top_three_cities = User.top_three_cities
    @top_three_states = User.top_three_states

    @highest_order_val = User.highest_order_val[0]
    @highest_lifetime_val = User.highest_lifetime_val[0]
    @highest_avg_order_val = User.highest_avg_order_val[0]
    @most_orders = User.most_orders[0]

    @num_of_orders_by_days = {7 => num_of_orders(7),
                            30 => num_of_orders(30),
                            'all_time' => num_of_orders}

    @total_revenue = {7 => total_revenue(7),
                    30 => total_revenue(30),
                    'all_time' => total_revenue}

    @avg_order_val = {7 => avg_order_val(7),
                    30 => avg_order_val(30),
                    'all_time' => avg_order_val}

    @large_order_val = {7 => large_order_val(7),
                        30 => large_order_val(30),
                        'all_time' => large_order_val}
  end



  private
    def num_of_orders(period = nil)
        Order.num_of_orders(period) unless Order.num_of_orders(period).nil?
    end

    def total_revenue(period = nil)
        Order.total_revenue(period)[0].sum_orders unless Order.total_revenue(period)[0].nil?
    end

    def avg_order_val(period = nil)
      Order.avg_order_val(period)[0] ? 0 : Order.avg_order_val(period)[0].avg_orders.round(2)
    end

    def large_order_val(period = nil)
        Order.large_order_val(period)[0].order_value unless Order.large_order_val(period)[0].nil?
    end

end
