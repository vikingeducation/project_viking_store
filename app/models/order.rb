class Order < ApplicationRecord


  def self.new_orders_7
    Order.where("checkout_date > '#{Time.now.to_date - 7}'").count
  end

  def self.new_orders_30
    Order.where("checkout_date > '#{Time.now.to_date - 30}'").count
  end

end
