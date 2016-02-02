class OrderContent < ActiveRecord::Base

  def self.revenue(days=nil)
    if days.nil?
      self.joins("JOIN products ON product_id = products.id").sum("products.price * order_contents.quantity")
    else
      self.joins("JOIN products ON product_id = products.id").joins("JOIN orders ON orders.id = order_contents.order_id").where("orders.checkout_date > CURRENT_DATE - interval '#{days} day' ").sum("products.price * order_contents.quantity")
    end
  end

  def self.biggest_order
    self.select("SUM(products.price * order_contents.quantity) AS value, orders.id, users.first_name, users.last_name").joins("JOIN orders ON order_id = orders.id").joins("JOIN products ON product_id = products.id").joins("JOIN users ON user_id = users.id").group("orders.id, users.first_name, users.last_name").order("value DESC").limit(1)
  end

  def self.biggest_lifetime
    self.select("SUM(products.price * order_contents.quantity) AS value, users.id, users.first_name, users.last_name").joins("JOIN orders ON order_id = orders.id").joins("JOIN products ON product_id = products.id").joins("JOIN users ON user_id = users.id").group("users.id, users.first_name, users.last_name").order("value DESC").limit(1)
  end

  def self.average_order
    self.select("AVG(products.price * order_contents.quantity) AS value, orders.id, users.first_name, users.last_name").joins("JOIN orders ON order_id = orders.id").joins("JOIN products ON product_id = products.id").joins("JOIN users ON user_id = users.id").group("orders.id, users.first_name, users.last_name").order("value DESC").limit(1)
  end

  def self.most_orders
     self.select("COUNT(orders.id) AS value, users.id, users.first_name, users.last_name").joins("JOIN orders ON order_id = orders.id").joins("JOIN products ON product_id = products.id").joins("JOIN users ON user_id = users.id").group("users.id, users.first_name, users.last_name").order("value DESC").limit(1)
  end

end
