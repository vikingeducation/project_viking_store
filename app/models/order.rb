class Order < ActiveRecord::Base
  def self.total_revenue
    Order.select("SUM(quantity * price) AS revenue").
      joins("JOIN order_contents ON orders.id = order_contents.order_id JOIN products ON products.id = order_contents.product_id").
      where("checkout_date IS NOT NULL").
      first.revenue
  end

  def self.revenue_in_the_last_seven_days
    Order.select("SUM(quantity * price) AS revenue").
      joins("JOIN order_contents ON orders.id = order_contents.order_id JOIN products ON products.id = order_contents.product_id").
      where("checkout_date IS NOT NULL AND checkout_date > ?", 7.days.ago).
      first.revenue
  end

  def self.revenue_in_the_last_thirty_days
    Order.select("SUM(quantity * price) AS revenue").
      joins("JOIN order_contents ON orders.id = order_contents.order_id JOIN products ON products.id = order_contents.product_id").
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

  def self.average_order_value_seven
    self.revenue_in_the_last_seven_days / self.in_the_last_seven_days
  end

  def self.average_order_value_thirty
    self.revenue_in_the_last_thirty_days / self.in_the_last_thirty_days
  end

  def self.average_order_value_all
    self.total_revenue / self.total_orders
  end

  def self.largest_order_value_seven
    Order.select("quantity * price AS order_value").
      joins("JOIN order_contents ON orders.id = order_contents.order_id JOIN products ON products.id = order_contents.product_id").
      where("checkout_date IS NOT NULL AND checkout_date > ?", 7.days.ago).
      group("orders.id").
      order("order_value DESC").
      limit(1).
      first.
      order_value
  end

  def self.largest_order_value_thirty
    Order.select("quantity * price AS order_value").
      joins("JOIN order_contents ON orders.id = order_contents.order_id JOIN products ON products.id = order_contents.product_id").
      where("checkout_date IS NOT NULL AND checkout_date > ?", 30.days.ago).
      group("orders.id").
      order("order_value DESC").
      limit(1).
      first.
      order_value
  end

  def self.largest_order_value_all
    Order.select("quantity * price AS order_value").
      joins("JOIN order_contents ON orders.id = order_contents.order_id JOIN products ON products.id = order_contents.product_id").
      where("checkout_date IS NOT NULL").
      group("orders.id").
      order("order_value DESC").
      limit(1).
      first.
      order_value
  end

  def self.quantity_of_orders_last_week(weeks_ago)
    Order.select("COUNT(*) AS weeks_orders, SUM(quantity * price) AS weeks_value").
      joins("JOIN order_contents ON orders.id = order_contents.order_id JOIN products ON products.id = order_contents.product_id").
      where("checkout_date IS NOT NULL AND checkout_date BETWEEN ? AND ?", (weeks_ago+1).weeks.ago, weeks_ago.weeks.ago).
      first
  end

  def self.quantity_of_orders_by_day(days_ago)
    Order.select("COUNT(*) AS days_orders, SUM(quantity * price) AS days_value").
      joins("JOIN order_contents ON orders.id = order_contents.order_id JOIN products ON products.id = order_contents.product_id").
      where("checkout_date IS NOT NULL AND checkout_date BETWEEN ? AND ?", (days_ago+1).days.ago, days_ago.days.ago).
      first
  end
end