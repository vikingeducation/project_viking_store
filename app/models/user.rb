class User < ActiveRecord::Base

  validates :first_name, :last_name,
            length: { maximum: 64,
                      minimum: 1 },
            presence: true
  validates :email,
            format: { with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i },
            presence: true
  has_many :addresses, # dependent: :destroy
  has_many :orders
  has_many :order_contents, through: :orders
  has_many :products, through: :order_contents
  has_many :credit_cards, dependent: :destroy
  belongs_to :shipping_address, class_name: "Address", foreign_key: :shipping_id
  belongs_to :billing_address, class_name: "Address", foreign_key: :billing_id

  accepts_nested_attributes_for :addresses

  def self.created_since(time)
    where('created_at >= ?', time).count
  end

  def self.total
    count
  end

  # selects the top 3 states based on number of users
  def self.top_3_billing_states
    select('states.name, COUNT(*) AS total')
      .joins('JOIN addresses ON users.billing_id = addresses.id JOIN states ON addresses.state_id = states.id')
      .group('states.name')
      .order('total DESC')
      .limit(3)
  end

  # selects the top 3 cities based on number of users
  def self.top_3_billing_cities
    select('cities.name, COUNT(*) AS total')
      .joins('JOIN addresses ON users.billing_id = addresses.id JOIN cities ON addresses.city_id = cities.id')
      .group('cities.name')
      .order('total DESC')
      .limit(3)
  end

  # selects the highest valued order of all orders and the first, last name of the customer who placed it
  def self.highest_single_order
    # TRIPLE JOIN INCOMING
    select('first_name, last_name, quantity * price AS top_order')
      .joins('JOIN orders ON users.id = orders.user_id JOIN order_contents ON orders.id = order_contents.order_id JOIN products ON order_contents.product_id = products.id')
      .where('checkout_date IS NOT NULL')
      .group('orders.id')
      .order('top_order DESC')
      .limit(1).first
  end

  # selects the highest lifetime value of placed orders and the first, last name of the customer who placed them
  def self.highest_lifetime_value
    # TRIPLE JOIN INCOMING
    select('first_name, last_name, SUM(quantity * price) AS consumerism')
      .joins('JOIN orders ON users.id = orders.user_id JOIN order_contents ON orders.id = order_contents.order_id JOIN products ON order_contents.product_id = products.id')
      .where('checkout_date IS NOT NULL')
      .group('users.id')
      .order('consumerism DESC')
      .limit(1).first
  end

  # selects the highest average order price and the first, last name of the customer who placed them
  def self.highest_avg_order
    # TRIPLE JOIN INCOMING
    select('first_name, last_name, AVG(quantity * price) AS avg_val')
      .joins('JOIN orders ON users.id = orders.user_id JOIN order_contents ON orders.id = order_contents.order_id JOIN products ON order_contents.product_id = products.id')
      .where('checkout_date IS NOT NULL')
      .group('users.id')
      .order('avg_val DESC')
      .limit(1).first
  end

  # selects the number of the most placed orders and the first, last name of the customer who placed them
  def self.most_orders
    select('first_name, last_name, COUNT(*) AS placed_orders')
      .joins('JOIN orders ON users.id = orders.user_id')
      .where('checkout_date IS NOT NULL')
      .group('users.id')
      .order('placed_orders DESC')
      .limit(1).first
  end
end
