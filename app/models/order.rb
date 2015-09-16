class Order < ActiveRecord::Base

  def self.number
    return Order.
    all.
    count
  end

  def self.number_in(days)
    self.where("checkout_date > ?",Time.now - days.day).
    count
  end

  def self.max(days)
    select("orders.id, SUM(order_contents.quantity * products.price) AS value").
      joins("JOIN order_contents ON orders.id = order_contents.order_id JOIN products ON products.id = order_contents.product_id").
      where("checkout_date > ?", days.days.ago).
      order("value DESC").
      group("orders.id").
      first.
      value
  end

  def self.total(num_days)
     self.joins("JOIN order_contents ON orders.id = order_id").
     joins("JOIN products ON products.id = product_id").
     select("*").
     where("checkout_date > ?",Time.now - num_days.day).
     sum("price * quantity")
  end
end
