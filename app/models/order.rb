class Order < ActiveRecord::Base

  belongs_to :user

  belongs_to :billing, class_name:  "Address"

  belongs_to :shipping, class_name:  "Address"

  has_many :order_contents
  has_many :products, through: :order_contents
  has_many :categories, through: :products

  def value
    self.order_contents.reduce(0){|sum, oc| sum += oc.quantity * oc.product.price}
  end

  def status
    self.checkout_date.nil? ?  "UNPLACED" : "PLACED"
  end


  def self.order_count(timeframe = 100000000000000)

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

  def self.avg_order_value(timeframe = 1000000000000000)
    (self.revenue(timeframe) / self.order_count(timeframe)).round(2)
  end

  def self.largest_order_value(timeframe = 100000000000000000)

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
                  DATE(checkout_date) AS d,
                  COUNT(DISTINCT orders.id) AS num_items")
       .joins("JOIN order_contents ON order_contents.order_id=orders.id")
       .joins("JOIN products ON order_contents.product_id=products.id")
       .where("checkout_date IS NOT NULL AND checkout_date > ?", 7.days.ago)
       .group("d")
  end

  def self.last_seven_weeks

    Order.select("ROUND(SUM(quantity * products.price), 2) AS total,
                  ROUND((julianday(current_date) - julianday(checkout_date))/7, 0) AS wk,
                  COUNT(DISTINCT orders.id) AS num_items")
       .joins("JOIN order_contents ON order_contents.order_id=orders.id")
       .joins("JOIN products ON order_contents.product_id=products.id")
       .where("checkout_date IS NOT NULL AND checkout_date > ?", 49.days.ago)
       .group("wk")
  end
end





