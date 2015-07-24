
def self.revenue(num_days)
  self.joins("JOIN order_contents ON orders.id = order_id").joins("JOIN products ON products.id = product_id").select("SUM(price * quantity) AS revenue").where("checkout_date > ?",Time.now - num_days.day).first
end
