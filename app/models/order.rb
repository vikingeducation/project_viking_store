class Order < ActiveRecord::Base
  def self.total
    Order.where("checkout_date IS NOT NULL").count
  end

  def self.revenue
    Order.joins("AS o JOIN order_contents oc ON o.id = oc.order_id")
    .joins("JOIN products p ON product_id = p.id")
    .sum("oc.quantity * p.price")
  end

  def self.new_orders(t)
    Order.where("created_at > ?", Time.now - t*24*60*60).where("checkout_date IS NOT NULL").count
  end

  def self.revenue_days(t)
    Order.joins("AS o JOIN order_contents oc ON o.id = oc.order_id")
    .joins("JOIN products p ON product_id = p.id")
    .where("checkout_date > ?", Time.now - t*24*60*60)
    .sum("oc.quantity * p.price")
  end

end
