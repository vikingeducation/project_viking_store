class Order < ActiveRecord::Base

  def self.revenue
    Order.find_by_sql("SELECT Round(SUM(price),2) as price from order_contents JOIN products ON products.id = product_id")
  end

  def self.count_last(num_days_ago)
    Order.where("checkout_date > ?", num_days_ago.days.ago).count
  end

end
