class Order < ActiveRecord::Base
  def self.total_revenue
    Order.select("SUM(quantity * price) AS revenue").
      joins('JOIN order_contents ON orders.id = order_contents.order_id JOIN products ON products.id = order_contents.product_id').
      where("checkout_date IS NOT NULL").
      first.revenue
  end

  def self.revenue_in_the_last_seven_days
    Order.select("SUM(quantity * price) AS revenue").
      joins('JOIN order_contents ON orders.id = order_contents.order_id JOIN products ON products.id = order_contents.product_id').
      where("checkout_date IS NOT NULL AND checkout_date > ?", 7.days.ago).
      first.revenue
  end

  def self.revenue_in_the_last_thirty_days
    Order.select("SUM(quantity * price) AS revenue").
      joins('JOIN order_contents ON orders.id = order_contents.order_id JOIN products ON products.id = order_contents.product_id').
      where("checkout_date IS NOT NULL AND checkout_date > ?", 30.days.ago).
      first.revenue
  end

  def self.total_orders
    where("checkout_date IS NOT NULL").count
  end

  def self.recent_orders(time_period)
    Order.where("checkout_date > ?", time_period).count
  end

  def self.in_the_last_seven_days 
    self.recent_orders(7.days.ago)
  end

  def self.in_the_last_thirty_days
    self.recent_orders(30.days.ago)
  end

end