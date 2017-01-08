class User < ApplicationRecord

  def self.total(num_days=nil)
    if num_days
      User.where("created_at > ?", num_days.days.ago).count
    else
      User.all.count
    end
  end

  def self.highest_single_order_value
    User.select("MAX(quantity*price) as order_value, CONCAT(first_name, ' ', last_name) AS name")
    .joins("JOIN orders ON users.id = orders.user_id JOIN order_contents ON orders.id = order_contents.order_id JOIN products ON order_contents.product_id = product_id")
    .group("users.id")
    .order("order_value DESC")
    .limit(1)
  end

  def self.highest_lifetime_value
    User.select("SUM(quantity*price) as lifetime, CONCAT(first_name, ' ', last_name) AS name")
    .joins("JOIN orders ON users.id = orders.user_id JOIN order_contents ON orders.id = order_contents.order_id JOIN products ON order_contents.product_id = product_id")
    .group("users.id")
    .order("lifetime DESC")
    .limit(1)
  end

  def self.highest_average_order_value
    User.select("AVG(users.id) as average, CONCAT(first_name, ' ', last_name) AS name")
    .joins("JOIN orders ON users.id = orders.user_id")
    .group("users.id")
    .order("average DESC")
    .limit(1)
  end

  def self.most_orders_placed
    # User.find_by_sql("
    #   SELECT COUNT(users.id) AS num_orders, users.first_name, users.last_name
    #     FROM users
    #     JOIN orders ON users.id = orders.user_id
    #     GROUP BY users.id
    #     ORDER BY num_orders DESC
    #     LIMIT 1
    #   ")

    User.select("COUNT(users.id) AS num_orders, CONCAT(first_name, ' ', last_name) AS name")
        .joins("JOIN orders ON users.id = orders.user_id")
        .group("users.id")
        .order("num_orders DESC")
        .limit(1)
  end

end
