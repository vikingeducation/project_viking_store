class DashboardController < ApplicationController
  def index
    # Panel 1: Overall Platform
    @overall_7_days = get_overall_stats(7)
    @overall_30_days = get_overall_stats(730)
    @overall_total = get_overall_stats

    # Panel 2: User Demographics and Behavior
    @top_states = State.top_3_by_users
    @top_cities = City.top_3_by_users
    @behavior_stats = get_behavior_stats

    # Panel 3: Order Statistics
    @order_stats_7_days = Order.get_order_stats(7)
    @order_stats_30_days = Order.get_order_stats(30)
    @order_stats_total = Order.get_order_stats

    # Panel 4: Time Series Data
    @orders_by_day = Order.get_orders_by_time('day')
    @orders_by_week = Order.get_orders_by_time('week')
  end

  private

  def get_overall_stats(days_ago = nil)
    if days_ago
      {
        num_users: User.days_ago(days_ago).count,
        num_orders: Order.days_ago(days_ago).completed.count,
        num_products: Product.days_ago(days_ago).count,
        total_revenue: Order.get_revenue(days_ago)
      }
    else
      {
        num_users: User.all.count,
        num_orders: Order.completed.count,
        num_products: Product.all.count,
        total_revenue: Order.get_revenue
      }
    end
  end

  def get_behavior_stats
    [
      {criteria: 'Highest Single Order Value',
        result: User.get_highest_order_user,
        currency: true},
      {criteria: 'Highest Lifetime Value',
        result: User.get_highest_aggregation_user('SUM'),
        currency: true},
      {criteria: 'Highest Average Order Value',
        result: User.get_highest_aggregation_user('AVG'),
        currency: true},
      {criteria: 'Most Orders Placed',
        result: User.get_highest_aggregation_user('COUNT'),
        currency: false}
    ]
  end

end
