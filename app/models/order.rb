class Order < ApplicationRecord
  has_many :order_contents

  def self.get_stats(start = Time.now, days_ago = nil)
    { num_orders: number_of_orders(start, days_ago).to_s,
      total_revenue: sprintf('$%.2f', total_revenue(start, days_ago)),
      avg_order_value: average_order_value(start, days_ago),
      largest_order_value: largest_order_value(start, days_ago)
    }
  end

  def self.get_time_series_data(start = Time.now, interval = 'day', data_points = 7)
    data = []
    if interval == 'day'
      data_points.times do |index|
        t1 = start - index.days
        data << [t1.strftime("%-m/%d"), self.number_of_orders(t1, 1), sprintf('$%.2f', self.total_revenue(t1, 1))]
      end
    elsif interval == 'week'
      data_points.times do |index|
        t1 = start - index.week
        data << [(t1 - 7.days).strftime("%-m/%d"), self.number_of_orders(t1, 7), sprintf('$%.2f', self.total_revenue(t1, 7))]
      end
    end
    data
  end

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
    return 0 if result.empty?
    result[0].revenue           
  end

  private

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
