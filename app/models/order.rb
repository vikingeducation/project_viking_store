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

  def orders_by_day #shows last 7 days D, Q, Value
    now = Time.now
    result = {}
    7.times do |i|
      day = now + i
      result[day] = time_order_summary(day)
    end
  end

  def time_order_summary(date, day_span = 0)
    order_join_table = Order.joins("JOIN order_contents ON orders.id = order_id").joins("JOIN products ON products.id = product_id")

    value = order_join_table.select("*") \
          .where("checkout_date BETWEEN ? AND ?", date.midnight, date.end_of_day).sum("price * quantity")

    quantity = order_join_table.where("checkout_date BETWEEN ? AND ?", day_span.days.ago.midnight, date.end_of_day).count("DISTINCT order_id")

    [quantity, value]
  end

  def orders_by_week
    now = Time.now
    result = {}
    7.times do |i|
      start_weekday = now + (i+1) *7
      result[start_weekday] = time_order_summary(start_weekday, 7)
    end
  end





end
