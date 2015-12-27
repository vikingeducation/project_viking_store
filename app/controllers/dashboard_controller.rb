class DashboardController < ApplicationController
  def index
    # Panel 1: Overall Platform
    @overall_7_days = get_overall_stats(7)
    @overall_30_days = get_overall_stats(730)
    @overall_total = get_overall_stats

    # Panel 2: User Demographics and Behavior
    @top_states = State.top_3_by_users
    @top_cities = City.top_3_by_users
    @behavior_stats = [
      {criteria: 'Highest Single Order Value',
        result: get_highest_order_user,
        currency: true},
      {criteria: 'Highest Lifetime Value',
        result: get_highest_aggregation_user('SUM'),
        currency: true},
      {criteria: 'Highest Average Order Value',
        result: get_highest_aggregation_user('AVG'),
        currency: true},
      {criteria: 'Most Orders Placed',
        result: get_highest_aggregation_user('COUNT'),
        currency: false}
    ]

    # Panel 3: Order Statistics
    @order_stats_7_days = get_order_stats(7)
    @order_stats_30_days = get_order_stats(30)
    @order_stats_total = get_order_stats

    # Panel 4: Time Series Data
    @orders_by_day = get_orders_by_time('day')
    @orders_by_week = get_orders_by_time('week')
  end

  private

  def get_overall_stats(days_ago = nil)
    if days_ago
      {
        num_users: User.days_ago(days_ago).count,
        num_orders: Order.days_ago(days_ago).completed.count,
        num_products: Product.days_ago(days_ago).count,
        total_revenue: get_revenue(days_ago)
      }
    else
      {
        num_users: User.all.count,
        num_orders: Order.completed.count,
        num_products: Product.all.count,
        total_revenue: get_revenue
      }
    end
  end

  def get_order_stats(days_ago = nil)
    if days_ago
      {
        num_orders: Order.days_ago(days_ago).completed.count,
        total_revenue: get_revenue(days_ago),
        avg_order_value: get_aggregation_order('AVG', days_ago),
        max_order_value: get_aggregation_order('MAX', days_ago)
      }
    else
      {
        num_orders: Order.completed.count,
        total_revenue: get_revenue(days_ago),
        avg_order_value: get_aggregation_order('AVG'),
        max_order_value: get_aggregation_order('MAX')
      }
    end
  end

  def get_orders_by_time(time_frame)
    if time_frame == 'day'
      date_field = "date(o.checkout_date)"
    elsif time_frame == 'week'
      date_field = "date_trunc('week', o.checkout_date)"
    end

    query = "SELECT #{date_field} as date, COUNT(o.id) as quantity, SUM(oc.quantity * p.price) as value FROM orders o JOIN order_contents oc ON oc.order_id = o.id JOIN products p ON p.id = oc.product_id WHERE o.checkout_date IS NOT NULL GROUP BY date ORDER BY date DESC LIMIT 7"
    Order.find_by_sql(query)
  end

  def get_revenue(days_ago = nil)
    select_revenue = "SUM(p.price * oc.quantity) as revenue"
    if days_ago
      relation = Order.select(select_revenue).joins(order_product_join).days_ago(days_ago).completed
    else
      relation = Order.select(select_revenue).joins(order_product_join).completed
    end
    relation[0].revenue
  end

  def get_aggregation_order(aggregator, days_ago = nil)
    query = aggregate_order_query(aggregator)
    Order.find_by_sql(query)[0].amount
  end

  def aggregate_order_query(aggregator, days_ago = nil)
    "SELECT #{aggregator}(revenue) as amount
    FROM (#{order_totals_query(days_ago)}) ot"
  end

  # Returns order_id as id, user_id, revenue
  def order_totals_query(days_ago = nil)
    if days_ago
      where_clause = "< '#{days_ago.days.ago}'"
    else
      where_clause = "IS NOT NULL"
    end

    "SELECT o.id, o.user_id, SUM(p.price * oc.quantity) as revenue
      FROM orders o
        JOIN order_contents oc ON oc.order_id = o.id
        JOIN products p ON p.id = oc.product_id
      WHERE o.checkout_date #{where_clause}
      GROUP BY o.id"
  end

  # Join clause to join users with order_totals table
  def user_order_totals_join(days_ago = nil)
    "JOIN (#{order_totals_query(days_ago)}) ot ON ot.user_id = users.id"
  end

  # Returns first_name, last_name, revenue for each order
  def user_order_totals(days_ago = nil)
    User.select("users.first_name, users.last_name, ot.revenue as amount").joins(user_order_totals_join)
  end

  def get_highest_order_user
    user_order_totals.order("amount DESC").limit(1)[0]
  end

  def get_highest_aggregation_user(aggregator)
    User.select("users.first_name, users.last_name, #{aggregator}(ot.revenue) as amount").joins(user_order_totals_join).group("users.id").order("amount DESC").limit(1)[0]
  end

  def order_product_join
    "JOIN order_contents oc ON oc.order_id = orders.id JOIN products p ON p.id = oc.product_id"
  end

end
