class Order < ActiveRecord::Base
  def self.new_orders_since(start_date)
    Order.where("created_at > '#{start_date}'").count
  end

  def self.total_orders
    Order.all.count
  end

   def self.order_value_avg_since(start_date)
  Order.select("AVG(quantity * price) AS average").joins("JOIN order_contents ON orders.id = order_contents.order_id").joins("JOIN products ON order_contents.product_id = products.id").where("orders.created_at > '#{start_date}'").to_a[0].average.round(2)
  end

  def self.order_value_max_since(start_date)
    Order.select("MAX(quantity * price) AS maximum").joins("JOIN order_contents ON orders.id = order_contents.order_id").joins("JOIN products ON order_contents.product_id = products.id").where("orders.created_at > '#{start_date}'").group("orders.id").to_a[0].maximum.round(2)
  end
  
  def self.order_value_avg
    Order.select("AVG(quantity * price) AS average").joins("JOIN order_contents ON orders.id = order_contents.order_id").joins("JOIN products ON order_contents.product_id = products.id").to_a[0].average.round(2)
  end

  def self.order_value_max
    Order.select("MAX(quantity * price) AS maximum").joins("JOIN order_contents ON orders.id = order_contents.order_id").joins("JOIN products ON order_contents.product_id = products.id").group("orders.id").to_a[0].maximum.round(2)
  end

  def self.order_by_day_count(start_date)
    Order.where("created_at BETWEEN start_date AND start_date-1.day").count
  end

  def self.order_by_week_count(start_date)
    Order.where("created_at BETWEEN start_date AND start_date-7.day").count
  end

 
end


