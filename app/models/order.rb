class Order < ApplicationRecord

  def self.get_order_count(n_of_days = nil)
    return total_order_count unless n_of_days

    Order.where("checkout_date > NOW() - INTERVAL '? days'",
                n_of_days).count
  end

  def self.total_order_count
    Order.count(:checkout_date)
  end
end
