class Order < ActiveRecord::Base
  has_many :order_contents

  def self.new_orders(num_days)
    Order.processed.where("orders.created_at <= ? ", num_days.days.ago)
  end

  def self.total_revenue
    Order.processed.joins("JOIN order_contents ON order_id = orders.id JOIN products ON product_id = products.id ").sum("quantity * price").to_f
  end

  def self.processed
    Order.where("checkout_date IS NOT NULL")
  end
end
