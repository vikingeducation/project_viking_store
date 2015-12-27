class Order < ActiveRecord::Base
  scope :days_ago, -> (days_past = 7) { where("checkout_date > ?", days_past.days.ago) }

  scope :completed, -> { where("checkout_date IS NOT NULL")}

  def self.get_orders_by_time(time_frame)
    if time_frame == 'day'
      date_field = "date(o.checkout_date)"
    elsif time_frame == 'week'
      date_field = "date_trunc('week', o.checkout_date)"
    end

    query = "SELECT #{date_field} as date, COUNT(o.id) as quantity, SUM(oc.quantity * p.price) as value FROM orders o JOIN order_contents oc ON oc.order_id = o.id JOIN products p ON p.id = oc.product_id WHERE o.checkout_date IS NOT NULL GROUP BY date ORDER BY date DESC LIMIT 7"
    Order.find_by_sql(query)
  end

  def self.get_order_stats(days_ago = nil)
    if days_ago
      {
        num_orders: Order.days_ago(days_ago).completed.count,
        total_revenue: Order.get_revenue(days_ago),
        avg_order_value: Order.get_aggregation_order('AVG', days_ago),
        max_order_value: Order.get_aggregation_order('MAX', days_ago)
      }
    else
      {
        num_orders: Order.completed.count,
        total_revenue: Order.get_revenue(days_ago),
        avg_order_value: Order.get_aggregation_order('AVG'),
        max_order_value: Order.get_aggregation_order('MAX')
      }
    end
  end

  private

  def self.get_revenue(days_ago = nil)
    select_revenue = "SUM(p.price * oc.quantity) as revenue"
    if days_ago
      relation = Order.select(select_revenue).joins(order_product_join).days_ago(days_ago).completed
    else
      relation = Order.select(select_revenue).joins(order_product_join).completed
    end
    relation[0].revenue
  end

  def self.get_aggregation_order(aggregator, days_ago = nil)
    query = aggregate_order_query(aggregator)
    Order.find_by_sql(query)[0].amount
  end

  def self.aggregate_order_query(aggregator, days_ago = nil)
    "SELECT #{aggregator}(revenue) as amount
    FROM (#{order_totals_query(days_ago)}) ot"
  end

  # Returns order_id as id, user_id, revenue
  def self.order_totals_query(days_ago = nil)
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

  def self.order_product_join
    "JOIN order_contents oc ON oc.order_id = orders.id JOIN products p ON p.id = oc.product_id"
  end

end
