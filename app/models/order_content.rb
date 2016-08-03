class OrderContent < ActiveRecord::Base

  def self.total_revenue
    a = OrderContent.select("SUM(products.price*order_contents.quantity) AS revenue").joins("JOIN orders ON orders.id=order_contents.order_id").joins("JOIN products ON order_contents.product_id=products.id")
    a.first.revenue
  end

  def self.revenue_by_time(time)
    a = OrderContent.select("SUM(products.price*order_contents.quantity) AS revenue").joins("JOIN orders ON orders.id=order_contents.order_id").joins("JOIN products ON order_contents.product_id=products.id").where("orders.checkout_date > ?", time.days.ago)#.group("order_contents.id")
    a.to_a.first.revenue
  end

end
