class OrderContent < ActiveRecord::Base

  def self.total_revenue
    self.select('SUM(products.price * order_contents.quantity) AS revenue').joins('JOIN products ON (order_contents.product_id = products.id)')
  end

end
