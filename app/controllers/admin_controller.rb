class AdminController < ApplicationController
  def index
  end

  def analytics
    # Benchmark
    @before = Time.now

    # Overall Platform
    # Last 7 Days
    @user_count_last_week = User.count_since(7.days.ago)
    @order_count_last_week = Order.count_since(7.days.ago)
    @product_count_last_week = Product.count_since(7.days.ago)
    @order_revenue_last_week = Order.revenue_since(7.days.ago)

    # Last 30 Days
    @user_count_last_month = User.count_since(30.days.ago)
    @order_count_last_month = Order.count_since(30.days.ago)
    @product_count_last_month = Product.count_since(30.days.ago)
    @order_revenue_last_month = Order.revenue_since(30.days.ago)

    # Total
    @user_count = User.count
    @order_count = Order.count
    @product_count = Product.count
    @order_revenue = Order.revenue

    # User Demographics and Behavior
    # Top 3 States Users Live In (Billing)
    @top_user_states = User.count_by_state[0..2].map {|i| [i.state_name, i.num_users]}

    # Top 3 Cities Users Live In (Billing)
    @top_user_cities = User.count_by_city[0..2].map {|i| [i.city_name, i.num_users]}

    # Top Users With...
    @order_with_max_revenue = Order.with_max_revenue
    @user_with_max_spent = User.with_max_spent
    @user_with_max_avg_spent = User.with_max_avg_spent
    @user_with_max_placed_orders = User.with_max_placed_orders

    # Order Statistics
    # Last 7 Days
    @order_avg_revenue_last_week = Order.avg_revenue_since(7.days.ago)
    @order_with_max_revenue_last_week = Order.with_max_revenue_since(7.days.ago)

    # Last 30 Days
    @order_avg_revenue_last_month = Order.avg_revenue_since(30.days.ago)
    @order_with_max_revenue_last_month = Order.with_max_revenue_since(30.days.ago)

    # Total
    @order_avg_revenue = Order.avg_revenue
    @order_with_max_revenue = Order.with_max_revenue

    # Time Series Data
    # Orders by Day
    @orders_by_day = []
    days = ['Today', 'Yesterday']

    @order_revenue_by_day = Order.revenue_by_day
    @order_count_by_day = Order.count_by_day

    7.times do |i|
        @orders_by_day << [
        i > days.length - 1 ? i.days.ago.strftime('%m/%d') : days[i],
        @order_count_by_day[i].num_orders,
        @order_revenue_by_day[i].amount
      ]
    end

    # Orders by Week
    @order_revenue_by_week = Order.revenue_by_week
    @order_count_by_week = Order.count_by_week

    @orders_by_week = []
    7.times do |i|
      @orders_by_week << [
        (i + 1).weeks.ago.strftime('%m/%d'),
        @order_count_by_week[i].num_orders,
        @order_revenue_by_week[i].amount
      ]
    end
  end
end
