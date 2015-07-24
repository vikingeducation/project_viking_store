class User < ActiveRecord::Base

  def self.in_last(days = nil)
    if days.nil?
      self.count
    else
      self.where('created_at > ?', DateTime.now - days).count
    end
  end

  def self.get_overall
    overall = {'Last 7 Days' => 7, 'Last 30 Days' => 30, 'Total' => nil}
    overall.each do |key, limit|
      result = []
      result << ["New Users", self.in_last(limit)]
      result << ["Orders", Order.in_last(limit)]
      result << ["New Products", Product.in_last(limit)]
      result << ["Revenue", Order.revenue_in_last(limit)]
      overall[key] = result
    end
    overall
  end

  def self.get_demographics
    demographics = {'Top 3 states' => [], 'Top 3 cities' => [] }
    self.top_states.each do |state|
      demographics['Top 3 states'] << [state.name, state.total]
    end

    self.top_cities.each do |state|
      demographics['Top 3 cities'] << [state.name, state.total]
    end
    demographics
  end

  def self.get_superlatives
    superlatives = {}
    highest_s = User.high_single_order_value.first
    superlatives['Highest Single Order Value'] = [highest_s.full_name,
                                                   highest_s.cost]
    highest_l = User.high_lifetime_value.first
    superlatives['Highest Lifetime Value'] = [highest_l.full_name,
                                               highest_l.cost]
    highest_a = User.high_average_value.first
    superlatives['Highest Average Order Value'] = [highest_a.full_name,
                                                    highest_a.average_value]
    m_orders = User.most_orders.first
    superlatives['Most Orders Placed'] = [m_orders.full_name,
                                           m_orders.number_of_orders]
    return superlatives
  end

  private

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
