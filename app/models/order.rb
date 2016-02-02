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

  def self.state_demo
     Order.processed.select("name, count(*) AS max_state").joins("JOIN addresses on addresses.id = orders.shipping_id JOIN states ON states.id = addresses.state_id").group(:name).order("max_state DESC").limit(3)
  end

end
