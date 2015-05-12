class Order < ActiveRecord::Base
  def self.placed_since(time)
    self.where("checkout_date >= ?", time).count
  end

  def self.total
    count
  end

  def self.revenue_since(time)
    Order.select("SUM(quantity * price) AS revenue")
      .joins("JOIN order_contents ON orders.id = order_contents.order_id JOIN products on products.id = order_contents.product_id")
      .where("checkout_date >= ?", time).last.revenue
  end

  def self.total_revenue
    Order.select("SUM(quantity * price) AS revenue")
      .joins("JOIN order_contents ON orders.id = order_contents.order_id JOIN products on products.id = order_contents.product_id")
      .where("checkout_date IS NOT NULL").last.revenue
  end
end
