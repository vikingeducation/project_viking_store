class User < ActiveRecord::Base
  has_one :billing, :class_name => 'Address'
  has_one :shipping, :class_name => 'Address'
  has_many :orders
  has_many :addresses
  has_many :credit_cards

  # Returns the amount spent by this user
  def spent
    sql = 'users.id AS user_id, SUM(order_contents.quantity * products.price) AS amount'
    OrderContent.select(sql)
      .joins(:product)
      .joins(:order)
      .joins('JOIN users ON users.id = orders.user_id')
      .group('users.id')
      .limit(1)
      .order('amount DESC')
      .to_a
      .first
      .amount
      .to_f
  end

  # Returns the average amount spent by this user
  def avg_spent
    sql = 'users.id AS user_id, AVG(order_contents.quantity * products.price) AS amount'
    OrderContent.select(sql)
      .joins(:product)
      .joins(:order)
      .joins('JOIN users ON users.id = orders.user_id')
      .group('users.id')
      .limit(1)
      .order('amount DESC')
      .to_a
      .first
      .amount
      .to_f
  end

  # Returns a count of users
  # with a created_at date after the given date
  def self.count_since(date)
    User.where('created_at > ?', date).count
  end

  # Returns an array of counts of users
  # in each state
  def self.count_by_state
    User.select('states.name AS state_name, COUNT(users.id) AS num_users')
      .joins('JOIN addresses ON addresses.id = users.billing_id')
      .joins('JOIN states ON states.id = addresses.state_id')
      .group('states.name')
      .order('num_users DESC')
      .to_a
  end

  # Returns an array of counts of users
  # in each city
  def self.count_by_city
    User.select('cities.name AS city_name, COUNT(users.id) AS num_users')
      .joins('JOIN addresses ON addresses.id = users.billing_id')
      .joins('JOIN cities ON cities.id = addresses.city_id')
      .group('cities.name')
      .order('num_users DESC')
      .to_a
  end

  # Returns user with the highest amount spent
  def self.with_max_spent
    sql = 'users.id AS user_id, SUM(order_contents.quantity * products.price) AS amount'
    user_id = OrderContent.select(sql)
      .joins(:product)
      .joins(:order)
      .joins('JOIN users ON users.id = orders.user_id')
      .group('users.id')
      .limit(1)
      .order('amount DESC')
      .to_a
      .first
      .user_id
    User.find(user_id)
  end

  # Returns the user with highest average amount spent
  def self.with_max_avg_spent
    sql = 'users.id AS user_id, AVG(order_contents.quantity * products.price) AS amount'
    user_id = OrderContent.select(sql)
      .joins(:product)
      .joins(:order)
      .joins('JOIN users ON users.id = orders.user_id')
      .group('users.id')
      .limit(1)
      .order('amount DESC')
      .to_a
      .first
      .user_id
    User.find(user_id)
  end

  # Returns the user with the most orders
  def self.with_max_orders
    sql = 'users.id AS user_id, COUNT(orders.user_id) AS num_orders'
    user_id = User.select(sql)
      .joins('JOIN orders ON users.id = orders.user_id')
      .group('users.id')
      .limit(1)
      .order('num_orders DESC')
      .to_a
      .first
      .user_id
    User.find(user_id)
  end

  # Returns the user with the most checked out orders
  def self.with_max_placed_orders
    sql = 'users.id AS user_id, COUNT(orders.user_id) AS num_orders'
    user_id = User.select(sql)
      .joins('JOIN orders ON users.id = orders.user_id')
      .where('orders.checkout_date IS NOT NULL')
      .group('users.id')
      .limit(1)
      .order('num_orders DESC')
      .to_a
      .first
      .user_id
    User.find(user_id)
  end
end
