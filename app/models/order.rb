class Order < ActiveRecord::Base

  def self.submitted_count(period = nil)
    submitted = Order.submitted
    if period 
      submitted = submitted.checkout_date_rage(period)
    end
    submitted.count
  end


  def self.total_revenue(period = nil)
    total = Order.select("SUM(products.price) AS t").join_with_products.submitted
    if period
      total = total.checkout_date_rage(period)
    end
    total.to_a.first.t
  end


  def self.most_expensive_order
    o = Order.joins("JOIN (#{Order.order_totals.to_sql}) order_totals ON order_totals.id = orders.id").
              select("orders.user_id, order_value").order("order_value DESC").limit(1)
    User.select("users.first_name, users.last_name, order_value AS value").
         joins("JOIN (#{o.to_sql}) o ON o.user_id = users.id").first
  end


  def self.highest_lifetime_value
    o = Order.select("Orders.user_id, SUM(products.price) AS all_orders_value").
             join_with_products.submitted.group("orders.user_id").
             order("all_orders_value DESC").limit(1)
    User.select("users.first_name, users.last_name, all_orders_value AS value").
         joins("JOIN (#{o.to_sql}) o ON o.user_id = users.id").first
  end


  def self.highest_average_order
    o = Order.joins("JOIN (#{Order.order_totals.to_sql}) order_totals ON order_totals.id = orders.id").
              select("orders.user_id, AVG(order_totals.order_value) as average_order_value").
              group("user_id").order("average_order_value DESC").limit(1)
    User.select("users.first_name, users.last_name, average_order_value AS value").
         joins("JOIN (#{o.to_sql}) o ON o.user_id = users.id").first
  end


  def self.most_orders_placed
    o = Order.select("orders.user_id, COUNT(*) as ocount").
              group("orders.user_id").order("ocount DESC").limit(1)
    User.select("users.first_name, users.last_name, ocount AS value").
         joins("JOIN (#{o.to_sql}) o ON o.user_id = users.id").first
  end


  def self.average_order_value(period = nil)
    avg = Order.select("AVG(totals.order_value) as order_avg").
                joins("JOIN (#{Order.order_totals.to_sql}) totals ON totals.id = orders.id")
    if period
      avg = avg.checkout_date_rage(period)
    end
    avg.to_a.first.order_avg
  end


  def self.largest_order_value(period = nil)
    max = Order.select("MAX(totals.order_value) as order_max").
                joins("JOIN (#{Order.order_totals.to_sql}) totals ON totals.id = orders.id")
    if period
      max = max.checkout_date_rage(period)
    end
    max.to_a.first.order_max
    
  end


  def self.checkout_date_rage(period)
    where( "checkout_date BETWEEN :start AND :finish",
         { start: DateTime.now - period, finish: DateTime.now } )
  end


  def self.order_totals
    Order.select("orders.id, SUM(products.price) AS order_value").
          join_with_products.submitted.group("orders.id")
  end


  def self.submitted
    where("checkout_date IS NOT NULL")
  end


  def self.join_with_products
    join_with_order_contents.join_order_contents_with_products
  end


  def self.join_with_order_contents
    joins("JOIN order_contents ON orders.id = order_contents.order_id ")
  end


  def self.join_order_contents_with_products
    joins("JOIN products ON order_contents.product_id = products.id")
  end

end
