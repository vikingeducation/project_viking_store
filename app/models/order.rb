class Order < ActiveRecord::Base
  def self.number_of_orders(number_of_days=nil)
    if number_of_days.nil?
      Order.where("checkout_date IS NOT NULL").count
    else
      Order.where("checkout_date > ?", number_of_days.days.ago).count
    end
  end

  def self.total_revenue(number_of_days=nil)
    if number_of_days.nil?
      Order.select("SUM(quantity * price) AS revenue").joins("JOIN order_contents ON orders.id = order_contents.order_id JOIN products ON products.id = order_contents.product_id").where("checkout_date IS NOT NULL").first.revenue
    else
      Order.select("SUM(quantity * price) AS revenue").joins("JOIN order_contents ON orders.id = order_contents.order_id JOIN products ON products.id = order_contents.product_id").where("checkout_date > ?", number_of_days.days.ago).first.revenue
    end
  end

  def self.average_value(number_of_days=nil)
    if number_of_days.nil?
      Order.select("AVG(quantity * price) AS average_value").joins("JOIN order_contents ON orders.id = order_contents.order_id JOIN products ON order_contents.product_id = products.id").where("checkout_date IS NOT NULL").first.average_value
    else
      Order.select("AVG(quantity * price) AS average_value").joins("JOIN order_contents ON orders.id = order_contents.order_id JOIN products ON order_contents.product_id = products.id").where("checkout_date > ?", number_of_days.days.ago).first.average_value
    end
  end

  def self.largest_order_value(number_of_days=nil)
    if number_of_days.nil?
      Order.select("(quantity * price) AS largest_value").joins("JOIN order_contents ON orders.id = order_contents.order_id JOIN products ON order_contents.product_id = products.id").where("checkout_date IS NOT NULL").order("largest_value DESC").first.largest_value
    else
      Order.select("(quantity * price) AS largest_value").joins("JOIN order_contents ON orders.id = order_contents.order_id JOIN products ON order_contents.product_id = products.id").where("checkout_date > ?", number_of_days.days.ago).order("largest_value DESC").first.largest_value
    end
  end

end