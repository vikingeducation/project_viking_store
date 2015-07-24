class Order < ActiveRecord::Base

  def self.in_last(days = 10000)
    self.where('checkout_date > ?', DateTime.now - days)
  end

  def self.revenue_in_last(days = 10000)
    self.select('SUM(products.price * order_contents.quantity)').joins('JOIN order_contents ON orders.id = order_contents.order_id JOIN products ON order_contents.product_id = products.id').where('orders.checkout_date > ?', DateTime.now - days)
  end
end
