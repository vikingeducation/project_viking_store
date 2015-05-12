class Order < ActiveRecord::Base
  def self.placed_since(time)
    where("checkout_date >= ?", time).count
  end

  def self.total
    count
  end

  def self.avg_value_since(time)
    select("AVG(quantity * price) AS avg_value")
    .joins("JOIN order_contents ON orders.id = order_contents.order_id JOIN products on products.id = order_contents.product_id")
    .where("checkout_date >= ?", time).last.avg_value
  end

  def self.avg_value_total
    select("AVG(quantity * price) AS avg_value")
      .joins("JOIN order_contents ON orders.id = order_contents.order_id JOIN products on products.id = order_contents.product_id")
      .where("checkout_date IS NOT NULL").last.avg_value
  end

  def self.largest_value_since(time)
    select("MAX(quantity * price) AS largest_val")
    .joins("JOIN order_contents ON orders.id = order_contents.order_id JOIN products on products.id = order_contents.product_id")
    .where("checkout_date >= ?", time).last.largest_val
  end

  def self.largest_value_total
    select("MAX(quantity * price) AS largest_val")
      .joins("JOIN order_contents ON orders.id = order_contents.order_id JOIN products on products.id = order_contents.product_id")
      .where("checkout_date IS NOT NULL").last.largest_val
  end

  def self.revenue_since(time)
    select("SUM(quantity * price) AS revenue")
      .joins("JOIN order_contents ON orders.id = order_contents.order_id JOIN products on products.id = order_contents.product_id")
      .where("checkout_date >= ?", time).last.revenue
  end

  def self.total_revenue
    select("SUM(quantity * price) AS revenue")
      .joins("JOIN order_contents ON orders.id = order_contents.order_id JOIN products on products.id = order_contents.product_id")
      .where("checkout_date IS NOT NULL").last.revenue
  end
end
