class Order < ActiveRecord::Base

  def self.total_orders
    count
  end

  def self.day_orders_total(day)
    where("checkout_date > ? ", day.days.ago).count
  end


end
