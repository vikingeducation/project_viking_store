class Order < ActiveRecord::Base

  def self.order_created_days_ago(num_days)
    self.where("checkout_date > ?", Time.now.end_of_day - num_days.day).count("DISTINCT orders.id")
  end

  def self.orders_by_days

    h={"Today" => self.time_order_summary(Time.now),
     "Yesterday" => self.time_order_summary(Time.now-1.day)}
    2.upto(5) do |num_days|
      h[(Time.now - num_days.day).strftime("%m/%d")]=self.time_order_summary(Time.now - num_days.day)
    end
    h

  end


  def self.time_order_summary(date, day_span = 0)
    order_join_table = Order.joins("JOIN order_contents ON orders.id = order_id").joins("JOIN products ON products.id = product_id")

    value = order_join_table.select("*") \
          .where("orders.checkout_date BETWEEN ? AND ?", (date-day_span).midnight, date.end_of_day).sum("price * quantity").round


    quantity = order_join_table.where("orders.checkout_date BETWEEN ? AND ?", (date-day_span).midnight, date.end_of_day).count("DISTINCT order_id").round

    [quantity, value]
  end

  def self.orders_by_week
    result = {}
    7.times do |i|
      start_weekday = Time.now - (i+1).day*7
      result[start_weekday.strftime("%m/%d")] = time_order_summary(start_weekday, 7)
    end
    result
  end


  def self.largest_order_value(num_days)

    Order.joins("JOIN order_contents ON orders.id = order_id").joins("JOIN products ON products.id = product_id").select("SUM(price * quantity) AS ordervalue, order_id").where("checkout_date > ?",Time.now - num_days.day ).group(:order_id).order("ordervalue DESC").limit(1).first.ordervalue.round
  end

  def self.total(num_days) #=revenue_generated

     Order.joins("JOIN order_contents ON orders.id = order_id").joins("JOIN products ON products.id = product_id").select("*").where("checkout_date > ?",Time.now - num_days.day).sum("price * quantity")
  end



  def self.avg_order_value(num_days)

    revenue = self.total(num_days)
    num_orders = self.order_created_days_ago(num_days)
    (revenue/num_orders).round

  end

end
