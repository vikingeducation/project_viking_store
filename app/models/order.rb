class Order < ActiveRecord::Base
  def self.new_orders_since(start_date)
    Order.where("created_at > '#{start_date}'").count
  end

  def self.total_orders
    Order.all.count
  end

end
