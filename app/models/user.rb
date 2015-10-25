class User < ActiveRecord::Base
  has_one :billing, :class_name => 'Address', :inverse_of => :user
  has_one :shipping, :class_name => 'Address', :inverse_of => :user
  has_many :orders
  has_many :addresses, :inverse_of => :user
  has_many :credit_cards
  has_many :order_contents, :through => :orders, :source => :items
  has_many :products, :through => :order_contents

  accepts_nested_attributes_for :billing,
                                :reject_if => :all_blank,
                                :allow_destroy => true

  accepts_nested_attributes_for :shipping,
                                :reject_if => :all_blank,
                                :allow_destroy => true

  accepts_nested_attributes_for :addresses,
                                :reject_if => :all_blank,
                                :allow_destroy => true

  validates :first_name,
            :presence => true,
            :length => {
              :minimun => 1,
              :maximum => 64
            }

  validates :last_name,
            :presence => true,
            :length => {
              :minimun => 1,
              :maximum => 64
            }

  validates :email,
            :presence => true,
            :length => {
              :minimun => 1,
              :maximum => 64
            },
            :format => /@/

  before_destroy :dissociate

  SUM_QUANTITY_PRICES = 'SUM(order_contents.quantity * products.price) AS amount'

  # --------------------------------
  # Public Instance Methods
  # --------------------------------

  # Dissociate the user from dependents
  def dissociate
    if placed_orders.present?
      false
    else
      addresses.destroy_all
      orders.destroy_all
      credit_cards.destroy_all
    end
  end

  # Returns the full name of the user
  def name
    "#{first_name} #{last_name}"
  end

  # Returns the user's cart
  def cart
    result = orders.where('checkout_date IS NULL')
      .limit(1)
      .to_a
    if result.present?
      result.first
    else
      order = orders.build(:shipping => shipping, :billing => billing)
      order
    end
  end

  # Returns the user's placed orders
  def placed_orders
    orders.where('checkout_date IS NOT NULL')
  end

  # Returns the amount spent by this user
  def spent
    sql = [
      'users.id AS user_id',
      SUM_QUANTITY_PRICES
    ].join(',')

    result = User.join_orders_products(sql)
      .group('users.id')
      .limit(1)
      .order('amount DESC')
      .where('users.id = ?', id)
      .to_a
      .first
    result ? result.amount.to_f : 0
  end

  # Returns the average amount spent by this user
  def avg_spent
    num_orders = orders.length
    num_orders == 0 ? 0 : spent / num_orders
  end

  # Returns true if a cart exists for this user
  def has_cart?
    cart.persisted?
  end

  # --------------------------------
  # Public Class Methods
  # --------------------------------

  # Returns a count of users
  # with a created_at date after the given date
  def self.count_since(date)
    User.where('created_at >= ?', date.to_date).count
  end

  # Returns an array of counts of users
  # in each state
  def self.count_by_state
    User.count_by_location('state')
      .to_a
  end

  # Returns an array of counts of users
  # in each city
  def self.count_by_city
    User.count_by_location('city')
      .to_a
  end

  # Returns user with the highest amount spent
  def self.with_max_spent
    sql = [
      'users.id AS user_id',
      SUM_QUANTITY_PRICES
    ].join(',')

    result = User.join_orders_products(sql)
      .group('users.id')
      .limit(1)
      .order('amount DESC')
      .to_a
      .first
    User.result_user_id_or_new(result)
  end

  # Returns the user with highest average amount spent
  def self.with_max_avg_spent
    sql = [
      'users.id AS user_id',
      'AVG(order_contents.quantity * products.price) AS amount'
      ].join(',')
    result = User.join_orders_products(sql)
      .group('users.id')
      .limit(1)
      .order('amount DESC')
      .to_a
      .first
    User.result_user_id_or_new(result)
  end

  # Returns the user with the most orders
  def self.with_max_orders
    result = User.join_grouped_orders
      .to_a
      .first
    User.result_user_id_or_new(result)
  end

  # Returns the user with the most checked out orders
  def self.with_max_placed_orders
    result = User.join_grouped_orders
      .where('orders.checkout_date IS NOT NULL')
      .to_a
      .first
    User.result_user_id_or_new(result)
  end


  private

  # --------------------------------
  # Private Class Methods
  # --------------------------------

  # Wraps reusable find user by id or instantiate new user
  def self.result_user_id_or_new(result)
    user = User.find(result.user_id) if result
    user || User.new
  end

  # Wraps reusable users join with orders grouped by user
  def self.join_grouped_orders
    sql = [
      'users.id AS user_id',
      'COUNT(orders.user_id) AS num_orders'
    ].join(',')

    User.select(sql)
      .joins('JOIN orders ON users.id = orders.user_id')
      .group('users.id')
      .limit(1)
      .order('num_orders DESC')
  end

  # Wraps reusable join on users, orders, order_contents and products
  def self.join_orders_products(sql='*')
    OrderContent.select(sql)
      .joins(:product)
      .joins(:order)
      .joins('JOIN users ON users.id = orders.user_id')
  end

  def self.count_by_location(type)
    singular = type.singularize
    plural = type.pluralize
    User.select("#{plural}.name AS #{singular}_name, COUNT(users.id) AS num_users")
      .joins("JOIN addresses ON addresses.id = users.billing_id")
      .joins("JOIN #{plural} ON #{plural}.id = addresses.#{singular}_id")
      .group("#{plural}.name")
      .order("num_users DESC")
  end
end
