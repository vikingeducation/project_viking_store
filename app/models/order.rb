class Order < ActiveRecord::Base
  def self.total_orders_submitted
    Order.where( "checkout_date IS NOT NULL" ).count()
  end

  def self.total_revenue_generated
    join_with_products.where(
      "orders.checkout_date IS NOT NULL"
      ).sum(
      "products.price * order_contents.quantity"
      )
  end

  def self.num_orders_submitted_in_last_n_days( n )
    Order.where( str_orders_submitted_in_last_n_days( n )).count()
  end

  def self.str_orders_submitted_in_last_n_days( n )
    "checkout_date IS NOT NULL AND checkout_date > ( CURRENT_DATE - #{n} ) "
  end

  def self.revenue_n_days( n )
    join_with_products.where(
      str_orders_submitted_in_last_n_days( n )
      ).sum(
      "products.price * order_contents.quantity"
      )
  end

  def self.join_with_products
    Order.joins(
      "JOIN order_contents ON orders.id = order_contents.order_id JOIN products ON order_contents.product_id = products.id"
      )
  end

end
