class User < ActiveRecord::Base
  def self.created_since(time)
    where('created_at >= ?', time).count
  end

  def self.total
    count
  end

  def self.top_3_billing_states
    select('states.name, COUNT(*) AS total')
      .joins('JOIN addresses ON users.billing_id = addresses.id JOIN states ON addresses.state_id = states.id')
      .group('states.name')
      .order('total DESC')
      .limit(3)
  end

  def self.top_3_billing_cities
    select('cities.name, COUNT(*) AS total')
      .joins('JOIN addresses ON users.billing_id = addresses.id JOIN cities ON addresses.city_id = cities.id')
      .group('cities.name')
      .order('total DESC')
      .limit(3)
  end

  def self.highest_single_order
    # TRIPLE JOIN INCOMING
    select('first_name, last_name, quantity * price AS top_order')
      .joins('JOIN orders ON users.id = orders.user_id JOIN order_contents ON orders.id = order_contents.order_id JOIN products ON order_contents.product_id = products.id')
      .where('checkout_date IS NOT NULL')
      .group('orders.id')
      .order('top_order DESC')
      .limit(1).first
  end

  def self.highest_lifetime_value
    # TRIPLE JOIN INCOMING
    select('first_name, last_name, SUM(quantity * price) AS consumerism')
      .joins('JOIN orders ON users.id = orders.user_id JOIN order_contents ON orders.id = order_contents.order_id JOIN products ON order_contents.product_id = products.id')
      .where('checkout_date IS NOT NULL')
      .group('users.id')
      .order('consumerism DESC')
      .limit(1).first
  end

  def self.highest_avg_order
    # TRIPLE JOIN INCOMING
    select('first_name, last_name, AVG(quantity * price) AS avg_val')
      .joins('JOIN orders ON users.id = orders.user_id JOIN order_contents ON orders.id = order_contents.order_id JOIN products ON order_contents.product_id = products.id')
      .where('checkout_date IS NOT NULL')
      .group('users.id')
      .order('avg_val DESC')
      .limit(1).first
  end

  def self.most_orders
    select('first_name, last_name, COUNT(*) AS placed_orders')
    .joins('JOIN orders ON users.id = orders.user_id')
    .where('checkout_date IS NOT NULL')
    .group('users.id')
    .order('placed_orders DESC')
    .limit(1).first
  end
end
