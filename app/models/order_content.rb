class OrderContent < ActiveRecord::Base


  def self.super_table
    joins("JOIN orders ON orders.id=order_contents.order_id").joins("JOIN products ON order_contents.product_id=products.id").joins("JOIN users ON users.id=orders.user_id")
  end

  def self.total_revenue
    OrderContent.joins("JOIN orders ON orders.id=order_contents.order_id").joins("JOIN products ON order_contents.product_id=products.id").sum("products.price*order_contents.quantity")
  end

  def self.revenue_by_time(time)
    OrderContent.joins("JOIN orders ON orders.id=order_contents.order_id").joins("JOIN products ON order_contents.product_id=products.id").where("orders.checkout_date > ?", time.days.ago).sum("products.price*order_contents.quantity")
  end

  def self.highest_single_order
     OrderContent.select("order_id, first_name, last_name, SUM(price*quantity) AS order_price").super_table.group("order_id, first_name, last_name").order("order_price DESC").to_a
  end

  def self.highest_lifetime_value
    OrderContent.select("first_name,last_name,SUM(price*quantity) AS lifetime_value").super_table.group("first_name,last_name").order("lifetime_value DESC").to_a
  end

  def self.highest_average_order_value
    OrderContent.select("first_name,last_name,AVG(price*quantity) AS avg_order_value").super_table.group("first_name,last_name").order("avg_order_value DESC").to_a
  end

  def self.most_orders_placed
    OrderContent.select("first_name,last_name,COUNT(*) AS orders_placed").super_table.group("first_name,last_name").order("orders_placed DESC").to_a
  end

  def self.order_totals(time = nil)
    if time
      select("order_id, SUM(price*quantity) AS order_price").joins("JOIN orders ON orders.id=order_contents.order_id").joins("JOIN products ON order_contents.product_id=products.id").where("orders.checkout_date > ?", time.days.ago).group("order_id")
    else
      select("order_id, SUM(price*quantity) AS order_price").joins("JOIN orders ON orders.id=order_contents.order_id").joins("JOIN products ON order_contents.product_id=products.id").group("order_id")
    end
  end

  def self.avg_order_value(time = nil)
    from(order_totals(time)).average("order_price").round(2)
  end

  def self.largest_order_value(time = nil)
    from(order_totals(time)).maximum("order_price")
  end
end

  