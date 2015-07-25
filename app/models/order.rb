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

  def self.largest_order_value(timeframe = 100000000000)

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
                  DATE(checkout_date) as d")
       .joins("JOIN order_contents ON order_contents.order_id=orders.id")
       .joins("JOIN products ON order_contents.product_id=products.id")
       .where("checkout_date IS NOT NULL AND checkout_date > ?", 49.days.ago)
       .group("d")
  end

  def self.last_seven_weeks

    Order.select("ROUND(SUM(quantity * products.price), 2) AS total, 
                  ROUND((julianday(current_date) - julianday(checkout_date))/7, 0) AS wk")
       .joins("JOIN order_contents ON order_contents.order_id=orders.id")
       .joins("JOIN products ON order_contents.product_id=products.id")
       .where("checkout_date IS NOT NULL AND checkout_date > ?", 49.days.ago)
       .group("wk")
  end
end





