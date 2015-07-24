class Order < ActiveRecord::Base

  def self.order_count(timeframe = nil)

    if timeframe.nil?
      return Order.where("checkout_date IS NOT NULL").count
    else
      return Order.where("checkout_date IS NOT NULL AND created_at > ?", timeframe.days.ago).count
    end
  end

  def self.revenue(timeframe = nil)
    if timeframe
      where_filter = "checkout_date > #{timeframe.days.ago}"
    else
      where_filter = "checkout_date IS NOT NULL"
    end

    Order.select("ROUND(SUM(quantity * products.price), 2) AS total")
         .joins("JOIN order_contents ON order_contents.order_id=orders.id")
         .joins("JOIN products ON order_contents.product_id=products.id")
         .where(where_filter)
         .first.total
  end

  def self.avg_order_value(timeframe = nil)
    self.revenue(timeframe) / self.order_count(timeframe)
  end

  def self.largest_order_value(timeframe = nil)
    if timeframe
      where_filter = "checkout_date > #{timeframe.days.ago}"
    else
      where_filter = "checkout_date IS NOT NULL"
    end
    Order.select("ROUND(SUM(quantity * products.price), 2) AS total")
         .joins("JOIN order_contents ON order_contents.order_id=orders.id")
         .joins("JOIN products ON order_contents.product_id=products.id")
         .where(where_filter)
         .group("orders.id")
         .order("total DESC")
         .first.total
  end
end





