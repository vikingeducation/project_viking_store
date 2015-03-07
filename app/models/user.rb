class User < ActiveRecord::Base

  has_many :addresses
  has_many :credit_cards
  has_many :orders
  has_one :shipping_address,
          class_name: "Address",
          foreign_key: :user_id
  has_one :billing_address,
          class_name: "Address",
          foreign_key: :user_id

  def self.new_since(time)
    date = Date.new(time.year,time.month,time.day)
    User.where("created_at > ?", date).count
  end

  def self.states_by_shipping_address
    User.select("states.name, COUNT(*) AS users_by_state").
      joins("JOIN addresses ON users.shipping_id = addresses.id JOIN states ON addresses.state_id = states.id").
      group("states.name").
      order("users_by_state DESC").
      limit(3)
  end

  def self.cities_by_shipping_address
    User.select("cities.name, COUNT(*) AS users_by_city").
      joins("JOIN addresses ON users.shipping_id = addresses.id JOIN cities ON addresses.state_id = cities.id").
      group("cities.name").
      order("users_by_city DESC").
      limit(3)
  end

  def self.highest_single_order_value
    User.select("first_name, last_name, quantity * price AS order_value").
      joins("JOIN orders ON users.id = orders.user_id JOIN order_contents ON orders.id = order_contents.order_id JOIN products ON products.id = order_contents.product_id").
      where("checkout_date IS NOT NULL").
      group("orders.id").
      order("order_value DESC").
      limit(1).
      first
  end

  def self.highest_lifetime_value
    User.select("first_name, last_name, SUM(quantity * price) AS lifetime_orders").
      joins("JOIN orders ON users.id = orders.user_id JOIN order_contents ON orders.id = order_contents.order_id JOIN products ON products.id = order_contents.product_id").
      where("checkout_date IS NOT NULL").
      group("users.id").
      order("lifetime_orders DESC").
      limit(1).
      first
  end

  def self.highest_average_order_value
    User.select("first_name, last_name, AVG(quantity * price) AS average_order").
      joins("JOIN orders ON users.id = orders.user_id JOIN order_contents ON orders.id = order_contents.order_id JOIN products ON products.id = order_contents.product_id").
      where("checkout_date IS NOT NULL").
      group("users.id").
      order("average_order DESC").
      limit(1).
      first
  end

  def self.most_orders_placed
    User.select("first_name, last_name, COUNT(*) AS orders_placed").
      joins("JOIN orders ON users.id = orders.user_id").
      where("checkout_date IS NOT NULL").
      group("users.id").
      order("orders_placed DESC").
      limit(1).
      first
  end
end
