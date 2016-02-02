class Order < ActiveRecord::Base

  def self.count_recent(n)
    Order.all.where("checkout_date BETWEEN (NOW() - INTERVAL '#{n} days') AND NOW()").count
  end


  def self.revenue_recent(n)
    Order.joins("AS o JOIN order_contents oc ON o.id = oc.order_id")
         .joins("JOIN products p ON p.id = oc.product_id")
         .where("o.checkout_date BETWEEN (NOW() - INTERVAL '#{n} days') AND NOW()")
         .sum("oc.quantity * p.price")
  end


  def self.orders_total
    Order.all.count
  end

  def self.revenue_total
    Order.joins("AS o JOIN order_contents oc ON o.id = oc.order_id")
         .joins("JOIN products p ON p.id = oc.product_id")
         .sum("oc.quantity * p.price")
  end


  def self.average_order(n)
    Order.joins("AS o JOIN users u on u.id = o.user_id")
         .joins("JOIN order_contents oc ON oc.order_id = o.id")
         .joins("JOIN products p ON p.id = oc.product_id")
         .where("o.checkout_date BETWEEN (NOW() - INTERVAL '#{n} days') AND NOW()")
         .average("(oc.quantity * p.price)")
  end


  def self.largest_order(n)
    Order.select("SUM(oc.quantity * p.price) AS largest_order")
         .joins("AS o JOIN order_contents oc ON oc.order_id = o.id")
         .joins("JOIN products p ON p.id = oc.product_id")
         .where("o.checkout_date BETWEEN (NOW() - INTERVAL '#{n} days') AND NOW()")
         .group("o.id")
         .order("largest_order DESC")
         .limit(1)
  end

  def self.average_total
    Order.joins("AS o JOIN users u on u.id = o.user_id")
         .joins("JOIN order_contents oc ON oc.order_id = o.id")
         .joins("JOIN products p ON p.id = oc.product_id")
         .where("o.checkout_date IS NOT NULL")
         .average("(oc.quantity * p.price)")
  end

  def self.largest_total
    Order.joins("AS o JOIN order_contents oc ON oc.order_id = o.id")
         .joins("JOIN products p ON p.id = oc.product_id")
         .where("o.checkout_date IS NOT NULL")
         .maximum("oc.quantity * p.price")
  end


end
