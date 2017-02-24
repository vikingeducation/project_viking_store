class Order < ApplicationRecord
  has_many :order_contents

  def self.get_stats(start = Time.now, days_ago = nil)
    { num_orders: number_of_orders(start, days_ago).to_s,
      total_revenue: sprintf('$%.2f', total_revenue(start, days_ago)),
      avg_order_value: average_order_value(start, days_ago),
      largest_order_value: largest_order_value(start, days_ago)
    }
  end

  private

  def self.number_of_orders(start = Time.now, days_ago = nil)
    result = Order.where("orders.checkout_date IS NOT NULL")
                  .time_series(start, days_ago)
                  .count
  end

  def self.total_revenue(start = Time.now, days_ago = nil)
    result = Order.select("SUM(order_contents.quantity * products.price) AS revenue")
                  .join_orders_order_contents_and_products
                  .where("orders.checkout_date IS NOT NULL")
                  .time_series(start, days_ago)
    result[0].revenue           
  end

  def self.average_order_value(start = Time.now, days_ago = nil)
    result = sprintf('$%.2f', total_revenue(start, days_ago) / number_of_orders(start, days_ago))
  end

  def self.largest_order_value(start = Time.now, days_ago = nil)
    result = Order.select("SUM(order_contents.quantity * products.price) AS largest_order_value")
                  .join_orders_order_contents_and_products
                  .where("orders.checkout_date IS NOT NULL")
                  .time_series(start, days_ago)
                  .group("orders.id")
                  .order("SUM(order_contents.quantity * products.price) DESC")
                  .limit(1)
    sprintf('$%.2f', result[0].largest_order_value)
  end

  def self.time_series(start, days_ago)
    if days_ago.nil?
      where("orders.checkout_date <= '#{start}'")
    else
      where("orders.checkout_date <= '#{start}' AND orders.checkout_date >= '#{start - days_ago.days}'")
    end
  end

  def self.join_orders_order_contents_and_products
    joins("JOIN order_contents ON orders.id = order_contents.order_id")
    .joins("JOIN products ON order_contents.product_id = products.id")
  end
end
