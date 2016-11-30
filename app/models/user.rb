class User < ApplicationRecord

  def self.get_new_user_count(n_of_days = nil)
    return total_user_count unless n_of_days

    User.where("created_at > NOW() - INTERVAL '? days'",
                n_of_days).count
  end

  def self.total_user_count
    User.count
  end

  def self.join_orders_products
    joins("JOIN orders ON users.id=orders.user_id JOIN order_contents ON orders.id=order_id JOIN products ON products.id=product_id")
  end

end
