class OrderContent < ActiveRecord::Base

  belongs_to :product
  belongs_to :order

  def self.total_revenue_since_days_ago(number)
    date = Time.now - number.days
    # OrderContent.find_by_sql("SELECT COUNT(order_contents.quantity * products.price) as total FROM order_contents JOIN products ON order_contents.product_id=products.id WHERE order_contents.created_at >= '#{date}'")
  end
end