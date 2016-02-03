class Order < ActiveRecord::Base

  def self.total(days=nil)
    if days.nil?
      self.all.count
    else
      self.all.where("checkout_date > CURRENT_DATE - interval '#{days} day' ").count
    end
  end

  def self.order_by_day(days)
    subquery = self.select("COUNT(orders.id) AS ord, SUM(products.price * order_contents.quantity) AS val, orders.checkout_date").joins("JOIN order_contents ON order_id = orders.id").joins("JOIN products ON order_contents.product_id = products.id").where("checkout_date IS NOT NULL AND checkout_date BETWEEN CURRENT_DATE - #{days} AND CURRENT_DATE - #{days-1}").group("orders.checkout_date")
    from(subquery).select("SUM(ord) as total, SUM(val) as value")
  end

  def self.order_by_week(weeks)
    subquery = self.select("COUNT(orders.id) AS ord, SUM(products.price * order_contents.quantity) AS val, orders.checkout_date").joins("JOIN order_contents ON order_id = orders.id").joins("JOIN products ON order_contents.product_id = products.id").where("checkout_date IS NOT NULL AND checkout_date BETWEEN CURRENT_DATE - interval '#{weeks} weeks' AND CURRENT_DATE - interval '#{weeks-1} weeks' ").group("orders.checkout_date")
    from(subquery).select("SUM(ord) as total, SUM(val) as value")
  end

end
