class Order < ActiveRecord::Base

  def order_count(time)
    Order.select("COUNT(*) AS user_count").where("checkout_date > ?", time.days.ago)
  end

  def orders_by_time(time)
    Order.where("checkout_date > ?", time.days.ago)
  end

end
