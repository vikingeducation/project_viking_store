class Order < ApplicationRecord

  def order_created_seven_days
    Order.where('created_at > ?',(Time.now - 7.days)).count 
  end

  def order_created_thirty_days
    Order.where('created_at > ?',(Time.now - 30.days)).count 
  end

  def order_count
    Order.count 
  end

  def revenue_in_seven_days
   Order.find_by_sql("
     SELECT SUM(price * quantity) AS sum FROM orders
     JOIN order_contents ON orders.id = order_contents.order_id
     JOIN products on products.id = order_contents.product_id
     WHERE checkout_date IS NOT NULL
     AND orders.created_at > '#{Time.now - 7.days}'
   ")
  end

   def revenue_in_thirty_days
   Order.find_by_sql("
     SELECT SUM(price * quantity) AS sum FROM orders
     JOIN order_contents ON orders.id = order_contents.order_id
     JOIN products on products.id = order_contents.product_id
     WHERE checkout_date IS NOT NULL
     AND orders.created_at > '#{Time.now - 30.days}'
   ")
  end

   def total_revenue
   Order.find_by_sql("
     SELECT SUM(price * quantity) AS sum FROM orders
     JOIN order_contents ON orders.id = order_contents.order_id
     JOIN products on products.id = order_contents.product_id
     WHERE checkout_date IS NOT NULL
   ")
  end

end
