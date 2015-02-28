class Order < ActiveRecord::Base
  def self.number_of_orders(number_of_days=nil)
    if number_of_days.nil?
      Order.where("checkout_date IS NOT NULL").count
    else
      Order.where("checkout_date > ?", number_of_days.days.ago).count
    end
  end

  def self.total_revenue(time_period)

  end

  def self.average_order_value(time_period)
  end

  def self.largest_order_value(time_period)
  end

  def convert_time_period(time_period)
  end
end
