class User < ActiveRecord::Base

  def self.in_last(days = nil)
    if days.nil?
      self.count
    else
      self.where('created_at > ?', DateTime.now - days).count
    end
  end

  def self.top_states(limit = 3)
    self.select('states.name, COUNT(addresses.state_id) AS total').
    joins('JOIN addresses ON users.billing_id = addresses.id JOIN states ON states.id = addresses.state_id').
    group('states.name').order('COUNT(addresses.state_id) DESC').
    limit(limit)
  end

  def self.top_cities(limit = 3)
    self.select('cities.name, COUNT(addresses.city_id) AS total').
    joins('JOIN addresses ON users.billing_id = addresses.id JOIN cities ON cities.id = addresses.city_id').
    group('cities.name').order('COUNT(addresses.city_id) DESC').
    limit(limit)
  end

  def self.high_single_order_value
    self.select('users.first_name || users.last_name AS full_name, SUM(products.price * order_contents.quantity) as cost').
    joins('JOIN orders ON users.id = orders.user_id JOIN order_contents ON order_contents.order_id = orders.id JOIN products ON order_contents.product_id = products.id').
    where("orders.checkout_date NOT NULL").
    group('orders.id').order('cost DESC').limit(1)
  end

  def self.high_lifetime_value
    self.select('users.first_name || users.last_name AS full_name, SUM(products.price * order_contents.quantity) as cost').
    joins('JOIN orders ON users.id = orders.user_id JOIN order_contents ON order_contents.order_id = orders.id JOIN products ON order_contents.product_id = products.id').
    where("orders.checkout_date NOT NULL").
    group('users.id').order('cost DESC').limit(1)
  end

  def self.high_average_value
    self.select('users.first_name || users.last_name AS full_name, SUM(products.price * order_contents.quantity)/(COUNT(DISTINCT orders.id)) as average_value').
    joins('JOIN orders ON users.id = orders.user_id JOIN order_contents ON order_contents.order_id = orders.id JOIN products ON order_contents.product_id = products.id').
    where("orders.checkout_date NOT NULL").
    group('users.id').order('average_value DESC').limit(1)
  end

  def self.most_orders
    self.select('users.first_name || users.last_name AS full_name, COUNT(orders.id) as number_of_orders').
    joins('JOIN orders ON users.id = orders.user_id').
    where("orders.checkout_date NOT NULL").
    group('users.id').order('number_of_orders DESC').limit(1)
  end


end
