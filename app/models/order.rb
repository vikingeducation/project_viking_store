class Order < ApplicationRecord

  def get_order_count(n_of_days)
    Order.where("checkout_date > NOW() - INTERVAL '? days'", n_of_days).count
  end

end
