class OrderContent < ActiveRecord::Base

  def self.total_revenue
    OrderContent.joins("JOIN orders ON orders.id=order_contents.order_id").joins("JOIN products ON order_contents.product_id=products.id").sum("products.price*order_contents.quantity")
  end

  def self.revenue_by_time(time)
    OrderContent.joins("JOIN orders ON orders.id=order_contents.order_id").joins("JOIN products ON order_contents.product_id=products.id").where("orders.checkout_date > ?", time.days.ago).sum("products.price*order_contents.quantity")
  end

  def self.highest_single_order
     a = OrderContent.select("order_id, first_name, last_name, SUM(price*quantity) AS order_price").joins("JOIN orders ON orders.id=order_contents.order_id").joins("JOIN products ON order_contents.product_id=products.id").joins("JOIN users ON users.id=orders.user_id").group("order_id, first_name, last_name").order("order_price DESC").to_a
  end

end

  