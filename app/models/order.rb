class Order < ActiveRecord::Base

  def self.submitted_count
    Order.where("checkout_date IS NOT NULL").count
  end

  def self.total_revenue
    Order.select("SUM(products.price) AS t").join_with_products.to_a.first.t
  end

  def self.join_with_products
    join_with_order_contents.join_order_contents_with_products
  end

  def self.join_with_order_contents
    joins("JOIN order_contents ON orders.id = order_contents.id ")
  end

  def self.join_order_contents_with_products
    joins("JOIN products ON order_contents.product_id = products.id")
  end

end
