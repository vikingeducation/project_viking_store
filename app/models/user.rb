class User < ActiveRecord::Base

  def self.in_last(days = nil)
    if days.nil?
      self.count
    else
      self.where('created_at > ?', DateTime.now - days).count
    end
  end

  def self.top_states(limit = 3)
    self.select('states.name, COUNT(addresses.state_id)').
    joins('JOIN addresses ON users.billing_id = addresses.id JOIN states ON states.id = addresses.state_id').
    group('states.name').order('COUNT(addresses.state_id) DESC').
    limit(limit)
  end

  def self.top_cities(limit = 3)
    self.select('cities.name, COUNT(addresses.city_id)').
    joins('JOIN addresses ON users.billing_id = addresses.id JOIN cities ON cities.id = addresses.city_id').
    group('cities.name').order('COUNT(addresses.city_id) DESC').
    limit(limit)
  end

  def self.high_single_order_value
    self.select('users.first_name, SUM(products.price * order_contents.quantity) as cost').joins('JOIN orders ON users.id = orders.user_id JOIN order_contents ON order_contents.order_id = orders.id JOIN products ON order_contents.product_id = products.id').group('orders.id').order('cost DESC').limit(1)
  end


end
