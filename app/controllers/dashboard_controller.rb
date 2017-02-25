class DashboardController < ApplicationController
  include DashboardHelper
  def index

    #panel 2 user demographics and behaviour
    @top_states = User.top_states
    @top_cities = User.top_cities
    @top_users_with = [
      User.highest_single_order,
      User.highest_lifetime_order,
      User.highest_average_order,
    User.most_orders_placed]

    # panel 1 overall
    @last_7day_totals = [
      ['Users', User.new_users_count],
      ['Orders', Order.new_orders_count(7)],
      ['New Products', Product.new_products_count],
      ['Recent Revenue', Order.recent_revenue(7).to_s(:currency, precision: 0)]
    ]
    @last_30day_totals = [
      ['Users', User.new_users_count(30)],
      ['Orders', Order.new_orders_count(30)],
      ['New Products', Product.new_products_count(30)],
      ['Recent Revenue', Order.recent_revenue(30).to_s(:currency, precision: 0)]
    ]
    @overall_totals = [
      ['Users', User.count],
      ['Orders', Order.count],
      ['New Products', Product.count],
      ['Revenue', Order.recent_revenue.to_s(:currency, precision: 0)]
    ]

    # panel 3 order statistics
    [7, 30, nil].each do |days|
      arrs = [
        ['Number of Orders', Order.new_orders_count(days)],
        ['Total Revenue', Order.recent_revenue(days).to_s(:currency, precision:0)],
        ['Average Order Value', Order.avg_order_val(days).to_s(:currency, precision:0) ],
        ['Largest Order Value', Order.largest_order_val(days).to_s(:currency, precision:0)]
      ]
      instance_variable_set("@order_stats#{days || '_total'}", arrs)
    end
    # time series statistics
    @orders_by_day = Order.by_day
    @orders_by_week = Order.by_week
  end


end
