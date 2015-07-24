class Order < ActiveRecord::Base

  def self.revenue
    Order.find_by_sql("SELECT Round(SUM(price),2) as price from order_contents JOIN products ON products.id = product_id")
  end
end
