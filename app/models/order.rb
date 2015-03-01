class Order < ActiveRecord::Base
  def self.number_of_orders(number_of_days=nil)
    if number_of_days.nil?
      Order.where("checkout_date IS NOT NULL").count
    else
      Order.where("checkout_date > ?", number_of_days.days.ago).count
    end
  end

  def self.total_revenue(number_of_days=nil)
    if number_of_days.nil?
    Order.select("SUM(quantity * price) AS revenue").joins("JOIN order_contents ON orders.id = order_contents.order_id JOIN products ON products.id = order_contents.product_id").where("checkout_date IS NOT NULL").first.revenue
    else
      Order.select("SUM(quantity * price) AS revenue").joins("JOIN order_contents ON orders.id = order_contents.order_id JOIN products ON products.id = order_contents.product_id").where("checkout_date > ?", number_of_days).first.revenue
    end
  end

  def self.average_order_value(time_period)
  end

  def self.largest_order_value(time_period)
  end

  def convert_time_period(time_period)
  end
end