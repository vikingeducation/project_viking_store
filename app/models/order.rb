class Order < ActiveRecord::Base

  def self.last_seven_days
    Order.all.where("checkout_date BETWEEN (NOW() - INTERVAL '7 days') AND NOW()").count
  end


  def self.revenue_last_seven_days
    Order.joins("AS o JOIN order_contents oc ON o.id = oc.order_id").joins("JOIN products p ON p.id = oc.product_id").where("o.checkout_date BETWEEN (NOW() - INTERVAL '7 days') AND NOW()").sum("oc.quantity * p.price")
  end

end
