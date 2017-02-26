class DashboardController < ApplicationController
  include DashboardHelper
  def index

    # panel 1 overall
    @last_7day_totals = [
      ['Users', u = User.new_users_count, u - User.new_users_count(7, 1)],
      ['Orders', o = Order.new_orders_count(7), o - Order.new_orders_count(7, 1)],
      ['New Products', c = Product.new_products_count, c - Product.new_products_count(7, 1)],
      ['Revenue', r = Order.recent_revenue(7).to_s(:currency, precision: 0), (Order.recent_revenue(7) - Order.recent_revenue(7, 1)).to_s(:currency, precision:0)]
    ]
    @last_30day_totals = [
      ['Users', u = User.new_users_count, u - User.new_users_count(30, 1)],
      ['Orders', o = Order.new_orders_count(30), o - Order.new_orders_count(30, 1)],
      ['New Products', c = Product.new_products_count, c - Product.new_products_count(30, 1)],
      ['Revenue', r = Order.recent_revenue(30).to_s(:currency, precision: 0), (Order.recent_revenue(30) - Order.recent_revenue(30, 1)).to_s(:currency, precision:0)]
    ]
    @overall_totals = [
      ['Users', u = User.count],
      ['Orders', Order.count],
      ['New Products', Product.count],
      ['Revenue', Order.recent_revenue.to_s(:currency, precision: 0)]
    ]

    #panel 2 user demographics and behaviour
    @top_states = User.top_area('state')
    @top_cities = User.top_area('city')
    @top_users_with = [
      User.highest_single_order,
      User.highest_lifetime_order,
      User.highest_average_order,
    User.most_orders_placed]

    # panel 3 order statistics
    [7, 30, nil].each do |days|
      arrs = [
        ['Number of Orders', Order.new_orders_count(days)],
        ['Total Revenue', Order.recent_revenue(days).to_s(:currency, precision:0)],
        ['Average Order Value', Order.avg_order_val(days).to_s(:currency, precision:0) ],
        ['Largest Order Value', Order.largest_order_val(days).to_s(:currency, precision:0)],
        ['Top Shipping Destination', Order.top_state(days).first.name]
      ]
      instance_variable_set("@order_stats#{days || '_total'}", arrs)
    end
    # time series statistics
    @orders_by_day = Order.by_day
    @orders_by_week = Order.by_week
  end



end
