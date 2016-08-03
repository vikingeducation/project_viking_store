class OrderContent < ActiveRecord::Base

  def total_revenue
    a = OrderContent.select("SUM(products.price*order_contents.quantity) AS revenue").joins("JOIN orders ON orders.id=order_contents.order_id").joins("JOIN products ON order_contents.product_id=products.id")
    a.first.revenue
  end

end
