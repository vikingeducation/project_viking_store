class User < ApplicationRecord

  has_many :addresses, :dependent => :destroy
  belongs_to :default_billing_address, class_name: "Address", :foreign_key => :billing_id, :dependent => :destroy
  belongs_to :default_shipping_address, class_name: "Address", :foreign_key => :shipping_id, :dependent => :destroy
  has_one :credit_card, :dependent => :destroy

  has_many :orders
  has_many :order_contents, :through => :orders
  has_many :products, :through => :order_contents, :source => :order #User.first.products

  validates :first_name, 
            :last_name, 
            length: { maximum: 250 }, 
            presence: true


  def self.seven_days_users
    where('created_at > ?', (Time.zone.now.end_of_day - 7.days)).count
  end

  def self.month_users
    where('created_at > ?', (Time.zone.now.end_of_day - 30.days)).count
  end

  def self.total_users
    count
  end

  def self.top_three_states
    select("count(users.*) AS num_users, states.name").
    joins("JOIN orders ON orders.user_id = users.id").
    joins("JOIN addresses ON addresses.id = orders.billing_id").
    joins("JOIN states ON states.id = addresses.state_id").
    group('states.id').
    order('num_users desc').
    limit(3).distinct
  end

  def self.top_three_cities
    select("count(users.*) AS num_users, cities.name").
    joins("JOIN orders ON orders.user_id = users.id").
    joins("JOIN addresses ON addresses.id = orders.billing_id").
    joins("JOIN cities ON cities.id = addresses.state_id").
    group('cities.id').
    order('num_users desc').
    limit(3).distinct
  end

  def self.highest_order_val
    select("users.first_name, users.last_name, order_contents.quantity*products.price AS order_value").
    joins("JOIN orders ON orders.user_id = users.id").
    joins("JOIN order_contents ON orders.id = order_contents.order_id").
    joins("JOIN products ON products.id = order_contents.product_id").
    where.not('orders.checkout_date' => nil).
    order("order_value desc").
    limit(1)
  end

  def self.highest_lifetime_val
    select("users.first_name, users.last_name, SUM(order_contents.quantity*products.price) AS all_orders_value").
    joins("JOIN orders ON orders.user_id = users.id").
    joins("JOIN order_contents ON orders.id = order_contents.order_id").
    joins("JOIN products ON products.id = order_contents.product_id").
    where.not('orders.checkout_date' => nil).
    group("users.id").
    order("all_orders_value desc").
    limit(1)
  end

  def self.highest_avg_order_val
    select("users.first_name, users.last_name, AVG(order_contents.quantity*products.price) AS avg_value").
      joins("JOIN orders ON orders.user_id = users.id").
      joins("JOIN order_contents ON orders.id = order_contents.order_id").
      joins("JOIN products ON products.id = order_contents.product_id").
      where.not('orders.checkout_date' => nil).
      group("users.id").
      order("avg_value desc").
      limit(1)
  end

  def self.most_orders
    select("users.first_name, users.last_name, count(orders.id) AS no_of_orders").
      joins("JOIN orders ON orders.user_id = users.id").
      where.not('orders.checkout_date' => nil).
      group("users.id").
      order("no_of_orders desc").
      limit(1)
  end


end