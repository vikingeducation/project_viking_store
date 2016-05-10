class User < ActiveRecord::Base
  def self.total
    User.all.count
  end

  def self.new_users(t)
    User.where("created_at > ?", Time.now- t*24*60*60).count
  end

  def self.single_highest_value
    User.select("users.first_name AS fname, users.last_name AS lname, (p.price * oc.quantity) AS total")
        .joins("JOIN orders o ON users.id = o.user_id")
        .joins("JOIN order_contents oc ON o.id = oc.order_id ")
        .joins("JOIN products p ON oc.product_id = p.id")
        .where("o.checkout_date IS NOT NULL")
        .order("total DESC")
        .limit(1)
  end

  def self.highest_lifetime_value
    User.select("users.first_name AS fname, users.last_name AS lname, SUM(p.price * oc.quantity) AS total")
        .joins("JOIN orders o ON users.id = o.user_id")
        .joins("JOIN order_contents oc ON o.id = oc.order_id")
        .joins("JOIN products p ON oc.product_id = p.id")
        .where("o.checkout_date IS NOT NULL")
        .group("users.id")
        .order("total DESC")
        .limit(1)
  end

  def self.highest_average_value
    User.find_by_sql("SELECT users.first_name AS fname, users.last_name AS lname, AVG(total) 
                                                                                       FROM (
                                                                                       SELECT SUM(p.price * oc.quantity) AS total 
                                                                                       FROM
                      users JOIN orders o ON users.id = o.user_id
                      JOIN order_contents oc ON o.id = oc.order_id
                      JOIN products p ON oc.product_id = p.id
                      WHERE o.checkout_date IS NOT NULL
                      GROUP BY users.id
                      ORDER total DESC
                      LIMIT 1) t")

  end

  def self.most_orders_place
    User.select("users.first_name AS fname, users.last_name AS lname, COUNT(*) AS total")
        .joins("JOIN orders o ON users.id = o.user_id")
        .where("o.checkout_date IS NOT NULL")
        .group("users.id")
        .order("total DESC")
        .limit(1)

  end
end











