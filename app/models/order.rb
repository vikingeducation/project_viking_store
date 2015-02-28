class Order < ActiveRecord::Base
  def self.total_revenue
    Order.select("SUM(quantity * price) AS revenue").
      joins('JOIN order_contents ON orders.id = order_contents.order_id JOIN products ON products.id = order_contents.product_id').
      where("checked_out = ?", true).
      first.revenue
  end
end