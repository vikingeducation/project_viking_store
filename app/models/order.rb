class Order < ActiveRecord::Base
  def self.new_orders_since(start_date)
    orders = Order.where("created_at > '#{start_date}'").count
  end
end
