class Order < ActiveRecord::Base
  has_many :order_contents

  def self.new_orders(num_days)
    Order.processed.where("orders.created_at <= ? ", num_days.days.ago)
  end

  def self.total_revenue
    Order.processed.joins("JOIN order_contents ON order_id = orders.id JOIN products ON product_id = products.id ").sum("quantity * price").to_f
  end

  def self.processed
    Order.where("checkout_date IS NOT NULL")
  end

  def self.top_states
    Order.processed.select("states.name").
      joins("JOIN addresses ON addresses.id = orders.billing_id").
      joins("JOIN states ON states.id = addresses.state_id").
      group("states.name").
      order("COUNT(states.name) DESC").
      limit(3)
      .count
  end

  def self.average_value_since(num_days)
    Order.find_by_sql("SELECT AVG(totals.order_total) FROM (#{order_totals.to_sql}) AS totals WHERE order_totals.created_at <= ?", num_days.days.ago).first.avg
  end

  def self.average_value
    Order.find_by_sql("SELECT AVG(totals.order_total) FROM (#{order_totals.to_sql}) AS totals").first.avg
  end

  def self.largest_value
    Order.find_by_sql("SELECT MAX(totals.order_total) FROM (#{order_totals.to_sql}) AS totals").first.max
  end

  def self.order_totals
    Order.processed.select("orders.*, SUM(price * quantity) AS order_total").joins("JOIN order_contents ON order_id = orders.id JOIN products ON product_id = products.id").group("orders.id")
  end
end
