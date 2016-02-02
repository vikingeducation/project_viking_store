class Order < ActiveRecord::Base
  def self.total_orders_submitted
    Order.where( "checkout_date IS NOT NULL" ).count()
  end

  def self.total_revenue_generated
    Order.joins(
      "JOIN order_contents ON orders.id = order_contents.order_id JOIN products ON order_contents.product_id = products.id"
      ).where(
      "orders.checkout_date IS NOT NULL"
      ).sum(
      "products.price * order_contents.quantity"
      )
  end

  def self.orders_submitted_30
    Order.where("created_at > ( CURRENT_DATE - 30 ) AND checkout_date IS NOT NULL").count
  end

  def self.revenue_30
    Order.joins(
      "JOIN order_contents ON orders.id = order_contents.order_id JOIN products ON order_contents.product_id = products.id"
      ).where(
      "orders.created_at > ( CURRENT_DATE - 30 ) AND orders.checkout_date IS NOT NULL"
      ).sum(
      "products.price * order_contents.quantity"
      )
  end

end
