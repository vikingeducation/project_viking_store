class User < ApplicationRecord
  has_many :addresses, dependent: :destroy
  has_many :orders, dependent: :nullify
  has_many :order_contents, through: :orders
  has_many :products, through: :order_contents
  has_one :default_billing_address, foreign_key: :id, primary_key: :billing_id, :class_name => 'Address'
  has_one :default_shipping_address, foreign_key: :id, primary_key: :shipping_id, :class_name => 'Address'
  has_one :city, through: :default_shipping_address
  has_one :state, through: :default_shipping_address
  has_many :credit_cards, dependent: :nullify
  accepts_nested_attributes_for :addresses


  validates :first_name, :last_name, :email, presence: true, length: {in: 1..64 }
  validates :email, format: { with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i, on: :create }


  def full_name
    self.first_name + ' '  + self.last_name
  end

  def order_count
    self.orders.where('checkout_date IS NOT NULL').count
  end

  def print_billing_address
    if self.billing_id
      add = self.default_billing_address
      add.street_address + ', ' + add.city.name + ', ' + add.state.name
    end
  end

  def print_shipping_address
    if self.shipping_id
      add = self.default_shipping_address
      add.street_address + ', ' + add.city.name + ', ' + add.state.name
    end
  end

  def last_order_date(formatting=nil)
    formatting ||= '%d/%m/%y'
    records = self.orders.where('checkout_date IS NOT NULL').order('checkout_date DESC')
    records.empty? ? 'N/A' : records.first.checkout_date.strftime(formatting)
  end

  def self.new_users_count(days_ago=7, n=0)
    u = User.where("created_at <= current_date - '#{n * days_ago} days'::interval AND created_at > current_date - '#{(n + 1) * days_ago} days'::interval").count
  end

  def self.top_customer_by_area(type, name)
    plur = type == 'city' ? 'cities' : type + 's'

    u = User.select('SUM(quantity * price) as value, first_name, last_name').join_users_with_orders.joins('JOIN addresses ON addresses.id = orders.billing_id').join_users_with_order_contents.join_users_with_products.joins("JOIN #{plur} ON #{plur}.id = #{type}_id").checked_out.where("#{plur}.name = '#{name}'").group('users.id, first_name, last_name').order('value DESC')
  end

  def self.top_area(type, limit=nil)
    limit ||= 3
    plur = type == 'city' ? 'cities' : type + 's'
    top = find_by_sql "SELECT COUNT(#{plur}.name) as count, #{plur}.name as name FROM users JOIN addresses ON users.billing_id = addresses.id JOIN #{plur} ON #{plur}.id = addresses.#{type}_id GROUP BY #{plur}.name ORDER BY count DESC LIMIT #{limit}"
    top.map do |t|
      c = top_customer_by_area(type, t.name).first
      [t.name, t.count, c.first_name + ' ' + c.last_name + " (#{c.value.to_s(:currency, precision:0)})" ]
    end
  end


  def self.highest_single_order
    limit ||= 1
    u = User.select('first_name, last_name, order_id, SUM(price * quantity) AS amount').join_users_with_orders.join_users_with_order_contents.join_users_with_products.checked_out.group('order_id, users.first_name, users.last_name').order('amount DESC').first
    ['Highest Single Order', u.first_name + ' '  + u.last_name, u.amount.round.to_s(:currency, precision: 0) ]
  end

  def self.highest_lifetime_order
    u = User.select('users.id, first_name, last_name, SUM(price * quantity) AS amount').join_users_with_orders.join_users_with_order_contents.join_users_with_products.checked_out.group('users.id, first_name, last_name').order('amount DESC').first
    ['Highest Lifetime Order', u.first_name + ' ' + u.last_name, u.amount.round.to_s(:currency, precision: 0)]
  end

  def self.highest_average_order
    u = User.select('users.id, first_name, last_name, AVG(price * quantity) AS total').join_users_with_orders.join_users_with_order_contents.join_users_with_products.checked_out.group('users.id, first_name,  last_name').order('total DESC').first
    ['Highest Average Order', u.first_name + ' '  + u.last_name, u.total.round.to_s(:currency, precision: 0) ]
  end

  def self.most_orders_placed
    u = User.select('users.id, first_name, last_name, COUNT(*) AS count').join_users_with_orders.checked_out.group('users.id, first_name, last_name').order('count DESC').first
    ['Most Orders Placed', u.first_name + ' '  + u.last_name, u.count ]
  end

  def self.join_users_with_order_contents
    joins('JOIN order_contents ON order_contents.order_id = orders.id')
  end

  def self.join_users_with_products
    joins('JOIN products ON products.id = order_contents.product_id')
  end

  def self.join_users_with_orders
    joins('JOIN orders ON users.id = orders.user_id')
  end

  def self.checked_out
    where('orders.checkout_date IS NOT NULL')
  end




end
