class Order < ActiveRecord::Base

  def self.order_count(timeframe = nil)

    if timeframe.nil?
      return Order.where("checkout_date IS NOT NULL").count
    else
      return Order.where("checkout_date IS NOT NULL AND created_at > ?", timeframe.days.ago).count
    end
  end

  def self.revenue(timeframe = 100000000000)

    Order.select("ROUND(SUM(quantity * products.price), 2) AS total")
         .joins("JOIN order_contents ON order_contents.order_id=orders.id")
         .joins("JOIN products ON order_contents.product_id=products.id")
         .where("checkout_date IS NOT NULL AND checkout_date > ?", timeframe.days.ago)
         .first.total
  end

  def self.avg_order_value(timeframe = nil)
    self.revenue(timeframe) / self.order_count(timeframe)
  end

  def self.largest_order_value(timeframe = nil)

    Order.select("ROUND(SUM(quantity * products.price), 2) AS total")
         .joins("JOIN order_contents ON order_contents.order_id=orders.id")
         .joins("JOIN products ON order_contents.product_id=products.id")
         .where("checkout_date IS NOT NULL AND checkout_date > ?", timeframe.days.ago)
         .group("orders.id")
         .order("total DESC")
         .first.total
  end


  def self.last_seven_days
    # Last 7 days or weeks, scope is 'days' or weeks

    # if scope == 'days'
    # t = 7
    Order.select("ROUND(SUM(quantity * products.price), 2) AS total, 
                  DATE(checkout_date) as d, 
                  current_date as cd,
                  EXTRACT(DAY FROM (current_date - DATE(checkout_date))) AS wk")
       .joins("JOIN order_contents ON order_contents.order_id=orders.id")
       .joins("JOIN products ON order_contents.product_id=products.id")
       .where("checkout_date IS NOT NULL AND checkout_date > ?", 49.days.ago)
       .group("d, wk, cd")
  end

  def self.last_seven_weeks

    # elsif scope == 'weeks'
      # t = 49
    week_total = []
    7.times do |i|
      start_date = ((i+1)*7).days.ago
      end_date = ((i+1)*7+6).days.ago
      week_total << Order.select("ROUND(SUM(quantity * products.price), 2) AS total, 
                   (current_date - DATE(checkout_date)) AS wk")
         .joins("JOIN order_contents ON order_contents.order_id=orders.id")
         .joins("JOIN products ON order_contents.product_id=products.id")
         .where("checkout_date IS NOT NULL AND checkout_date BETWEEN DATE(#{start_date}) AND DATE(#{end_date})")
         .first.total
    end 
    week_total
  end
end





