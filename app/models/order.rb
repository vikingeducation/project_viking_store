class Order < ActiveRecord::Base

  def self.order_created_days_ago(num_days)
    self.where("created_at > ?",Time.now - num_days.day).count
  end

  def self.total(num_days) #=revenue_generated
    # result = self.joins("JOIN order_contents ON orders.id = order_id").joins("JOIN products ON products.id = product_id").select("SUM(price * quantity) AS revenue , orders.id").where("checkout_date > ?",Time.now - num_days.day)
    # result.first.revenue
    result = Order.joins("JOIN order_contents ON orders.id = order_id").joins("JOIN products ON products.id = product_id").select("*").where("checkout_date > ?",Time.now - num_days.day).sum("price * quantity")
  end

  def self.revenue_generated(days)

  end

  def self.avg_order_value(num_days)
    revenue = self.total(num_days)
    num_orders = self.order_created_days_ago(num_days)
    revenue/num_orders

  end

  def self.max_order_value(days)

  end





end
