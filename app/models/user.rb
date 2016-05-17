class User < ActiveRecord::Base
  has_many :addresses
  has_many :credit_cards
  has_many :orders
  has_many :products, :through => :orders


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
    User.select("users.first_name AS fname, users.last_name AS lname, AVG(p.price * oc.quantity) AS avg")
        .joins("JOIN orders o ON users.id = o.user_id")
        .joins("JOIN order_contents oc ON o.id = oc.order_id")
        .joins("JOIN products p ON oc.product_id = p.id")
        .where("o.checkout_date IS NOT NULL")
        .group("users.id")
        .order("avg DESC")
        .limit(1)

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











