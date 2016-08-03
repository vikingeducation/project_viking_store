class Order < ActiveRecord::Base

  def self.order_count(time = nil)
    if time
      Order.where("checkout_date > ?", time.days.ago).count
    else
      Order.all.count
    end
  end

  def self.orders_by_time(time)
    Order.where("checkout_date > ?", time.days.ago)
  end

end
