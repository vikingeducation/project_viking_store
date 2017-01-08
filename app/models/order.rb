class Order < ApplicationRecord

  def self.total_revenue
    revenue = Order.select('SUM(price * quantity) AS sum')
                   .join_with_products

  end

  # def self.total_revenue
  #   Order.join_with_products.sum("order_contents.quantity * products.price")
  # end

  def self.orders_with_values
    Order.select("orders.*, SUM(order_contents.quantity * products.price) AS order_value").
          join_with_products.
          group("orders.id")
  end

  def self.join_with_products
    join_order_with_order_contents.join_order_contents_with_products
  end

  def self.join_order_with_order_contents
    joins("JOIN order_contents ON orders.id = order_contents.order_id")
  end

  def self.join_order_contents_with_products
    joins("JOIN products ON order_contents.product_id = products.id")
  end

end