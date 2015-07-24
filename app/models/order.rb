class Order < ActiveRecord::Base

  def self.order_created_days_ago(num_days)
    self.where("created_at > ?",Time.now - num_days.day).count
  end

  def self.total(num_days)
    result = self.joins("JOIN order_contents ON orders.id = order_id").joins("JOIN products ON products.id = product_id").select("SUM(price * quantity) AS revenue").where("checkout_date > ?",Time.now - num_days.day)
    result.first.revenue
  end






end
