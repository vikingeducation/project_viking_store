class OrderContent < ActiveRecord::Base
  
  def self.revenue_last_seven_days
    OrderContent.select("SUM(products.price * order_contents.quantity) AS revenue")
                .joins("JOIN products ON order_contents.product_id=products.id")
                .joins("JOIN orders ON orders.id=order_contents.order_id")
                .where("order_contents.created_at > ? AND orders.checkout_date IS NOT NULL", Time.now - 7.days).to_a.first.revenue                
  end

  def self.revenue_last_thirty_days
    OrderContent.select("SUM(products.price * order_contents.quantity) AS revenue")
                .joins("JOIN products ON order_contents.product_id=products.id")
                .joins("JOIN orders ON orders.id=order_contents.order_id")
                .where("order_contents.created_at > ? AND orders.checkout_date IS NOT NULL", Time.now - 30.days).to_a.first.revenue                
  end

  def self.total_revenue
    OrderContent.select("SUM(products.price * order_contents.quantity) AS revenue")
                .joins("JOIN products ON order_contents.product_id=products.id")
                .joins("JOIN orders ON orders.id=order_contents.order_id")
                .where("orders.checkout_date IS NOT NULL").to_a.first.revenue                
  end

  def self.everything
    OrderContent.select("order_contents.created_at, (products.price * order_contents.quantity) AS revenue")
                .joins("JOIN products ON order_contents.product_id=products.id")
                .joins("JOIN orders ON orders.id=order_contents.order_id")
                .where("orders.checkout_date IS NOT NULL")                
  end  


end
