class AnalyticsController < ApplicationController

  def dashboard
    @new_users_7 = User.user_count(7)
    @orders_7 = Order.order_count(7)
    @new_product_7 = Product.product_count(7)
    @revenue_7 = "$#{Order.revenue(7)}"

    @new_users_30 = User.user_count(30)
    @orders_30 = Order.order_count(30)
    @new_product_30 = Product.product_count(30)
    @revenue_30 = "$#{Order.revenue(30)}"

    @users_total = User.user_count
    @orders_total = Order.order_count
    @product_total = Product.product_count
    @revenue_total = "$#{Order.revenue}"

    # -----------------------------------------------------

    @top_states = User.top_user_location('state')
    @top_cities = User.top_user_location('city')

    #------------------------------------------------------

    @highest_single_value = User.highest_value
    @highest_total_value = User.highest_value('total')
    @highest_average_value = User.highest_avg_order_value
    @most_orders_placed = User.most_order

    #------------------------------------------------------

    @orders_7 = Order.order_count(7)
    @revenue_7 = Order.revenue(7)
    @avg_order_value_7 = Order.avg_order_value(7)
    @largest_order_value_7 = Order.largest_order_value(7)

    @orders_30 = Order.order_count(30)
    @revenue_30 = Order.revenue(30)
    @avg_order_value_30 = Order.avg_order_value(30)
    @largest_order_value_30 = Order.largest_order_value(30)

    @orders_total = Order.order_count
    @revenue_total = Order.revenue
    @avg_order_value_total = Order.avg_order_value
    @largest_order_value_total = Order.largest_order_value

    #------------------------------------------------------

    @stats_7_days = Order.last_seven_days
    @stats_7_weeks = Order.last_seven_weeks

    def num_orders(days)
      Order.order_count(days)
    end
  end
end
